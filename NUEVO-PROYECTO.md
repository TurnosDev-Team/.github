# Checklist: proyecto nuevo para un negocio

Copiá esta lista en un issue nuevo del repo (o seguila de acá) cada vez que arranquemos con un cliente.

## 1. Antes de programar

- [ ] Reunión con el cliente: qué vende, a quién, qué problema quiere resolver con la web
- [ ] Datos del negocio: nombre, logo, colores, dirección, horarios, redes, WhatsApp
- [ ] Qué necesita la web: ¿solo mostrar info? ¿turnos? ¿catálogo? ¿pagos?
- [ ] Definir el **MVP** (lo mínimo para salir) y qué queda para después
- [ ] Presupuesto y plazos acordados por escrito
- [ ] Elegir quién del equipo es el contacto con el cliente

## 2. Crear el repo

- [ ] Nombre: `rubro-o-negocio` en minúscula con guiones (ej. `turnos-peluqueria`, `web-gimnasio-norte`)
- [ ] Repo **privado** dentro de TurnosDev-Team, con README
- [ ] Dar acceso de escritura al equipo
- [ ] Crear etiquetas (`tipo:`, `área:`, `prioridad:`, `bloqueado`, `necesita info del cliente`)
- [ ] Crear milestones: `1 · Relevamiento y diseño`, `2 · MVP`, `3 · Extras`, `4 · Lanzamiento`
- [ ] Cargar los issues y sumarlos al tablero de la organización
- [ ] Agregar el proyecto a la tabla del [perfil de la organización](profile/README.md)

## 3. Desarrollo

- [ ] Proyecto base con el stack por defecto (ver [GUIA.md](GUIA.md#3-stack-por-defecto))
- [ ] README con cómo correrlo, `.env.example` y seeders
- [ ] Deploy de prueba temprano (aunque esté vacío) para mostrarle avances al cliente
- [ ] Activar Dependabot en el repo (Settings → Code security)

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
