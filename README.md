# 🍽️ API Recetas del Mundo — Resumen ejecutivo y guía técnica


Versión profesional del README, alineada con la presentación técnica en `docs/presentation_architecture.html`. Este documento está pensado para CTOs, equipos DevOps e inversores: resume la propuesta de valor, arquitectura, operaciones críticas y cómo arrancar el sistema.

## Resumen ejecutivo

API Recetas del Mundo es una API RESTful contenerizada, diseñada para producción con Docker y portable a Kubernetes. Ofrece:

- Backend modular en Spring Boot con autenticación JWT y hashing con BCrypt.
- Modelo relacional en PostgreSQL 15 optimizado para búsquedas por país y categoría.
- Funcionalidad social y de monetización: favoritos, comentarios, rating y donaciones.
- Estrategia operativa: imágenes reproducibles, CI/CD, backups automáticos y pruebas de restore.

Estado actual: API operativa y validada (ver `docs/ENDPOINTS-COMPLETOS.md` para la lista completa — ~42 endpoints confirmados).

## Referencias canónicas

- Presentación técnica: `docs/presentation_architecture.html` (usar para exportar a PDF).
- Documentación completa de endpoints: `docs/ENDPOINTS-COMPLETOS.md`.
- Diagramas y exports: `docs/architecture_diagram.svg`, `docs/er_diagram_actualizado.png`, `docs/auth_flow.svg`.

## Arquitectura (alto nivel)

- Cliente → Reverse proxy / Load Balancer (TLS) → Backend (Spring Boot) → PostgreSQL (persistencia).
- Integraciones desacopladas vía colas (RabbitMQ/Kafka) y webhooks con verificación HMAC.
- CI/CD: pipelines que generan artefactos inmutables (Docker images) y despliegan por etiquetas.

### Diagramas

Diagrama de arquitectura (SVG canónico):

![Diagrama de arquitectura](docs/architecture_diagram.svg)

Diagrama ER (PNG exportado para compatibilidad):

![Diagrama ER](docs/er_diagram_actualizado.png)

Flujo de autenticación (SVG):

![Flujo de autenticación](docs/auth_flow.svg)

> Nota: GitHub renderiza SVG en la mayoría de casos, pero para compatibilidad con visores o presentaciones es recomendable exportar PNGs y referenciarlos desde `docs/`.

## Endpoints — resumen operativo

Listado resumido (ver `docs/ENDPOINTS-COMPLETOS.md` para detalles y ejemplos):

- Autenticación: POST /auth/login, POST /auth/register
- Usuarios: GET/POST/PUT/DELETE /usuarios
- Categorías: CRUD /categorias
- Países: CRUD /paises
- Recetas: CRUD /recetas + búsquedas especiales (/recetas/trending, /recetas/del-dia, /recetas/carrusel)

Endpoints (extraídos desde OpenAPI `GET /v3/api-docs`):

DELETE /admin/comentarios/{id}
DELETE /admin/estrellas/{id}
DELETE /admin/favoritos/{id}
DELETE /admin/ingredientes/{id}
DELETE /admin/megusta/{id}
DELETE /admin/perfil/{id}
DELETE /categorias/{id}
DELETE /paises/{id}
DELETE /recetas/{id}
DELETE /recetas/{idReceta}/ingredientes/{idIngrediente}
DELETE /recetas/comentarios/{id}
DELETE /recetas/estrellas/{id}
DELETE /recetas/favoritos
DELETE /recetas/megusta
DELETE /usuarios/{id}
GET /admin/comentarios
GET /admin/comentarios/{id}
GET /admin/estrellas
GET /admin/estrellas/{id}
GET /admin/estrellas/receta/{recetaId}
GET /admin/estrellas/receta/{recetaId}/promedio
GET /admin/favoritos
GET /admin/favoritos/{id}
GET /admin/ingredientes
GET /admin/ingredientes/{id}
GET /admin/megusta
GET /admin/megusta/{id}
GET /admin/megusta/receta/{recetaId}/count
GET /admin/perfil
GET /admin/perfil/{id}
GET /categorias
GET /categorias/{id}
GET /paises
GET /paises/{id}
GET /paises/nombre/{nombre}
GET /recetas
GET /recetas/{id}
GET /recetas/{id}/ingredientes
GET /recetas/carrusel
GET /recetas/categoria/{idCategoria}
GET /recetas/comentarios
GET /recetas/comentarios/receta/{id}
GET /recetas/del-dia
GET /recetas/estrellas
GET /recetas/estrellas/stats/{idReceta}
GET /recetas/favoritos
GET /recetas/favoritos/count/{idReceta}
GET /recetas/megusta
GET /recetas/megustas/count/{idReceta}
GET /recetas/nombre/{nombre}
GET /recetas/pais/{idPais}
GET /recetas/trending
GET /recetas/usuario/{usuarioId}
GET /usuarios
GET /usuarios/{id}
POST /admin/comentarios
POST /admin/donaciones
POST /admin/estrellas
POST /admin/favoritos
POST /admin/ingredientes
POST /admin/megusta
POST /admin/megusta/toggle
POST /admin/perfil
POST /auth/login
POST /auth/register
POST /categorias
POST /donaciones/create-session
POST /paises
POST /recetas
POST /recetas/{id}/ingredientes
POST /recetas/comentarios
POST /recetas/donaciones
POST /recetas/estrellas
POST /recetas/favoritos
POST /recetas/megusta
POST /usuarios
POST /webhook/stripe
PUT /admin/comentarios/{id}
PUT /admin/estrellas/{id}
PUT /admin/favoritos/{id}
PUT /admin/ingredientes/{id}
PUT /admin/megusta/{id}
PUT /admin/perfil/{id}
PUT /categorias/{id}
PUT /paises/{id}
PUT /recetas/{id}
PUT /recetas/{id}/ingredientes
PUT /recetas/comentarios/{id}
PUT /recetas/estrellas/{id}
PUT /recetas/favoritos/{id}
PUT /recetas/megusta/{id}
PUT /usuarios/{id}

## Pruebas E2E y cómo ejecutarlas

Se incluyeron varios scripts PowerShell para pruebas E2E y de diagnóstico en `scripts/`.

Scripts principales:
- `scripts\e2e_recetas.ps1` — Flujo completo de recetas (crear/actualizar/ingredientes/eliminar).
- `scripts\debug_repro_ingredientes.ps1` — Reproducción masiva para POST /recetas/{id}/ingredientes (acepta `-iterations N`).
- `scripts\e2e_comments.ps1` — Crear, modificar y eliminar comentario (verifica preservación de `fechaCreacion`).
- `scripts\e2e_favoritos.ps1` — Agregar / listar / quitar favorito.
- `scripts\e2e_megusta.ps1` — Agregar / listar / quitar me gusta.
- `scripts\e2e_estrellas.ps1` — Agregar (4) → actualizar (3) → eliminar calificación.
- `scripts\e2e_interactions.ps1` — Runner combinado: me gusta, favoritos, estrellas y prueba de donación (intenta endpoints comunes de donación).

Ejemplo (PowerShell) para ejecutar un script E2E desde la raíz del repo:

```powershell
# Ejecutar E2E recetas (ejecuta login y flujo completo)
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\GitHub\api-recetas_final\scripts\e2e_recetas.ps1"

# Ejecutar test de comentarios
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\GitHub\api-recetas_final\scripts\e2e_comments.ps1"

# Ejecutar repro ingredientes con 30 iteraciones
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\GitHub\api-recetas_final\scripts\debug_repro_ingredientes.ps1" -iterations 30
```

Notas:
- Los scripts usan por defecto `admin@recetas.com` / `cast1301` para autenticarse. Cambia las variables en los scripts si usas otras cuentas.
- La base URL por defecto es `http://localhost:8081` en los scripts; modifica `$base` para apuntar a otra URL (por ejemplo staging).
- Los scripts devuelven códigos de salida no-cero y detienen la ejecución si encuentran errores; son adecuados para ejecutar en CI con pequeña adaptación (parámetros y credenciales seguras).

Resultados de las pruebas E2E realizadas localmente (resumen):
- `e2e_recetas.ps1`: OK
- `debug_repro_ingredientes.ps1 -iterations 30`: OK (sin 400 intermitentes)
- `e2e_comments.ps1`: OK (fechaCreacion preservada)
- `e2e_favoritos.ps1`: OK
- `e2e_megusta.ps1`: OK
- `e2e_estrellas.ps1`: OK
- `e2e_interactions.ps1`: OK (donación en modo PENDING si STRIPE no configurado)

Si quieres, puedo parametrizar esos scripts para que acepten `-baseUrl`, `-email` y `-password` como parámetros y dejar listos para CI.

## Seguridad, operaciones y DevOps

- JWT (access + refresh) con expiración corta y refresh revocable.
- BCrypt para hashing de contraseñas (cost ≥ 10 recomendado).
- Secret management: Vault/Key Vault o equivalente.
- Observabilidad: logging estructurado (JSON), métricas (Prometheus), tracing (OpenTelemetry).
- Backups: pg_dump diarios + retención y copia remota (S3/Blob). Probar restores en staging.
- Migraciones: Flyway o Liquibase.

## Imágenes: generar PNGs desde SVG (Windows / PowerShell)

Si necesitas PNGs para la vista en GitHub o para presentar a inversores, usa Inkscape 1.0+ (o rsvg-convert / ImageMagick). Ejemplo PowerShell:

```powershell
inkscape docs\architecture_diagram.svg --export-type=png --export-filename=docs\architecture_diagram.png
inkscape docs\db_diagram.svg --export-type=png --export-filename=docs\er_diagram_actualizado.png
inkscape docs\auth_flow.svg --export-type=png --export-filename=docs\auth_flow.png
```

Alternativa con ImageMagick (si prefieres):

```powershell
magick convert docs\architecture_diagram.svg docs\architecture_diagram.png
```

Genera los PNGs localmente, revisa su calidad y súbelos al repo (p. ej. `git add docs/*.png && git commit -m "chore: add diagram PNGs"`).

## Inicio rápido (desarrollo)

Requisitos: Java 17+, Maven, Docker, Docker Compose.

```bash
mvn clean package
java -jar target/api-recetas-0.0.1-SNAPSHOT.jar --server.port=8081
# Comprobar salud
curl http://localhost:8081/actuator/health
```

Docker Compose (ejemplo de producción):

```powershell
docker compose -f docker-compose.prod.yml --env-file .env up -d
```

## Backups y restauración

- Scripts: `scripts/backup_full.sh`, `scripts/backup_rotate.sh`, `scripts/restore_recetas_stack.sh`.
- Procedimiento: dump diario (pg_dump) → comprimir/rotar → copiar a almacenamiento remoto → pruebas de restore periódicas.

## Despliegue (systemd)

Unidad de ejemplo: `scripts/recetas-stack.service`.

```bash
sudo cp scripts/recetas-stack.service /etc/systemd/system/recetas-stack.service
sudo systemctl daemon-reload
sudo systemctl enable --now recetas-stack.service
```

## Cómo contribuir

- Workflow: Fork → PR. Sigue Conventional Commits.
- Añade pruebas unitarias e integración; CI debe ejecutar tests.

## Recursos

- Presentación técnica: `docs/presentation_architecture.html`
- Endpoints completos: `docs/ENDPOINTS-COMPLETOS.md`
- Diagramas: `docs/architecture_diagram.svg`, `docs/er_diagram_actualizado.png`, `docs/auth_flow.svg`

## Contacto y licencia

Contacto: `cla.sanchezt@duocuc.cl`

Licencia: MIT

© 2025 API Recetas del Mundo. Todos los derechos reservados.

---
PowerShell (Inkscape 1.0+ recomendado):

```powershell
inkscape docs\architecture_diagram.svg --export-type=png --export-filename=docs\architecture_diagram.png
inkscape docs\db_diagram.svg --export-type=png --export-filename=docs\er_diagram_actualizado.png
inkscape docs\auth_flow.svg --export-type=png --export-filename=docs\auth_flow.png
```

Alternativas: `rsvg-convert` o ImageMagick (`magick convert ...`).

Nota: los PNG deben revisarse visualmente antes de enviar a inversores; la presentación aplica estilos CSS (`.diagram-img`) para un tamaño uniforme.

## Inicio rápido (desarrollo)

Requisitos: Java 17+, Maven, Docker, Docker Compose.

Desde la raíz del repo (desarrollo local):

```bash
mvn clean package
java -jar target/api-recetas-0.0.1-SNAPSHOT.jar --server.port=8081
# Comprobar salud
curl http://localhost:8081/actuator/health
```

Docker Compose (producción de ejemplo):

```powershell
# ajustar .env desde .env.prod.example
docker compose -f docker-compose.prod.yml --env-file .env up -d
```

Recomendación: en producción usar imágenes preconstruidas y un gestor de secretos.

## Backups y restauración (resumen operativo)

- Scripts útiles: `scripts/backup_full.sh`, `scripts/backup_rotate.sh`, `scripts/restore_recetas_stack.sh`.
- Procedimiento mínimo recomendado:
	1. Dump diario con pg_dump.
	2. Comprimir + rotar según política de retención.
	3. Copia a almacenamiento remoto (S3/Blob).
	4. Prueba de restore mensual en staging.

Ejemplo rápida de restore SQL:

```bash
psql -U postgres -d api_recetas_postgres -f backup.sql
```

## Systemd / despliegue en servidor

Se incluye una unidad de ejemplo en `scripts/recetas-stack.service`. Opciones de despliegue:

- Launcher: oneshot/RemainAfterExit si Docker gestiona los contenedores.
- Supervisor: ejecutar `docker compose up` en primer plano y dejar que systemd lo supervise.

Instalación de ejemplo:

```bash
sudo cp scripts/recetas-stack.service /etc/systemd/system/recetas-stack.service
sudo systemctl daemon-reload
sudo systemctl enable --now recetas-stack.service
```

## Cómo contribuir

- Workflow: Fork → PR. Sigue Conventional Commits.
- Tests: añade pruebas unitarias y de integración; CI debe ejecutar tests antes de publicar imágenes.
- No comitear binarios ni backups; usar `.gitignore` o Git LFS para artefactos grandes.

## Recursos adicionales

- Presentación técnica: `docs/presentation_architecture.html` (exportable a PDF).
- Endpoints completos y ejemplos: `docs/ENDPOINTS-COMPLETOS.md`.
- Diagramas y exports del esquema: `docs/er_diagram_actualizado.png`, `docs/architecture_diagram.svg`, `docs/auth_flow.svg`.

## Contacto y licencia

Contacto: `cla.sanchezt@duocuc.cl`

Licencia: MIT

---

© 2025 API Recetas del Mundo. Todos los derechos reservados.

- Mantener `JWT_SECRET` y credenciales en un gestor de secretos (Vault, Key Vault) o variables de entorno en el host.
- No almacenar secretos en Git.
- Habilitar backups cifrados para datos sensibles.
- Revisar permisos del socket Docker si se ejecuta sin root.

---

## Documentación de API (resumen)

Endpoints principales (resumen):
- Gestión de recetas: GET/POST/PUT/DELETE `/recetas`, búsquedas especiales (`/recetas/trending`, `/recetas/del-dia`, `/recetas/carrusel`).
- Favoritos / me_gusta / estrellas / comentarios.
- Gestión de usuarios y roles (endpoints admin protegidos).

Para la lista completa de endpoints revisa los validators/controllers en `api-recetas/src/` o la documentación OpenAPI si está habilitada en `http://localhost:8081/docs`.

---

## Roadmap y características futuras

Versiones planificadas (resumen):
- 2.0: búsqueda avanzada (IA), upload de imágenes, analytics.
- 2.1: Chatbot integrado para asistencia culinaria y búsqueda conversacional.

---

## Cómo contribuir

- Fork + PR: sigue Conventional Commits.
- Añadir pruebas unitarias en `Springboot/src/test/java`.
- No comitees backups ni binarios grandes; usar `.gitignore` o Git LFS.

Ejemplo rápido:
```bash
git checkout -b feat/mi-cambio
# cambios
mvn -DskipTests package
git add .
git commit -m "feat: descripción corta"
git push origin feat/mi-cambio
```

---

## Contacto y licencia

Proyectos con licencia MIT. Para consultas: `cla.sanchezt@duocuc.cl`.

---

## Resumen ejecutivo

API Recetas del Mundo es una plataforma contenerizada, diseñada para producción en Docker y orquestadores (Kubernetes). Permite desplegarse en entornos legacy (VMs o infra local) y cloud sin cambios en la aplicación, facilitando migraciones y operaciones híbridas. La solución prioriza:

- Despliegue reproducible (imágenes, CI/CD). 
- Escalabilidad horizontal mediante servicios stateless y réplicas.
- Operaciones seguras: gestión de secretos, backups automatizados y rotación.

This README presents: diagrama de arquitectura, diagrama ER actualizado, flujos JWT y scripts operativos para backup/restore y systemd.

## Conclusión

API Recetas del Mundo ofrece una base técnica sólida para productos culinarios digitales que requieren estabilidad, seguridad y capacidad de crecer a escala. Está pensada para equipos que necesitan una solución híbrida —capaz de coexistir con sistemas legacy y migrar hacia la nube— reduciendo riesgos operacionales y acelerando la entrega de valor.

© 2025 API Recetas del Mundo. Todos los derechos reservados.

---