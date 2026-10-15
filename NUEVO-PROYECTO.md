# Checklist: proyecto nuevo para un negocio

Copiá esta lista en un issue nuevo del repo (o seguila de acá) cada vez que arranquemos con un cliente.

## 1. Antes de programar

- [ ] Reunión con el cliente: qué vende, a quién, qué problema quiere resolver con la web
- [ ] Datos del negocio: nombre, logo, colores, dirección, horarios, redes, WhatsApp
- [ ] Qué necesita la web: ¿solo mostrar info? ¿turnos? ¿catálogo? ¿pagos?
- [ ] Definir el **MVP** (lo mínimo para salir) y qué queda para después
- [ ] Presupuesto y plazos acordados por escrito
- [ ] Elegir quién del equipo es el contacto con el cliente

## 2. Crear el repo (automático)

Nombre: `rubro-o-negocio` en minúscula con guiones (ej. `web-gimnasio-norte`). Desde Git Bash, con `gh auth login` hecho y este repo clonado:

```bash
bash scripts/nuevo-proyecto.sh web-gimnasio-norte "Gimnasio Norte" --dry-run   # primero mirá qué va a hacer
bash scripts/nuevo-proyecto.sh web-gimnasio-norte "Gimnasio Norte"             # después crealo
```

El script hace solo:
- [x] Repo **privado** creado desde [`plantilla-proyecto`](https://github.com/TurnosDev-Team/plantilla-proyecto)
- [x] Acceso de escritura para el equipo
- [x] Etiquetas (`tipo:`, `área:`, `prioridad:`, `bloqueado`, `necesita info del cliente`)
- [x] Etapas: `1 · Relevamiento y diseño`, `2 · MVP`, `3 · Extras`, `4 · Lanzamiento`
- [x] 15 tareas estándar cargadas en el tablero general, con prioridad y cliente

Lo que queda a mano:
- [ ] Completar la ficha del proyecto en el README (cliente, responsable, links)
- [ ] Agregar el proyecto a la tabla del [perfil de la organización](profile/README.md)
- [ ] Cambiar la tarea "Funcionalidad principal: COMPLETAR" por las funcionalidades reales cuando se defina el alcance
- [ ] Si se suma alguien nuevo al equipo, agregarlo en `EQUIPO=(...)` dentro del script

## 3. Desarrollo

- [ ] Proyecto base con el stack por defecto (ver [GUIA.md](GUIA.md#3-stack-por-defecto))
- [ ] README con cómo correrlo, `.env.example` y seeders
- [ ] Deploy de prueba temprano (aunque esté vacío) para mostrarle avances al cliente
- [ ] Anotar decisiones importantes en `docs/DECISIONES.md` (viene en la plantilla)
- [ ] Tests automáticos y Dependabot ya vienen en la plantilla: revisar que estén en verde

## 4. Lanzamiento

- [ ] **Pasar completo el checklist de [REQUISITOS.md](REQUISITOS.md)** (seguridad, panel admin, SEO, legal, backups)
- [ ] Tests de los flujos principales pasando
- [ ] Revisado en celular (Android y iPhone) y en compu
- [ ] Dominio configurado y HTTPS
- [ ] SEO básico + ficha de Google Business
- [ ] Página de privacidad
- [ ] Backup de la base de datos configurado
- [ ] Manual corto de uso y capacitación al dueño
- [ ] Mover el proyecto a "✅ En producción" en el perfil de la organización
