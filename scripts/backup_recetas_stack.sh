echo "[INFO] Raíz repo: $ROOT_DIR"
echo "[INFO] Usando comando compose: $COMPOSE_CMD"
#!/usr/bin/env bash

# backup_recetas_stack.sh
# Respaldo completo del stack (imágenes Docker, dump Postgres, volúmenes, configs y artefactos).
# No realiza subida remota; crea un tar.gz en ./backups listo para transferir.

set -euo pipefail

# --- Configuración (sobrescribible por variables de entorno) ---
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
BACKUP_DIR="${BACKUP_DIR:-$ROOT_DIR/backups}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
TMP_DIR="$(mktemp -d "$BACKUP_DIR/backup_tmp.XXXXXX")"

# Contenedores / volúmenes por defecto (ajusta si tu compose usa otros nombres)
POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-api-recetas-postgres}"
POSTGRES_DB="${POSTGRES_DB:-api_recetas_postgres}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_VOLUME="${POSTGRES_VOLUME:-postgres_data}"
PGADMIN_VOLUME="${PGADMIN_VOLUME:-pgadmin_data}"
BACKEND_IMAGE_NAME="${BACKEND_IMAGE_NAME:-api-recetas_final-backend:latest}"
COMPOSE_FILE="${COMPOSE_FILE:-$ROOT_DIR/docker-compose.yml}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"

mkdir -p "$BACKUP_DIR"
mkdir -p "$TMP_DIR/staging" "$TMP_DIR/staging/database" "$TMP_DIR/staging/volumes" "$TMP_DIR/staging/docker" "$TMP_DIR/staging/config" "$TMP_DIR/staging/artifacts"

echo "[INFO] Backup root: $BACKUP_DIR"
echo "[INFO] Temporary staging: $TMP_DIR/staging"

# Cargar .env local si existe (quita CRLF si vienen de Windows)
if [ -f "$ROOT_DIR/.env" ]; then
  echo "[INFO] Cargando $ROOT_DIR/.env"
  CLEAN_ENV="$(mktemp)"
  tr -d '\r' < "$ROOT_DIR/.env" > "$CLEAN_ENV"
  # shellcheck disable=SC1090
  set -a; . "$CLEAN_ENV"; set +a
  rm -f "$CLEAN_ENV"
fi

# Helper para imprimir error y salir
fail() { echo "[ERROR] $*" >&2; rm -rf "$TMP_DIR"; exit 1; }

### 1) Dump de Postgres
DB_DUMP="$TMP_DIR/staging/database/pgdump_${POSTGRES_DB}_${TIMESTAMP}.sql"
echo "[INFO] Generando dump de Postgres desde contenedor: $POSTGRES_CONTAINER_NAME (db=$POSTGRES_DB)"
if docker ps -a --format '{{.Names}}' | grep -qx "$POSTGRES_CONTAINER_NAME"; then
  set +e
  if [ -n "${POSTGRES_PASSWORD:-}" ]; then
    docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" "$POSTGRES_CONTAINER_NAME" sh -lc "pg_dump -U '$POSTGRES_USER' -d '$POSTGRES_DB'" > "$DB_DUMP"
  else
    docker exec "$POSTGRES_CONTAINER_NAME" sh -lc "pg_dump -U '$POSTGRES_USER' -d '$POSTGRES_DB'" > "$DB_DUMP"
  fi
  rc=$?
  set -e
  if [ $rc -ne 0 ]; then
    echo "[WARN] pg_dump falló (rc=$rc). Se omitirá el dump pero continuaré con resto de backup."
    rm -f "$DB_DUMP" || true
  else
    gzip -9 "$DB_DUMP"
    echo "[OK] Dump generado: ${DB_DUMP}.gz"
  fi
else
  echo "[WARN] Contenedor $POSTGRES_CONTAINER_NAME no encontrado. Omitiendo pg_dump."
fi

### 2) Guardar imágenes Docker (priorizar contenedores en ejecución)
IMAGES_FILE="$TMP_DIR/staging/docker/images_${TIMESTAMP}.txt"
IMAGES_TAR="$TMP_DIR/staging/docker/images_${TIMESTAMP}.tar"
echo "[INFO] Detectando imágenes activas (contenedores en ejecución)..."
if command -v docker >/dev/null 2>&1; then
  # 1) imágenes de contenedores en ejecución (running)
  docker ps --format '{{.Image}}' | sort -u > "$IMAGES_FILE" || true

  # 2) si no hay contenedores en ejecución, intentar imágenes definidas en docker-compose
  if [ ! -s "$IMAGES_FILE" ] && [ -f "$COMPOSE_FILE" ]; then
    if docker compose -f "$COMPOSE_FILE" images --quiet >/dev/null 2>&1; then
      echo "[INFO] No hay contenedores en ejecución; usando imágenes definidas en compose"
      docker compose -f "$COMPOSE_FILE" images --quiet | sort -u > "$IMAGES_FILE" || true
    fi
  fi

  # 3) fallback final: todas las imágenes de contenedores (incluye parados)
  if [ ! -s "$IMAGES_FILE" ]; then
    docker ps -a --format '{{.Image}}' | sort -u > "$IMAGES_FILE" || true
  fi
  if [ -s "$IMAGES_FILE" ]; then
    echo "[INFO] Imágenes a guardar:"; sed -n '1,200p' "$IMAGES_FILE"
    # docker save lee la lista desde archivo
    xargs -a "$IMAGES_FILE" docker save -o "$IMAGES_TAR" || echo "[WARN] docker save devolvió error; se intentará imagen por imagen"
    if [ ! -f "$IMAGES_TAR" ] || [ ! -s "$IMAGES_TAR" ]; then
      rm -f "$IMAGES_TAR"
      while IFS= read -r img; do
        safe="$(echo "$img" | tr '/:@' '___')"
        out="$TMP_DIR/staging/docker/${safe}_${TIMESTAMP}.tar"
        docker save -o "$out" "$img" || echo "[WARN] no se pudo guardar imagen: $img"
      done < "$IMAGES_FILE"
    else
      echo "[OK] Imágenes guardadas en $IMAGES_TAR"
    fi
  else
    echo "[WARN] No se detectaron imágenes para guardar."
  fi
else
  echo "[WARN] docker no disponible en PATH. Omitiendo guardado de imágenes."
fi

### 3) Respaldar volúmenes (detectar por prefijo o heurística)
echo "[INFO] Detectando volúmenes Docker para respaldo"
# Construir lista candidate basada en varias heurísticas:
#  - nombres exactos en POSTGRES_VOLUME y PGADMIN_VOLUME
#  - nombres que terminan en _${POSTGRES_VOLUME} o _${PGADMIN_VOLUME}
#  - nombres que contienen 'postgres' o 'pgadmin'
#  - nombres que empiezan con el directorio del repo (prefijo de compose)

PROJECT_DIR_BASENAME="$(basename "$ROOT_DIR")"
SANITIZED_PREFIX="$(echo "$PROJECT_DIR_BASENAME" | tr '[:upper:]-' '[:lower:]_' | sed 's/[^a-z0-9_]/_/g')"

vols_to_backup=""
if command -v docker >/dev/null 2>&1; then
  docker volume ls --format '{{.Name}}' | while IFS= read -r v; do
    # exact names
    if [ "$v" = "$POSTGRES_VOLUME" ] || [ "$v" = "$PGADMIN_VOLUME" ]; then
      echo "$v"
      continue
    fi
    # suffix match (project prefixed volumes like project_postgres_data)
    if echo "$v" | grep -E "_(?:${POSTGRES_VOLUME}|${PGADMIN_VOLUME})$" >/dev/null 2>&1; then
      echo "$v"
      continue
    fi
    # contains keywords
    if echo "$v" | grep -E "postgres|pgadmin" >/dev/null 2>&1; then
      echo "$v"
      continue
    fi
    # starts with project basename or sanitized prefix
    if echo "$v" | grep -E "^${PROJECT_DIR_BASENAME}_|^${SANITIZED_PREFIX}_" >/dev/null 2>&1; then
      echo "$v"
      continue
    fi
  done | sort -u > "$TMP_DIR/staging/volumes/vols_to_backup_${TIMESTAMP}.txt"
  vols_to_backup_file="$TMP_DIR/staging/volumes/vols_to_backup_${TIMESTAMP}.txt"
  if [ -s "$vols_to_backup_file" ]; then
    echo "[INFO] Volúmenes detectados para respaldo:"; sed -n '1,200p' "$vols_to_backup_file"
  else
    echo "[WARN] No se detectaron volúmenes por heurística. Intentando nombres por defecto: $POSTGRES_VOLUME $PGADMIN_VOLUME"
    printf "%s
" "$POSTGRES_VOLUME" "$PGADMIN_VOLUME" > "$vols_to_backup_file"
  fi
else
  echo "[WARN] docker no disponible; no se pueden listar volúmenes. Usando nombres por defecto."
  printf "%s
" "$POSTGRES_VOLUME" "$PGADMIN_VOLUME" > "$TMP_DIR/staging/volumes/vols_to_backup_${TIMESTAMP}.txt"
  vols_to_backup_file="$TMP_DIR/staging/volumes/vols_to_backup_${TIMESTAMP}.txt"
fi

while IFS= read -r vol; do
  [ -z "$vol" ] && continue
  if docker volume inspect "$vol" >/dev/null 2>&1; then
    out="$TMP_DIR/staging/volumes/${vol}_${TIMESTAMP}.tar.gz"
    echo "[INFO] Empaquetando volumen: $vol -> $out"
    # Usar tar por stdout para evitar problemas de bind-mount en entornos Windows/Docker Desktop
    if docker run --rm -v "$vol:/volume:ro" alpine sh -c "cd /volume || exit 0; tar -czf - ." > "$out"; then
      echo "[OK] Volumen $vol empaquetado -> $out"
    else
      echo "[WARN] Falló empaquetar volumen $vol via stdout redirection. Intentando método alternativo con contenedor temporal."
      tmpctr="backup_tmp_pack_${TIMESTAMP}"
      docker run -d --name "$tmpctr" -v "$vol:/volume" alpine sleep 600 >/dev/null 2>&1 || true
      if docker cp "$tmpctr":/volume - > /dev/null 2>&1; then
        # Fallback: intentar copiar contenido vía tar dentro del contenedor a un archivo en /tmp y luego docker cp out
        docker exec "$tmpctr" sh -c "cd /volume || exit 0; tar -czf /tmp/${vol}_${TIMESTAMP}.tar.gz ." || true
        docker cp "$tmpctr":/tmp/${vol}_${TIMESTAMP}.tar.gz "$out" || true
      fi
      docker rm -f "$tmpctr" >/dev/null 2>&1 || true
      if [ -f "$out" ]; then
        echo "[OK] Volumen $vol empaquetado (fallback) -> $out"
      else
        echo "[ERROR] No se pudo empaquetar el volumen $vol"
      fi
    fi
  else
    echo "[WARN] Volumen $vol no existe, se omite."
  fi
done < "$vols_to_backup_file"

### 4) Copiar archivos relevantes (compose, configs, jar)
echo "[INFO] Copiando configuración y artefactos"
if [ -f "$COMPOSE_FILE" ]; then
  cp -f "$COMPOSE_FILE" "$TMP_DIR/staging/config/"
fi
if [ -f "$ROOT_DIR/pgadmin/servers.json" ]; then
  mkdir -p "$TMP_DIR/staging/config/pgadmin"
  cp -f "$ROOT_DIR/pgadmin/servers.json" "$TMP_DIR/staging/config/pgadmin/"
fi
if [ -f "$ROOT_DIR/Springboot/Dockerfile" ]; then
  cp -f "$ROOT_DIR/Springboot/Dockerfile" "$TMP_DIR/staging/config/"
fi
if [ -f "$ROOT_DIR/Springboot/pom.xml" ]; then
  cp -f "$ROOT_DIR/Springboot/pom.xml" "$TMP_DIR/staging/config/"
fi
JAR_DIR="$ROOT_DIR/Springboot/target"
if [ -d "$JAR_DIR" ]; then
  JAR_FILE="$(ls -1t "$JAR_DIR"/*.jar 2>/dev/null | grep -v '\.original$' | head -n1 || true)"
  if [ -n "$JAR_FILE" ]; then
    cp -f "$JAR_FILE" "$TMP_DIR/staging/artifacts/"
    (cd "$TMP_DIR/staging/artifacts" && sha256sum "$(basename "$JAR_FILE")" > SHA256SUMS.txt) || true
  fi
fi

### 5) Empaquetar final
OUTFILE="$BACKUP_DIR/complete_backup_${TIMESTAMP}.tar.gz"
echo "[INFO] Empaquetando todo en: $OUTFILE"
tar -C "$TMP_DIR/staging" -czf "$OUTFILE" .
echo "[OK] Backup creado: $OUTFILE"
ls -lh "$OUTFILE" || true

### 6) Retención
echo "[INFO] Aplicando retención de $RETENTION_DAYS días en $BACKUP_DIR"
find "$BACKUP_DIR" -type f -name 'complete_backup_*.tar.gz' -mtime +"$RETENTION_DAYS" -print -delete || true

# Limpieza
rm -rf "$TMP_DIR"
echo "[DONE] Respaldo finalizado"

exit 0
