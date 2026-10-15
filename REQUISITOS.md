# Lo que no puede faltar en ninguna web

Checklist obligatorio para **todos** los proyectos de TurnosDev-Team. Antes de entregarle una web a un cliente, se revisa esta lista completa. Si algo no aplica (por ejemplo, una landing sin login), se tacha y se anota por qué en el issue de lanzamiento.

> Stack de referencia: Laravel + Blade + Tailwind. Varias cosas Laravel ya las trae; acá está cuáles hay que **no romper** y cuáles hay que **agregar a mano**.

---

## 🔒 1. Seguridad

### Secretos y configuración
- [ ] **El `.env` nunca se sube al repo.** Solo `.env.example` sin valores reales.
- [ ] Contraseñas, API keys y tokens solo en las variables de entorno de Render.
- [ ] En producción: `APP_ENV=production` y **`APP_DEBUG=false`** (con `true` se ven contraseñas y rutas internas cuando hay un error).
- [ ] `APP_KEY` distinta en cada entorno.
- [ ] Si un secreto se subió por error: **se cambia ese mismo día**, no alcanza con borrarlo del repo.

### Login y contraseñas
- [ ] Contraseñas siempre hasheadas (Laravel lo hace con `Hash::make`; nunca guardar texto plano).
- [ ] Límite de intentos de login (Breeze ya trae *rate limiting*; no sacarlo).
- [ ] "Olvidé mi contraseña" funcionando con el mail de producción.
- [ ] Sesión que se cierra sola después de un tiempo sin uso en el panel admin.
- [ ] Contraseña inicial del dueño: que la cambie en el primer ingreso.

### Datos que entran
- [ ] **Validar todo en el servidor** (Form Requests), aunque ya se valide en el formulario.
- [ ] Nunca armar SQL concatenando texto: usar Eloquent o parámetros (`?`).
- [ ] Mostrar datos con `{{ }}` en Blade (escapa HTML). `{!! !!}` solo si sabemos exactamente qué contiene.
- [ ] Formularios con `@csrf` (Laravel lo exige; no desactivarlo).
- [ ] Archivos subidos (fotos): validar tipo y tamaño, guardarlos fuera de `public/` o con nombre aleatorio.
- [ ] Límite de envíos en formularios públicos (reservas, contacto) para frenar spam: `throttle` en la ruta y, si hace falta, captcha.

### Permisos
- [ ] Cada ruta del panel protegida con `auth` + rol (middleware o Policies).
- [ ] Probar entrar a una URL del admin **sin estar logueado** y **con un usuario común** → tiene que rebotar.
- [ ] Un cliente solo ve y cancela **sus** turnos/pedidos (no cambiando el número en la URL).
- [ ] Links de cancelación con token aleatorio largo, no con el ID.

### Servidor y mantenimiento
- [ ] HTTPS obligatorio (Render lo da gratis; redirigir `http` → `https`).
- [ ] Dependabot activado en el repo para avisar de librerías con fallas.
- [ ] `composer audit` y `npm audit` antes de cada lanzamiento.
- [ ] Logs de errores revisables (y sin datos sensibles adentro).

---

## 🧑‍💼 2. Panel de administración

Lo que el dueño del negocio tiene que poder hacer **solo, sin llamarnos**:

- [ ] Login propio en `/admin` (o similar), separado de la parte pública.
- [ ] **Roles**: al menos *dueño/admin*. Si hay empleados, rol *empleado* con menos permisos.
- [ ] Editar la info del negocio: nombre, dirección, teléfono, WhatsApp, horarios, redes.
- [ ] ABM (alta, baja, modificación) de lo que vende: servicios, productos, precios, fotos.
- [ ] Ver y gestionar lo que entra: turnos, pedidos, mensajes de contacto.
- [ ] Buscar y filtrar (por fecha, estado, cliente).
- [ ] Exportar a Excel/CSV (los dueños lo piden siempre).
- [ ] Cambiar su contraseña.
- [ ] **Borrar = desactivar** cuando el dato se usa en otro lado (un servicio con turnos viejos no se borra, se oculta).
- [ ] Confirmación antes de acciones que no se pueden deshacer.
- [ ] Usable desde el celular: el dueño lo va a abrir en el local, no en una compu.
- [ ] Registro de actividad (quién cambió qué y cuándo) si hay más de un usuario admin.

---

## 🌐 3. Parte pública

- [ ] **Responsive / mobile first**: probado en Android, iPhone y compu.
- [ ] Botón de **WhatsApp** visible (`https://wa.me/549...`).
- [ ] Dirección con **mapa** de Google Maps y horarios de atención.
- [ ] Links a redes del negocio.
- [ ] Favicon y logo en buena calidad.
- [ ] Página **404** y de error propias (no la de Laravel).
- [ ] Mensajes de éxito/error claros en castellano ("Tu turno quedó reservado para el jueves 16/10 a las 15:00").
- [ ] Carga rápida: imágenes en WebP y del tamaño justo, sin librerías que no se usan.

## ♿ 4. Accesibilidad

- [ ] Contraste suficiente entre texto y fondo.
- [ ] Letra de 16 px mínimo, botones grandes para tocar con el dedo.
- [ ] Imágenes con texto alternativo (`alt`).
- [ ] Formularios con `label` en cada campo y errores al lado del campo.
- [ ] Se puede usar con teclado (Tab) sin quedar trabado.

## 🔍 5. SEO y presencia

- [ ] `<title>` y `meta description` en cada página: *negocio + rubro + ciudad*.
- [ ] Imagen y título para cuando se comparte por WhatsApp (Open Graph).
- [ ] `sitemap.xml` y `robots.txt`.
- [ ] Sitio cargado en Google Search Console.
- [ ] Link de la web en la ficha de Google Business e Instagram del cliente.

## ⚖️ 6. Legal y datos personales

- [ ] Página de **privacidad** publicada en `/privacidad` (modelo en `docs/legal/POLITICA-DE-PRIVACIDAD.md` de la plantilla) y aprobada por el cliente.
- [ ] Página de **términos** en `/terminos` (modelo en `docs/legal/TERMINOS-Y-CONDICIONES.md`).
- [ ] Si vende online: **botón de arrepentimiento** visible (Ley 24.240, Res. 424/2020) y precios finales.
- [ ] Si maneja datos **sensibles** (salud, menores): campos cifrados, acceso mínimo y revisión legal.
- [ ] Avisarle al cliente que, como responsable de los datos, evalúe inscribir la base en la AAIP.
- [ ] Pedir solo los datos necesarios.
- [ ] Si hay pagos online: términos y condiciones y política de cancelación/reembolso.
- [ ] El **dominio a nombre del cliente** (no nuestro).

## 💾 7. Datos, backups y monitoreo

- [ ] Backup automático de la base de datos (y probar una vez que se puede restaurar).
- [ ] Mails de producción configurados (confirmaciones, recuperar contraseña).
- [ ] Aviso si la web se cae (UptimeRobot, gratis).
- [ ] Zona horaria `America/Argentina/Buenos_Aires` en la app y en la base.

## ✅ 8. Calidad antes de entregar

- [ ] Tests de los flujos principales pasando (Pest).
- [ ] Seeders con datos de ejemplo para probar.
- [ ] README actualizado: cómo correrlo, cómo deployar, usuarios de prueba.
- [ ] Revisión de otro integrante del equipo (PR aprobado).
- [ ] Probado por alguien que **no programó** esa parte.
- [ ] Manual corto para el dueño + capacitación.
