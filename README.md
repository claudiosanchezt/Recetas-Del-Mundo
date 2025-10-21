# 🍽️ API Recetas del Mundo — Resumen ejecutivo y guía técnica


Versión profesional del README, alineada con la presentación técnica en `docs/presentation_architecture.html`. Este documento está pensado para CTOs, equipos DevOps e inversores: resume la propuesta de valor, arquitectura, operaciones críticas y cómo arrancar el sistema.

# 🍽️ API Recetas del Mundo — Resumen ejecutivo y guía técnica

Versión profesional del README, alineada con la presentación técnica en `docs/presentation_architecture.html`. Este documento está pensado para CTOs, equipos DevOps e inversores: resume la propuesta de valor, arquitectura, operaciones críticas y cómo arrancar el sistema.

## Resumen ejecutivo

API Recetas del Mundo es una API RESTful contenerizada, diseñada para producción con Docker y portable a Kubernetes. Ofrece:

- Backend modular en Spring Boot con autenticación JWT y hashing con BCrypt.
- Modelo relacional en PostgreSQL 15 optimizado para búsquedas por país y categoría.
- Funcionalidad social y de monetización: favoritos, comentarios, rating y donaciones.
- Estrategia operativa: imágenes reproducibles, CI/CD, backups automáticos y pruebas de restore.

Estado actual: API operativa y validada (ver `docs/ENDPOINTS-COMPLETOS.md` para la lista completa — ~42 endpoints confirmados).

---

## Visión rápida

Este repositorio contiene el backend de "Recetas del Mundo": una API REST construida con Spring Boot y PostgreSQL que gestiona recetas, ingredientes, interacciones (favoritos, me gusta, estrellas, comentarios), usuarios, categorías y donaciones (Stripe).

---

## Contenido

- `Springboot/` — código del backend (Java, Maven).
- `docs/` — documentación técnica: OpenAPI (`openapi.json`), diagramas ER, SVGs de arquitectura y flujos, listas de tablas/columnas/constraints y guía de endpoints completa.
- `scripts/` — scripts para backup, E2E automatizados en PowerShell y utilidades.
- `database/` — utilitarios y conexión a la base de datos.

---

## Resumen rápido

- API lista para ejecución local en `http://localhost:8081`.
- Endpoints principales: `/auth`, `/usuarios`, `/categorias`, `/paises`, `/recetas` (incluye CRUD y muchas rutas de interacción).
- Documentación OpenAPI generada: `docs/openapi.json` y Swagger UI (si se levanta la app).

---

## Requisitos

- Java 17+
- Maven 3.6+
- Docker (opcional, para Postgres y plantuml) y docker-compose
- Inkscape o Cairo/PlantUML si necesitas generar PNGs desde SVG/PUML localmente

---

## Cómo ejecutar

### Compilar y ejecutar el JAR

1. Compila el proyecto:

```powershell
cd Springboot
mvn -DskipTests package
```

2. Ejecuta el JAR:

```powershell
java -jar target/api-recetas-0.0.1-SNAPSHOT.jar --server.port=8081
```

### Usar Docker Compose (si está configurado en la raíz)

```powershell
docker compose build backend
docker compose up -d backend
```

### Variables de entorno importantes

- `JWT_SECRET` — secreto para firmar JWT.
- `JWT_EXPIRATION_MS` — tiempo de expiración del token (ms).
- `DATABASE_URL` / `SPRING_DATASOURCE_*` — conexión a Postgres.
- `STRIPE_SECRET_KEY` — (opcional) para activar pagos/checkout real.

> Nota: No dejes claves en el repo. Usa variables de entorno o un archivo `.env` excluido en `.gitignore`.

---

## Documentación de API

- Swagger/OpenAPI: `docs/openapi.json` (la app expone `/swagger-ui/index.html` cuando está en marcha).
- Guía de endpoints completa (resumen y ejemplos): `docs/ENDPOINTS-COMPLETOS.md`.

### Endpoints destacados

- Autenticación: `POST /auth/login`, `POST /auth/register`.
- Recetas: `GET /recetas`, `GET /recetas/{id}`, `POST /recetas` (crear con ingredientes), `PUT /recetas/{id}`, `DELETE /recetas/{id}`.
- Interacciones centralizadas bajo `/recetas/*`: favoritos, me_gusta, estrellas, comentarios e ingredientes (agregar/actualizar/eliminar).
- Otros: `/categorias`, `/paises`, `/usuarios`.

Consulta `docs/ENDPOINTS-COMPLETOS.md` para la lista y ejemplos de uso.

---

## Diagramas y arquitectura


- Diagrama de arquitectura: `docs/architecture_diagram.svg` (SVG editable). Está estilizado y contiene flechas y cajas separadas.
- Flujo de autenticación: `docs/auth_flow.svg`.
- Overview de endpoints: `docs/endpoints_overview.svg`.
- Diagrama ER y scripts: `docs/er_diagram_actualizado.puml`, `docs/er_diagram_actualizado.png`, `docs/ER_diagrama_ascii.txt`.

Imágenes (embebidas):

![Arquitectura](docs/architecture_diagram.svg)

![Diagrama ER](docs/er_diagram_actualizado.png)

![Flujo Auth](docs/auth_flow.svg)

![Overview Endpoints](docs/endpoints_overview.svg)

Si quieres PNGs de los SVGs, puedo añadir un script PowerShell que use Inkscape/PlantUML; necesitarás ejecutar la conversión localmente (por dependencias nativas).

---

## Backups y restauración

- Hay scripts para backup en `scripts/` (PowerShell y bash). El dump utilizado es `database/init.sql` y los scripts de herramientas están en `database/tools/`.
- Estrategia recomendada: `pg_dump` periódicos + backups completos del volumen Docker.

---

## Pruebas E2E

- Scripts E2E en PowerShell: `scripts/e2e_*.ps1`. Están preparados para ejecutarse contra `http://localhost:8081`.
- Variables útiles: `E2E_BASE_URL`, `E2E_EMAIL`, `E2E_PASSWORD`.

---

## Seguridad y limpieza de secretos

- El repositorio fue auditado y existen guías/scripts para eliminar secretos de la historia (`scripts/clean_remove_secret.sh`).
- Si alguna clave de Stripe u otro provider fue comprometida, rota la clave y purga la historia git localmente con `git filter-repo` o BFG, siguiendo la guía en `scripts/`.

---

## Contribuir

- Abre issues para bugs y features.
- Para PRs: bifurca la rama, crea una rama descriptiva y abre PR hacia `Bakend_Recetas_Final`.
- Sigue las convenciones: tests E2E para cambios en endpoints y actualiza `docs/openapi.json` si agregas rutas.

---

## Contacto


Equipo de desarrollo — `dev@recetas.cl` (consulta `docs/openapi.json` para más metadatos de contacto).

---

## Conclusión

API Recetas del Mundo ofrece una base técnica sólida para productos culinarios digitales que requieren estabilidad, seguridad y capacidad de crecer a escala. Está pensada para equipos que necesitan una solución híbrida —capaz de coexistir con sistemas legacy y migrar hacia la nube— reduciendo riesgos operacionales y acelerando la entrega de valor.

Puntos clave:

- Despliegue reproducible (imágenes, CI/CD).
- Escalabilidad horizontal mediante servicios stateless y réplicas.
- Operaciones seguras: gestión de secretos, backups automatizados y rotación.

© 2025 API Recetas del Mundo. Todos los derechos reservados.

---

Si quieres que ajuste el README (añada capturas/PNGs, comandos para conversiones locales o ejemplos de curl más extensos), dime qué prefieres y lo actualizo.