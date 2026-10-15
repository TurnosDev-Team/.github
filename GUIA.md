# Guía de trabajo — TurnosDev-Team

Cómo trabajamos en todos los proyectos de la organización. Si algo de esto no sirve o falta, se cambia con un PR a este archivo.

## 1. Tareas y tablero

- **Todo trabajo arranca con un issue.** Si no hay issue, se crea antes de programar (plantillas: Tarea, Bug, Feature).
- Las tareas viven en el [tablero de la organización](https://github.com/orgs/TurnosDev-Team/projects/1). Columnas:

  | Columna | Significa |
  |---|---|
  | **Backlog** | Ideas y tareas sin prioridad todavía |
  | **Por hacer** | Lista para tomar, ya se sabe qué hay que hacer |
  | **En progreso** | Alguien la está haciendo (tiene que estar asignada) |
  | **En revisión** | Hay un PR abierto esperando revisión |
  | **Hecho** | Mergeado / terminado |

- Vistas del tablero (pestañas arriba):

  | Vista | Para qué |
  |---|---|
  | [**Tablero**](https://github.com/orgs/TurnosDev-Team/projects/1/views/2) | Columnas de todo el trabajo, arrastrando tarjetas |
  | [**Por proyecto**](https://github.com/orgs/TurnosDev-Team/projects/1/views/3) | Tareas agrupadas por repo/cliente |
  | [**Mis tareas**](https://github.com/orgs/TurnosDev-Team/projects/1/views/4) | Solo lo asignado a vos |
  | [**Por etapa**](https://github.com/orgs/TurnosDev-Team/projects/1/views/5) | Agrupado por milestone (relevamiento, MVP, extras, lanzamiento) |

- **Asignate** el issue cuando lo empezás y movelo a *En progreso*. Nadie toma una tarea asignada a otro sin hablarlo.
- Cada repo tiene **milestones** (etapas, ej. "1 · Relevamiento y diseño"). Los issues van dentro de una etapa.
- Los issues se crean **siempre con una plantilla** (Tarea, Funcionalidad o Bug): así entran solos al tablero, en cualquier repo.

### Varios proyectos a la vez

La organización está pensada para tener **muchos clientes en paralelo**:

| Regla | Por qué |
|---|---|
| **Un repo por cliente/proyecto** (`rubro-o-negocio`, ej. `web-gimnasio-norte`) | Cada negocio tiene su código, sus issues y sus etapas |
| **Un solo tablero para todo** (el "Tablero general") | Se ve todo el trabajo del equipo junto; se filtra por repo con `repo:TurnosDev-Team/nombre` o en la vista *Por proyecto* |
| Campo **Cliente** en el tablero | Para filtrar y agrupar por negocio |
| Todos los repos nacen de [`plantilla-proyecto`](https://github.com/TurnosDev-Team/plantilla-proyecto) | Misma estructura, README con ficha del proyecto, tests automáticos y Dependabot en todos |
| Los repos se crean con el script [`scripts/nuevo-proyecto.sh`](scripts/nuevo-proyecto.sh) | Crea repo, acceso, etiquetas, etapas y las tareas estándar en 1 minuto |
| Cada proyecto tiene **un responsable** (contacto con el cliente) | Anotado en la ficha del README |
| Lo que se repite en varios proyectos (login, panel admin, botón de WhatsApp...) se pasa a la plantilla | Para no programar lo mismo dos veces |

Para arrancar un proyecto nuevo, ver [NUEVO-PROYECTO.md](NUEVO-PROYECTO.md).

### Etiquetas

| Grupo | Etiquetas |
|---|---|
| Tipo | `tipo: feature`, `tipo: bug`, `tipo: tarea`, `tipo: diseño`, `tipo: docs` |
| Área | `área: frontend`, `área: backend`, `área: base de datos`, `área: deploy` |
| Prioridad | `prioridad: alta`, `prioridad: media`, `prioridad: baja` |
| Estado | `bloqueado`, `necesita info del cliente`, `good first issue` |

## 2. Git: ramas, commits y PRs

- `main` siempre tiene que andar y es lo que está en producción. **Nunca se pushea directo a `main`.**
- Una rama por issue: `tipo/numero-descripcion-corta`
  - `feature/12-reserva-de-turnos`
  - `fix/31-horario-duplicado`
  - `docs/40-manual-de-uso`
- Commits cortos, en castellano y en presente: `Agrega cálculo de horarios libres`, `Corrige validación de teléfono`.
- **Pull request:**
  1. Un PR por issue. En la descripción poné `Closes #12` para que el issue se cierre solo al mergear.
  2. Completá la plantilla (qué cambia, cómo probarlo, capturas si hay cambios visuales).
  3. **Al menos 1 aprobación** de otro integrante antes de mergear.
  4. Los tests tienen que pasar.
  5. Se mergea con *Squash and merge* y se borra la rama.
- Antes de pedir revisión: `git pull origin main` y resolvé conflictos en tu rama.

### Versiones (releases)

Cada vez que se publica algo importante en producción, se crea una **release** en GitHub (*Releases → Draft a new release*) con un tag `vMAYOR.MENOR.PARCHE`:

| Versión | Cuándo |
|---|---|
| `v0.x.y` | Mientras se desarrolla y el cliente prueba (MVP, versiones de prueba) |
| **`v1.0.0`** | **Primera versión estable**: pasó [REQUISITOS.md](REQUISITOS.md), está en producción con el dominio del cliente y el cliente firmó el acta de entrega |
| `v1.1.0` | Funcionalidad nueva |
| `v1.0.1` | Corrección de errores |

**Cuando se publica `v1.0.0`, el proyecto se agrega al [portfolio](https://github.com/TurnosDev-Team/portfolio)** (con permiso del cliente). El repo abre solo un issue "Agregar al portfolio" con los pasos.

## 3. Stack por defecto

Usamos lo mismo que en turnos-hospital, así reutilizamos código y conocimiento entre proyectos:

| Parte | Tecnología |
|---|---|
| Backend | Laravel (PHP 8.4) |
| Frontend | Blade + Tailwind CSS + Alpine.js (Laravel Breeze para login) |
| Base de datos | SQLite en local, PostgreSQL en producción |
| Tests | Pest |
| Deploy | Docker sobre Render |

Si un cliente necesita algo distinto (por ejemplo, solo una landing sin backend), se decide en el issue de alcance y se anota en el README del repo.

### Cosas que todo repo tiene que tener

- `README.md` con: qué es, cómo correrlo en local, usuarios de prueba, cómo deployar.
- `.env.example` actualizado. **El `.env` nunca se sube** (ni contraseñas, ni API keys, ni tokens).
- Seeders con datos de ejemplo para que cualquiera pueda probar en 5 minutos.
- Tests de los flujos importantes (reservar, cancelar, login, pagos si hay).

## 4. Cosas a tener en cuenta en las webs de negocios

**Los usuarios finales son clientes del negocio, no programadores.** Casi todos van a entrar desde el celular.

> El checklist completo y obligatorio (seguridad, panel de admin, SEO, legal, backups) está en [REQUISITOS.md](REQUISITOS.md). Las herramientas y lenguajes, en [HERRAMIENTAS.md](HERRAMIENTAS.md).

- 📱 **Mobile first:** se diseña primero para celular. Botones grandes, poco texto, pocos pasos.
- ♿ **Accesibilidad:** buen contraste, letra legible, todo usable con teclado, textos alternativos en imágenes.
- ⚡ **Rápida:** imágenes optimizadas (WebP, tamaño justo), sin librerías pesadas que no hagan falta.
- 💬 **WhatsApp:** en Argentina es el canal principal. Botón de WhatsApp visible y, si se puede, confirmaciones o recordatorios por ahí.
- 🕒 **Horarios y fechas:** zona horaria `America/Argentina/Buenos_Aires`, formato `dd/mm/aaaa`, feriados nacionales.
- 🔒 **Datos personales:** se piden solo los datos necesarios (nombre, teléfono, email). Página de privacidad simple (Ley 25.326 de Protección de Datos Personales). Contraseñas siempre hasheadas (Laravel ya lo hace).
- 🔍 **SEO básico:** título y descripción por página, nombre del negocio + rubro + ciudad, ficha de Google Business del cliente.
- 🧑‍💼 **Panel para el dueño:** tiene que poder cambiar precios, horarios y servicios sin llamarnos.
- 💸 **Costos:** usar planes gratis cuando alcance (Render free, base gratis) y avisarle al cliente qué cuesta si crece (dominio, hosting pago, WhatsApp API).
- 🧾 **Entrega:** al terminar, manual corto de uso + capacitación de 30 minutos al dueño.

## 5. Comunicación con el cliente

- Una sola persona del equipo es el contacto principal con cada cliente (se anota en el README del repo).
- Lo que el cliente pide o decide se anota **en el issue correspondiente**, no queda solo en WhatsApp.
- Si una tarea está trabada esperando al cliente: etiqueta `necesita info del cliente`.
- Mostrar avances cada 1 o 2 semanas con la web deployada, no con capturas.
