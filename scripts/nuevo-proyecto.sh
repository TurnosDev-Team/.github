#!/usr/bin/env bash
# Crea un proyecto nuevo de TurnosDev-Team listo para trabajar:
#   repo desde la plantilla, etiquetas, etapas (milestones)
#   y las tareas estándar cargadas en el tablero general.
#
# Uso (desde Git Bash, con `gh auth login` hecho):
#   bash scripts/nuevo-proyecto.sh <nombre-del-repo> "<Nombre del negocio>" [--dry-run]
#
# Ejemplo:
#   bash scripts/nuevo-proyecto.sh web-gimnasio-norte "Gimnasio Norte" --dry-run   # muestra qué haría
#   bash scripts/nuevo-proyecto.sh web-gimnasio-norte "Gimnasio Norte"             # lo hace
set -euo pipefail

ORG=TurnosDev-Team
PLANTILLA=$ORG/plantilla-proyecto
TABLERO=1                              # número del "Tablero general"
# El acceso no hace falta darlo: todos los miembros de la org tienen escritura en todos los repos.

REPO=${1:-}; CLIENTE=${2:-}; DRY=${3:-}
if [[ -z "$REPO" || -z "$CLIENTE" ]]; then
  sed -n '6,11p' "$0"; exit 1
fi
if [[ ! "$REPO" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "El nombre del repo va en minúscula y con guiones (ej. web-gimnasio-norte)"; exit 1
fi
R=$ORG/$REPO

run() { if [[ "$DRY" == "--dry-run" ]]; then echo "[dry-run] $*"; else "$@"; fi; }
paso() { echo; echo "==> $*"; }

# ---------------------------------------------------------------- repo
paso "Creando $R desde la plantilla"
if gh repo view "$R" >/dev/null 2>&1; then
  echo "El repo ya existe, sigo con el resto (etiquetas e issues se pueden duplicar)."
else
  run gh repo create "$R" --private --template "$PLANTILLA" --description "Web para $CLIENTE"
  [[ "$DRY" == "--dry-run" ]] || sleep 5   # GitHub tarda unos segundos en copiar la plantilla
fi

# ---------------------------------------------------------------- etiquetas
paso "Etiquetas"
for l in bug documentation enhancement invalid question wontfix "help wanted"; do
  run gh label delete "$l" -R "$R" --yes >/dev/null 2>&1 || true
done
while IFS='|' read -r nombre color desc; do
  run gh label create "$nombre" -R "$R" --color "$color" --description "$desc" --force
done <<'EOF'
tipo: feature|1D76DB|Funcionalidad nueva
tipo: bug|D73A4A|Algo no funciona
tipo: tarea|C5DEF5|Configuración, reunión, organización
tipo: diseño|D876E3|Diseño visual, bocetos, identidad
tipo: docs|0075CA|Documentación y manuales
área: frontend|FBCA04|Vistas, Blade, Tailwind
área: backend|5319E7|Lógica, controladores, modelos
área: base de datos|006B75|Migraciones, modelos de datos
área: deploy|0E8A16|Render, Docker, dominio
prioridad: alta|B60205|Hacer primero
prioridad: media|FF9F1C|Importante pero puede esperar
prioridad: baja|C2E0C6|Cuando haya tiempo
bloqueado|000000|No se puede avanzar por algo externo
necesita info del cliente|F9D0C4|Esperando respuesta o datos del negocio
EOF

# ---------------------------------------------------------------- etapas
paso "Etapas (milestones)"
M1="1 · Relevamiento y diseño"; M2="2 · MVP"; M3="3 · Extras"; M4="4 · Lanzamiento"
existentes=$(gh api "repos/$R/milestones?state=all" --jq '.[].title' 2>/dev/null || true)
while IFS='|' read -r titulo desc; do
  if grep -qxF "$titulo" <<<"$existentes"; then echo "ya existe: $titulo"; continue; fi
  run gh api "repos/$R/milestones" -f title="$titulo" -f description="$desc" --silent
done <<EOF
$M1|Reunión con el cliente, alcance, diseño y proyecto base
$M2|Lo mínimo para que el negocio pueda usar la web
$M3|Lo que suma pero puede esperar
$M4|Requisitos, tests, deploy, dominio y entrega al cliente
EOF

# ---------------------------------------------------------------- tablero
paso "Leyendo el tablero general"
PROJ=$(gh project view $TABLERO --owner $ORG --format json --jq .id)
campos() { gh project field-list $TABLERO --owner $ORG --format json --jq "$1"; }
SF=$(campos '.fields[]|select(.name=="Status").id')
PF=$(campos '.fields[]|select(.name=="Prioridad").id')
CF=$(campos '.fields[]|select(.name=="Cliente").id')
declare -A OPC   # "Campo/Opción" -> id
while IFS=$'\t' read -r k v; do OPC[$k]=$v; done < <(
  campos '.fields[]|select(.name=="Status" or .name=="Prioridad")|.name as $c|.options[]|"\($c)/\(.name)\t\(.id)"')
opcion() { echo "${OPC[$1/$2]}"; }
if [[ -z "$SF" || -z "$PF" || -z "$CF" || -z "$(opcion Status Backlog)" ]]; then
  echo "No encontré los campos Status/Prioridad/Cliente en el tablero $TABLERO"; exit 1
fi

# tarea MILESTONE STATUS PRIORIDAD "etiquetas" "título" "cuerpo"
tarea() {
  local ms=$1 st=$2 pr=$3 labels=$4 title=$5 body=$6
  if [[ "$DRY" == "--dry-run" ]]; then echo "[dry-run] issue: [$ms] [$st/$pr] $title"; return; fi
  local url item
  url=$(gh issue create -R "$R" --title "$title" --body "$body" --label "$labels" --milestone "$ms")
  item=$(gh project item-add $TABLERO --owner $ORG --url "$url" --format json --jq .id)
  gh project item-edit --project-id "$PROJ" --id "$item" --field-id "$SF" --single-select-option-id "$(opcion Status "$st")" >/dev/null
  gh project item-edit --project-id "$PROJ" --id "$item" --field-id "$PF" --single-select-option-id "$(opcion Prioridad "$pr")" >/dev/null
  gh project item-edit --project-id "$PROJ" --id "$item" --field-id "$CF" --text "$CLIENTE" >/dev/null
  echo "$url  $title"
}

paso "Cargando tareas estándar"
REQ=https://github.com/$ORG/.github/blob/main/REQUISITOS.md
NUEVO=https://github.com/$ORG/.github/blob/main/NUEVO-PROYECTO.md

tarea "$M1" "Por hacer" Alta "tipo: tarea,necesita info del cliente" "Reunión de relevamiento con $CLIENTE" \
"Primera reunión para entender el negocio. Ver la sección 1 del [checklist de proyecto nuevo]($NUEVO).

- [ ] Qué vende, a quién, qué problema quiere resolver con la web
- [ ] Datos: nombre, dirección, teléfono, WhatsApp, horarios, redes
- [ ] Qué necesita la web: ¿info? ¿turnos? ¿catálogo? ¿pagos?
- [ ] Logo, colores y fotos
- [ ] Presupuesto y plazos acordados por escrito
- [ ] Respuestas anotadas en este issue"

tarea "$M1" "Por hacer" Alta "tipo: tarea" "Definir alcance del MVP" \
"Qué entra en la primera versión y qué queda para después.

- [ ] Lista del MVP aprobada por el cliente
- [ ] Una issue por cada funcionalidad del MVP en la etapa **$M2**
- [ ] Lo que queda afuera, como issues en **$M3** con \`prioridad: baja\`
- [ ] Decisión anotada en \`docs/DECISIONES.md\`"

tarea "$M1" "Por hacer" Media "tipo: diseño,área: frontend,necesita info del cliente" "Identidad visual: logo, colores y tipografía" \
"- [ ] Logo en buena calidad
- [ ] Colores con contraste accesible, cargados en \`tailwind.config.js\`
- [ ] Tipografía (Google Fonts)
- [ ] Fotos del negocio (con permiso)"

tarea "$M1" "Por hacer" Media "tipo: diseño,área: frontend" "Bocetos de pantallas (mobile first)" \
"- [ ] Portada del negocio
- [ ] Pantallas de la funcionalidad principal
- [ ] Panel del dueño
- [ ] Mostrarlos al cliente y anotar cambios"

tarea "$M1" "Por hacer" Alta "tipo: tarea,área: backend,área: deploy" "Crear proyecto Laravel base" \
"Stack por defecto (ver la guía). Si existe una base reutilizable de otro proyecto, partir de ahí.

- [ ] Laravel + Breeze (Blade) + Tailwind + Alpine + Pest
- [ ] \`.env.example\`, zona horaria \`America/Argentina/Buenos_Aires\`, locale \`es\`
- [ ] Dockerfile + \`render.yaml\`
- [ ] Completar el README (ficha del proyecto, cómo correrlo)
- [ ] El workflow de tests de la plantilla pasa en verde"

tarea "$M1" "Por hacer" Alta "tipo: tarea,área: base de datos" "Modelo de datos" \
"- [ ] Tablas y relaciones definidas (tabla o diagrama en \`docs/\`)
- [ ] Migraciones, modelos, factories y seeders con datos de ejemplo"

tarea "$M2" "Backlog" Alta "tipo: feature,área: frontend" "Página pública del negocio" \
"- [ ] Nombre, logo, fotos y llamado a la acción principal
- [ ] Dirección con mapa, horarios, redes y botón de WhatsApp
- [ ] Responsive y rápida (imágenes WebP)"

tarea "$M2" "Backlog" Alta "tipo: feature,área: backend,área: frontend" "Panel de administración base" \
"Ver la sección **Panel de administración** de [REQUISITOS.md]($REQ).

- [ ] Login en \`/admin\` y rol de dueño/admin
- [ ] Editar datos del negocio (horarios, contacto, redes)
- [ ] Cambiar contraseña
- [ ] Usable desde el celular"

tarea "$M2" "Backlog" Alta "tipo: feature" "Funcionalidad principal: COMPLETAR" \
"Cambiar el título por la funcionalidad principal del negocio (turnos, catálogo, pedidos, reservas...) y dividirla en varias issues cuando se defina el alcance."

tarea "$M4" "Backlog" Alta "tipo: tarea" "Pasar el checklist de REQUISITOS.md" \
"Revisar completo [REQUISITOS.md]($REQ) antes de entregar: seguridad, panel admin, parte pública, accesibilidad, SEO, legal, backups y calidad. Lo que no aplique, tacharlo y explicar por qué acá."

tarea "$M4" "Backlog" Alta "tipo: tarea,área: backend" "Tests de los flujos principales" \
"- [ ] Tests de lo que el negocio no puede perder (reservas, pedidos, login, pagos)
- [ ] Workflow de tests en verde en cada PR"

tarea "$M4" "Backlog" Alta "tipo: tarea,área: deploy" "Deploy a producción" \
"- [ ] Servicio en Render + base PostgreSQL + backups
- [ ] Variables de entorno cargadas (nunca en el repo), \`APP_DEBUG=false\`
- [ ] Mails de producción
- [ ] Completar \`docs/DEPLOY.md\`"

tarea "$M4" "Backlog" Media "tipo: tarea,área: deploy,necesita info del cliente" "Dominio, SEO y Google Business" \
"- [ ] Dominio a nombre del cliente + HTTPS
- [ ] Títulos, descripciones y Open Graph
- [ ] Search Console, sitemap y link en Google Business / Instagram"

tarea "$M4" "Backlog" Media "tipo: docs" "Página de privacidad y datos personales" \
"- [ ] Qué datos se piden, para qué y cómo pedir que se borren (Ley 25.326)"

tarea "$M4" "Backlog" Media "tipo: docs,necesita info del cliente" "Manual de uso y capacitación al dueño" \
"- [ ] Manual corto con capturas
- [ ] Capacitación de 30 min
- [ ] Acordar cómo nos avisa si algo falla"

tarea "$M4" "Backlog" Media "tipo: docs" "Publicar v1.0.0 y agregar al portfolio" \
"Cuando el proyecto está estable (REQUISITOS.md completo, en producción y acta de entrega firmada):
- [ ] Publicar la release \`v1.0.0\` (Releases → Draft a new release). Se abre solo un issue con los pasos del portfolio
- [ ] Permiso del cliente por escrito para mostrarlo
- [ ] Agregarlo al [portfolio](https://github.com/$ORG/portfolio#cómo-agregar-un-proyecto)"

# ---------------------------------------------------------------- fin
paso "Listo"
cat <<EOF
Repo:    https://github.com/$R
Tareas:  https://github.com/orgs/$ORG/projects/$TABLERO  → vista "Por proyecto": https://github.com/orgs/$ORG/projects/$TABLERO/views/3

Falta a mano:
  1. Completar el README del repo (ficha del proyecto).
  2. Agregar el proyecto a la tabla de profile/README.md en el repo .github.
EOF
