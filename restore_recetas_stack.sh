#!/usr/bin/env bash

# Re-ejecutar con bash si fue invocado con sh (que no soporta 'pipefail')
if [ -z "${BASH_VERSION:-}" ]; then
  exec /usr/bin/env bash "$0" "$@"
fi

set -euo pipefail

# Restauracion de backup generado por backup_recetas_stack.sh/.ps1
# Este script restaura:
#  - Imagenes Docker (docker load)
#  - Volumenes Docker (desempaquetando cada tar.gz en el volumen)
#  - Dump de base de datos Postgres (opcional, si no restauraste el volumen o si deseas reimportar)
#
# Requisitos previos en el servidor Debian con Docker:
#  - Docker instalado y en ejecucion
#  - Contenedores detenidos antes de restaurar volumenes (docker compose down)
#  - Espacio suficiente en disco
#
# Uso:
#  restore_recetas_stack.sh /ruta/al/complete_backup_YYYYMMDD_HHMMSS.tar.gz [opciones]
#    Variables de entorno opcionales:
#      POSTGRES_CONTAINER_NAME (default: api-recetas-postgres)
#      POSTGRES_DB (default: api_recetas_postgres)
#      POSTGRES_USER (default: postgres)
#      RESTORE_DB (default: auto) -> auto|yes|no
#      COMPOSE_UP (default: no)   -> yes|no (si hay compose extraido)
#      ENV_FILE (default: auto)   -> ruta a .env para usar con compose (auto: usa $BASE_DIR/.env si existe)
#      BASE_DIR (default: /home/admin/api-recetas) -> directorio de trabajo en el servidor
#      DEPLOY_DIR (default: $BASE_DIR)            -> destino donde se dejara el compose antes de levantar

BASE_DIR="${BASE_DIR:-/home/admin/api-recetas}"
DEPLOY_DIR="${DEPLOY_DIR:-$BASE_DIR}"

BACKUP_TAR="${1:-}"
if [[ -z "$BACKUP_TAR" ]]; then
  # Intentar auto-descubrir el backup mas reciente en $BASE_DIR/backups
  if [[ -d "$BASE_DIR/backups" ]]; then
    BACKUP_TAR="$(ls -1t "$BASE_DIR"/backups/complete_backup_*.tar.gz 2>/dev/null | head -n1 || true)"
  fi
  if [[ -z "$BACKUP_TAR" ]]; then
    echo "Uso: $0 /ruta/a/complete_backup_YYYYMMDD_HHMMSS.tar.gz" >&2
    echo "Tambien puedes colocarlo en $BASE_DIR/backups y el script intentara detectarlo automaticamente." >&2
    exit 1
  fi
fi

POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-api-recetas-postgres}"
POSTGRES_DB="${POSTGRES_DB:-api_recetas_postgres}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
RESTORE_DB="${RESTORE_DB:-auto}"
COMPOSE_UP="${COMPOSE_UP:-no}"
ENV_FILE_DEFAULT="$BASE_DIR/.env"
if [[ -z "${ENV_FILE:-}" && -f "$ENV_FILE_DEFAULT" ]]; then
  ENV_FILE="$ENV_FILE_DEFAULT"
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "[INFO] Extrayendo $BACKUP_TAR"
tar -C "$WORKDIR" -xzf "$BACKUP_TAR"

echo "[INFO] Archivos extraidos (nivel 2):"
find "$WORKDIR" -maxdepth 2 -type f -printf '  - %P\n' || true

# Buscar archivos de imagenes (pueden ser multiples archivos .tar individuales o uno combinado)
DB_SQL="$(ls -1 "$WORKDIR"/database/pgdump_*.sql* 2>/dev/null | head -n1 || true)"

# Verificar prerequisitos: docker y docker-compose/docker compose
DOCKER_COMPOSE_CMD=""
if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] Docker no esta instalado o no esta en PATH. Instala Docker antes de continuar." >&2
  exit 2
fi

# Preferir el subcomando 'docker compose' si esta disponible, si no usar 'docker-compose' binario
if docker compose version >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD="docker-compose"
else
  echo "[WARN] No se encontro comando 'docker compose' ni 'docker-compose'. Algunas operaciones pueden fallar." >&2
fi

# 1) Cargar imagenes - buscar todos los archivos .tar en la carpeta docker
echo "[INFO] Cargando imagenes Docker..."
images_loaded=0
if [[ -d "$WORKDIR/docker" ]]; then
  shopt -s nullglob
  image_files=("$WORKDIR"/docker/*.tar)
  if [[ ${#image_files[@]} -gt 0 ]]; then
    for img_file in "${image_files[@]}"; do
      echo "[INFO] -> Cargando imagen: $(basename "$img_file")"
      if docker load -i "$img_file" >/dev/null 2>&1; then
        echo "[OK]   Imagen cargada: $(basename "$img_file")"
        ((images_loaded++))
      else
        echo "[WARN] No se pudo cargar: $(basename "$img_file")"
      fi
    done
    echo "[OK]   Total imagenes cargadas: $images_loaded"
  else
    echo "[WARN] No se encontraron archivos .tar de imagenes en $WORKDIR/docker"
  fi
else
  echo "[WARN] Carpeta docker no encontrada en el backup"
fi

# 2) Restaurar volumenes
VOLUMES_DIR="$WORKDIR/volumes"
if [[ -d "$VOLUMES_DIR" ]]; then
  shopt -s nullglob
  vol_files=("$VOLUMES_DIR"/*.tar.gz)
  if [[ ${#vol_files[@]} -gt 0 ]]; then
    echo "[INFO] Restaurando volumenes (${#vol_files[@]})"
    echo "[WARN] Asegurate de tener los contenedores detenidos (docker compose down) antes de restaurar volumenes."
    for vf in "${vol_files[@]}"; do
      base="$(basename "$vf")"
      # Derivar nombre del volumen removiendo sufijo _YYYYMMDD_HHMMSS.tar.gz
      vol_name="${base%_????????_??????.tar.gz}"
      echo "[INFO] -> Volumen: $vol_name (archivo: $base)"
      if ! docker volume inspect "$vol_name" >/dev/null 2>&1; then
        docker volume create "$vol_name" >/dev/null
        echo "[INFO]    Volumen creado: $vol_name"
      fi

      echo "[INFO]    Restaurando desde archivo: $vf"
      # Montar el archivo tar.gz individualmente (bind) y el volumen como volume
      # Usa --mount para evitar problemas de interpretacion de rutas y dejar claro el tipo de mount
      # Intento preferido: --mount (mas explicito). Si falla, usar contenedor temporal + docker cp (funciona en Docker Desktop/Git Bash).
      if docker run --rm \
        --mount type=volume,source="$vol_name",target=/volume \
        --mount type=bind,source="$vf",target=/backup/backup.tar.gz,readonly \
        postgres:15 sh -c 'set -e; rm -rf /volume/*; tar -xzf /backup/backup.tar.gz -C /volume'; then
        echo "[OK]   Volumen restaurado (via --mount): $vol_name"
      else
        echo "[WARN] --mount fallo, intentando extraccion via contenedor temporal para $vol_name" >&2
        # Contenedor temporal: montar solo el volumen y usar docker cp para evitar path translation issues
        tmp_ctr="restore_tmp_$(date +%s)_$RANDOM"
        if ! docker run -d --name "$tmp_ctr" -v "$vol_name:/volume" postgres:15 sleep 600 >/dev/null; then
          echo "[ERROR] No se pudo crear contenedor temporal $tmp_ctr para $vol_name" >&2
          exit 1
        fi
        # Copiar archivo dentro del contenedor y extraer
        if ! docker cp "$vf" "$tmp_ctr:/backup.tar.gz"; then
          echo "[ERROR] docker cp fallo para $vf -> $tmp_ctr:/backup.tar.gz" >&2
          docker rm -f "$tmp_ctr" >/dev/null || true
          exit 1
        fi
        if ! docker exec "$tmp_ctr" sh -c 'rm -rf /volume/* && tar -xzf /backup.tar.gz -C /volume'; then
          echo "[ERROR] Extraccion dentro del contenedor temporal fallo para $vol_name" >&2
          docker rm -f "$tmp_ctr" >/dev/null || true
          exit 1
        fi
        docker rm -f "$tmp_ctr" >/dev/null || true
        echo "[OK]   Volumen restaurado (via contenedor temporal): $vol_name"
      fi
      echo "[OK]   Volumen restaurado: $vol_name"
    done
  else
    echo "[WARN] No hay archivos de volumenes en $VOLUMES_DIR"
  fi
else
  echo "[WARN] Carpeta de volumenes no encontrada: $VOLUMES_DIR"
fi

# 3) Restaurar DB (opcional)
if [[ -n "$DB_SQL" && -f "$DB_SQL" ]]; then
  do_restore_db="no"
  if [[ "$RESTORE_DB" == "yes" ]]; then
    do_restore_db="yes"
  elif [[ "$RESTORE_DB" == "auto" ]]; then
    # Si NO se restauro el volumen de Postgres, intentar importar DB
    # Heuristica: si existe un archivo de volumen de postgres_data entre los extraidos
    if ls -1 "$WORKDIR"/volumes/*postgres*data_*.tar.gz >/dev/null 2>&1; then
      echo "[INFO] Detectado volumen de Postgres restaurado. Omitiendo importacion SQL (RESTORE_DB=auto)."
      do_restore_db="no"
    else
      do_restore_db="yes"
    fi
  fi

  if [[ "$do_restore_db" == "yes" ]]; then
    echo "[INFO] Restaurando DB desde: $DB_SQL"
    if docker ps --format '{{.Names}}' | grep -qx "$POSTGRES_CONTAINER_NAME"; then
      # Verificar si el dump esta comprimido (.gz)
      if [[ "$DB_SQL" == *.gz ]]; then
        echo "[INFO] Descomprimiendo dump SQL..."
        gunzip -c "$DB_SQL" | docker exec -i "$POSTGRES_CONTAINER_NAME" sh -lc "psql -U '$POSTGRES_USER' -d '$POSTGRES_DB'"
      else
        docker exec -i "$POSTGRES_CONTAINER_NAME" sh -lc "psql -U '$POSTGRES_USER' -d '$POSTGRES_DB'" < "$DB_SQL"
      fi
      echo "[OK]   Dump importado en $POSTGRES_CONTAINER_NAME ($POSTGRES_DB)"
    else
      echo "[WARN] Contenedor Postgres '$POSTGRES_CONTAINER_NAME' no esta ejecutandose. Omitiendo importacion."
    fi
  fi
else
  echo "[WARN] No se encontro dump SQL en $WORKDIR/database"
fi

# 4) Levantar stack (opcional) si hay compose y el usuario lo pide
CONFIG_DIR="$WORKDIR/config"
# 4) Copiar SIEMPRE configuracion al DEPLOY_DIR para dejar artefactos listos
compose_src=""
compose_name="docker-compose.prod.yml"
if [[ -f "$CONFIG_DIR/docker-compose.prod.yml" ]]; then
  compose_src="$CONFIG_DIR/docker-compose.prod.yml"
  compose_name="docker-compose.prod.yml"
elif [[ -f "$CONFIG_DIR/docker-compose.yml" ]]; then
  compose_src="$CONFIG_DIR/docker-compose.yml"
  compose_name="docker-compose.yml"
fi

echo "[INFO] Preparando directorio de despliegue: $DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"
if [[ -n "$compose_src" ]]; then
  cp -f "$compose_src" "$DEPLOY_DIR/$compose_name"
  echo "[OK]   Compose dejado en: $DEPLOY_DIR/$compose_name"
else
  echo "[WARN] No se encontro archivo docker-compose en $CONFIG_DIR"
fi
if [[ -f "$CONFIG_DIR/servers.json" ]]; then
  mkdir -p "$DEPLOY_DIR/pgadmin"
  cp -f "$CONFIG_DIR/servers.json" "$DEPLOY_DIR/pgadmin/servers.json"
  echo "[OK]   pgAdmin servers.json dejado en: $DEPLOY_DIR/pgadmin/servers.json"
fi

# 5) Levantar stack si asi se solicito
if [[ "$COMPOSE_UP" == "yes" && -n "$compose_src" ]]; then
  echo "[INFO] Levantando stack con: $DEPLOY_DIR/$compose_name"
  # Usar la variable DOCKER_COMPOSE_CMD detectada
  if [[ -z "$DOCKER_COMPOSE_CMD" ]]; then
    echo "[ERROR] No se encontro un comando de docker-compose funcional. Abortando levantado." >&2
    exit 3
  fi
  if [[ -n "${ENV_FILE:-}" && -f "$ENV_FILE" ]]; then
    (cd "$DEPLOY_DIR" && eval "$DOCKER_COMPOSE_CMD -f \"$compose_name\" --env-file \"$ENV_FILE\" up -d")
  else
    (cd "$DEPLOY_DIR" && eval "$DOCKER_COMPOSE_CMD -f \"$compose_name\" up -d")
  fi
  echo "[OK]   Stack levantado"
else
  if [[ "$COMPOSE_UP" != "yes" ]]; then
    echo "[INFO] Compose no ejecutado automaticamente. Puedes usar:"
    echo "       docker compose -f $DEPLOY_DIR/$compose_name --env-file ${ENV_FILE:-$DEPLOY_DIR/.env} up -d"
  fi
fi

echo "[DONE] Restauracion completada"