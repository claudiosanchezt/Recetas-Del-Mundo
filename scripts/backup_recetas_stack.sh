#!/usr/bin/env bash

# Crear un respaldo compatible con restore_recetas_stack.sh
# Produce un tar.gz con la siguiente estructura:
#  - docker/images_YYYYMMDD_HHMMSS.tar
#  - database/pgdump_YYYYMMDD_HHMMSS.sql
#  - volumes/<vol_name>_YYYYMMDD_HHMMSS.tar.gz
#  - config/docker-compose*.yml
#  - config/servers.json (si existe)

set -euo pipefail

BASE_DIR="${BASE_DIR:-/home/admin/api-recetas}"
BACKUP_DIR="${BACKUP_DIR:-$BASE_DIR/backups}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

# Configurables
POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-api-recetas-postgres}"
POSTGRES_DB="${POSTGRES_DB:-api_recetas_postgres}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
COMPOSE_FILE="${COMPOSE_FILE:-$BASE_DIR/docker-compose.yml}"
INCLUDE_IMAGES="${INCLUDE_IMAGES:-yes}"
INCLUDE_DB="${INCLUDE_DB:-auto}"
INCLUDE_VOLUMES="${INCLUDE_VOLUMES:-yes}"
VOLUMES_LIST="${VOLUMES:-}" # comma-separated list if provided

mkdir -p "$BACKUP_DIR"
mkdir -p "$WORKDIR/docker" "$WORKDIR/database" "$WORKDIR/volumes" "$WORKDIR/config"

echo "[INFO] Creando respaldo en temporal: $WORKDIR"

## 1) Guardar imágenes Docker
if [ "$INCLUDE_IMAGES" = "yes" ]; then
  echo "[INFO] Recolectando imágenes usadas por contenedores actuales..."
  # Preferir lista de imágenes de los contenedores del proyecto; fallback a todas las imágenes en uso
  mapfile -t images < <(docker ps -a --format '{{.Image}}' | sort -u)
  if [ ${#images[@]} -eq 0 ]; then
    echo "[WARN] No se detectaron imágenes de contenedores locales. Omitiendo docker save."
  else
    images_file="$WORKDIR/docker/images_$TIMESTAMP.txt"
    printf '%s
' "${images[@]}" > "$images_file"
    tarfile="$WORKDIR/docker/images_$TIMESTAMP.tar"
    echo "[INFO] Guardando imágenes en: $tarfile"
    docker save -o "$tarfile" "${images[@]}" || {
      echo "[WARN] docker save fallo, intentando guardar imagen por imagen..."
      rm -f "$tarfile"
      for img in "${images[@]}"; do
        docker save -o "$WORKDIR/docker/$(echo "$img" | tr '/:' '__')_$TIMESTAMP.tar" "$img" || echo "[WARN] no pude guardar $img"
      done
    }
    echo "[OK] Imágenes guardadas"
  fi
fi

## 2) Dump de Postgres (si procede)
if [ "$INCLUDE_DB" = "yes" ] || { [ "$INCLUDE_DB" = "auto" ] && ! ls "$WORKDIR/volumes"/*postgres* 2>/dev/null; }; then
  echo "[INFO] Intentando exportar dump de Postgres desde contenedor: $POSTGRES_CONTAINER_NAME"
  if docker ps -a --format '{{.Names}}' | grep -qx "$POSTGRES_CONTAINER_NAME"; then
    dumpfile="$WORKDIR/database/pgdump_$TIMESTAMP.sql"
    docker exec -i "$POSTGRES_CONTAINER_NAME" pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -F p > "$dumpfile" && echo "[OK] Dump exportado: $dumpfile" || echo "[WARN] pg_dump falló (¿pg_dump presente en la imagen?)"
  else
    echo "[WARN] Contenedor Postgres '$POSTGRES_CONTAINER_NAME' no encontrado. Omitiendo dump SQL."
  fi
fi

## 3) Empaquetar volúmenes especificados o detectados
if [ "$INCLUDE_VOLUMES" = "yes" ]; then
  vols_to_backup=()
  if [ -n "$VOLUMES_LIST" ]; then
    IFS=',' read -r -a vols_to_backup <<< "$VOLUMES_LIST"
  else
    # Intentar detectar volúmenes listados en docker-compose (top-level 'volumes')
    if [ -f "$COMPOSE_FILE" ]; then
      echo "[INFO] Extrayendo volúmenes desde $COMPOSE_FILE"
      # Extrae claves top-level bajo 'volumes:' (requiere formato estándar)
      awk '/^volumes:/{flag=1; next} /^services:/{flag=0} flag && /^[[:space:]]{2}[a-zA-Z0-9_\-]+:/{gsub(/[: ]/,"",$1); print $1}' "$COMPOSE_FILE" | while read -r v; do vols_to_backup+=("$v"); done
    fi
    # Fallback: incluir volúmenes que contienen 'postgres' o 'pg' o 'recetas'
    if [ ${#vols_to_backup[@]} -eq 0 ]; then
      mapfile -t allvols < <(docker volume ls --format '{{.Name}}' 2>/dev/null || true)
      for v in "${allvols[@]}"; do
        if [[ "$v" == *post* ]] || [[ "$v" == *pg* ]] || [[ "$v" == *recet* ]] || [[ "$v" == *db* ]]; then
          vols_to_backup+=("$v")
        fi
      done
    fi
  fi

  if [ ${#vols_to_backup[@]} -eq 0 ]; then
    echo "[WARN] No se detectaron volúmenes para respaldar. Si quieres especificarlos, exporta VOLUMES='vol1,vol2' antes de ejecutar el script."
  else
    echo "[INFO] Volúmenes a respaldar: ${vols_to_backup[*]}"
    for vol in "${vols_to_backup[@]}"; do
      safe_name="${vol//[^a-zA-Z0-9_.-]/_}"
      out="$WORKDIR/volumes/${safe_name}_$TIMESTAMP.tar.gz"
      echo "[INFO] -> Empaquetando volumen: $vol -> $out"
      docker run --rm -v "$vol:/volume" -v "$WORKDIR/volumes:/backup" alpine sh -c "set -e; cd /volume || exit 0; tar -czf /backup/${safe_name}_$TIMESTAMP.tar.gz ."
      echo "[OK]   Volumen empaquetado: $out"
    done
  fi
fi

## 4) Copiar archivos de configuración (compose y pgadmin servers.json)
if [ -f "$COMPOSE_FILE" ]; then
  cp -f "$COMPOSE_FILE" "$WORKDIR/config/$(basename "$COMPOSE_FILE")"
  echo "[OK] Copiado compose: $COMPOSE_FILE"
fi
if [ -f "$BASE_DIR/pgadmin/servers.json" ]; then
  mkdir -p "$WORKDIR/config/pgadmin"
  cp -f "$BASE_DIR/pgadmin/servers.json" "$WORKDIR/config/pgadmin/servers.json"
  echo "[OK] Copiado pgAdmin servers.json"
fi

## 5) Empaquetar todo en un tar.gz final
outfile="$BACKUP_DIR/complete_backup_$TIMESTAMP.tar.gz"
echo "[INFO] Creando tar final: $outfile"
(cd "$WORKDIR" && tar -czf "$outfile" .)

echo "[DONE] Respaldo creado: $outfile"
echo "[INFO] Tamaño: $(du -h "$outfile" | cut -f1)"

exit 0

#!/usr/bin/env bash

set -euo pipefail

# Backup completo del stack de Recetas-Del-Mundo (Docker + DB)
# - Dumpea base de datos Postgres (pg_dump)
# - Respalda volúmenes nombrados (postgres_data, pgadmin_data)
# - Guarda imágenes Docker usadas por el stack
# - Copia docker-compose.yml y configs relevantes
# - Genera un tar.gz único con timestamp
# - Aplica retención de 7 días (borra respaldos más antiguos)

# Ubicaciones
SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
BACKUP_ROOT="$ROOT_DIR/backups"
TMP_DIR="$(mktemp -d -p "${BACKUP_ROOT:-/tmp}" backup_recetas_stack.XXXXXX)"

# Config por defecto (se puede sobreescribir vía .env o entorno)
POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-api-recetas-postgres}"
PGADMIN_CONTAINER_NAME="${PGADMIN_CONTAINER_NAME:-api-recetas-pgadmin}"
BACKEND_IMAGE_NAME="${BACKEND_IMAGE_NAME:-api-recetas_final-backend:latest}"
POSTGRES_VOLUME="${POSTGRES_VOLUME:-postgres_data}"
PGADMIN_VOLUME="${PGADMIN_VOLUME:-pgadmin_data}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_STAGING="$TMP_DIR/staging"
mkdir -p "$BACKUP_ROOT" "$BACKUP_STAGING" "$BACKUP_STAGING/database" "$BACKUP_STAGING/volumes" "$BACKUP_STAGING/docker" "$BACKUP_STAGING/config" "$BACKUP_STAGING/artifacts"

echo "[INFO] Raíz repo: $ROOT_DIR"
echo "[INFO] Carpeta backups: $BACKUP_ROOT"
echo "[INFO] Timestamp: $TIMESTAMP"

# Cargar variables desde .env si existe (compat Windows CRLF)
ENV_FILE="$ROOT_DIR/.env"
if [[ -f "$ENV_FILE" ]]; then
  echo "[INFO] Cargando variables de $ENV_FILE"
  CLEAN_ENV="$(mktemp)"
  tr -d '\r' < "$ENV_FILE" > "$CLEAN_ENV"
  set -a
  # shellcheck disable=SC1090
  . "$CLEAN_ENV"
  set +a
  rm -f "$CLEAN_ENV"
fi

# Defaults según docker-compose.yml si no están en entorno
POSTGRES_DB="${POSTGRES_DB:-api_recetas_postgres}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-}"

COMPOSE_FILE="$ROOT_DIR/docker-compose.yml"
COMPOSE_CMD="docker compose"
if ! docker compose version >/dev/null 2>&1; then
  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
  fi
fi

echo "[INFO] Usando comando compose: $COMPOSE_CMD"

# 1) Dump de la base de datos (pg_dump)
DB_DUMP_PATH="$BACKUP_STAGING/database/pgdump_${POSTGRES_DB}_${TIMESTAMP}.sql"
DB_DUMP_GZ="$DB_DUMP_PATH.gz"
echo "[INFO] Generando dump de Postgres desde contenedor $POSTGRES_CONTAINER_NAME (db=$POSTGRES_DB, user=$POSTGRES_USER)"
set +e
if [[ -z "$POSTGRES_PASSWORD" ]]; then
  echo "[WARN] POSTGRES_PASSWORD no definido. Intentando pg_dump sin PGPASSWORD (puede fallar)."
  docker exec "$POSTGRES_CONTAINER_NAME" sh -lc "pg_dump -U '$POSTGRES_USER' -d '$POSTGRES_DB'" > "$DB_DUMP_PATH"
else
  docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" "$POSTGRES_CONTAINER_NAME" sh -lc "pg_dump -U '$POSTGRES_USER' -d '$POSTGRES_DB'" > "$DB_DUMP_PATH"
fi
DB_DUMP_RC=$?
set -e
if [[ $DB_DUMP_RC -ne 0 ]]; then
  echo "[ERROR] Falló pg_dump (rc=$DB_DUMP_RC). Continuaré con volúmenes e imágenes, pero revisa credenciales/estado del contenedor."
  rm -f "$DB_DUMP_PATH"
else
  gzip -9 "$DB_DUMP_PATH"
  echo "[OK] Dump generado: $DB_DUMP_GZ"
fi

# 2) Backup de volúmenes nombrados (postgres_data, pgadmin_data)
echo "[INFO] Respaldo de volúmenes Docker"
if docker volume inspect "$POSTGRES_VOLUME" >/dev/null 2>&1; then
  docker run --rm -v "$POSTGRES_VOLUME:/volume" -v "$BACKUP_STAGING/volumes:/backup" alpine sh -c "tar -czf /backup/${POSTGRES_VOLUME}_${TIMESTAMP}.tar.gz -C /volume ."
  echo "[OK] Volumen $POSTGRES_VOLUME respaldado"
else
  echo "[WARN] Volumen $POSTGRES_VOLUME no existe"
fi

if docker volume inspect "$PGADMIN_VOLUME" >/dev/null 2>&1; then
  docker run --rm -v "$PGADMIN_VOLUME:/volume" -v "$BACKUP_STAGING/volumes:/backup" alpine sh -c "tar -czf /backup/${PGADMIN_VOLUME}_${TIMESTAMP}.tar.gz -C /volume ."
  echo "[OK] Volumen $PGADMIN_VOLUME respaldado"
else
  echo "[WARN] Volumen $PGADMIN_VOLUME no existe"
fi

# 3) Guardar imágenes Docker usadas por el stack
echo "[INFO] Guardando imágenes Docker del stack"
IMAGES_LIST=""
if [[ -f "$COMPOSE_FILE" ]]; then
  set +e
  IMAGES_LIST="$($COMPOSE_CMD -f "$COMPOSE_FILE" images --quiet 2>/dev/null | sort -u | tr '\n' ' ')"
  set -e
fi
# fallback a nombres conocidos
if [[ -z "$IMAGES_LIST" ]]; then
  IMAGES_LIST="postgres:15-alpine dpage/pgadmin4:8.11 $BACKEND_IMAGE_NAME"
fi
echo "[INFO] Imágenes a salvar: $IMAGES_LIST"
set +e
docker save -o "$BACKUP_STAGING/docker/images_${TIMESTAMP}.tar" $IMAGES_LIST
IMAGES_RC=$?
set -e
if [[ $IMAGES_RC -ne 0 ]]; then
  echo "[WARN] No se pudieron guardar todas las imágenes (rc=$IMAGES_RC). Continúo."
else
  echo "[OK] Imágenes guardadas en docker/images_${TIMESTAMP}.tar"
fi

# 4) Copiar compose y configs útiles
echo "[INFO] Copiando configuración relevante"
cp -f "$COMPOSE_FILE" "$BACKUP_STAGING/config/" 2>/dev/null || true
[[ -f "$ROOT_DIR/pgadmin/servers.json" ]] && cp -f "$ROOT_DIR/pgadmin/servers.json" "$BACKUP_STAGING/config/servers.json"
[[ -f "$ROOT_DIR/Springboot/Dockerfile" ]] && cp -f "$ROOT_DIR/Springboot/Dockerfile" "$BACKUP_STAGING/config/"
[[ -f "$ROOT_DIR/Springboot/pom.xml" ]] && cp -f "$ROOT_DIR/Springboot/pom.xml" "$BACKUP_STAGING/config/"
[[ -f "$ROOT_DIR/docker-compose.prod.yml" ]] && cp -f "$ROOT_DIR/docker-compose.prod.yml" "$BACKUP_STAGING/config/docker-compose.prod.yml"
# Opcional: incluir .env (contiene secretos). Si habilitas, descomenta la línea siguiente y protege tus backups.
# cp -f "$ROOT_DIR/.env" "$BACKUP_STAGING/config/.env"

# 4b) Artefactos (jar de Spring Boot)
echo "[INFO] Incluyendo artefactos de Spring Boot (si existen)"
JAR_DIR="$ROOT_DIR/Springboot/target"
if [[ -d "$JAR_DIR" ]]; then
  JAR_FILE="$(ls -1t "$JAR_DIR"/*.jar 2>/dev/null | grep -v '\.original$' | head -n1 || true)"
  if [[ -n "$JAR_FILE" && -f "$JAR_FILE" ]]; then
    cp -f "$JAR_FILE" "$BACKUP_STAGING/artifacts/"
    (cd "$BACKUP_STAGING/artifacts" && sha256sum "$(basename "$JAR_FILE")" > SHA256SUMS.txt ) || true
    echo "[OK] Artefacto incluido: $(basename "$JAR_FILE")"
  else
    echo "[WARN] No se encontró .jar en $JAR_DIR"
  fi
else
  echo "[WARN] Carpeta $JAR_DIR no existe"
fi

# 5) Generar tar.gz final
FINAL_TAR="$BACKUP_ROOT/complete_backup_${TIMESTAMP}.tar.gz"
echo "[INFO] Empaquetando backup: $FINAL_TAR"
tar -C "$BACKUP_STAGING" -czf "$FINAL_TAR" .
echo "[OK] Backup completado: $FINAL_TAR"

# 6) Retención por días (borra > N días)
echo "[INFO] Aplicando retención de ${RETENTION_DAYS} días en $BACKUP_ROOT"
set +e
find "$BACKUP_ROOT" -type f -name 'complete_backup_*.tar.gz' -mtime +"$RETENTION_DAYS" -print -delete
set -e

# Limpieza temporal
rm -rf "$TMP_DIR"
echo "[DONE] Respaldo finalizado"

# Sugerencia de crontab (ejecutar diario a las 02:30)
# 30 2 * * * /bin/bash /ruta/al/repo/scripts/backup_recetas_stack.sh >> /var/log/backup_recetas.log 2>&1
