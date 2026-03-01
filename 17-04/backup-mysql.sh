#!/bin/bash
set -euo pipefail

# ====== СКРИПТ РЕЗЕРВНОГО КОПИРОВАНИЯ MYSQL ======

# Пути
PROJECT_DIR="/opt/devops/17-04"
ENV_BACKUP="${PROJECT_DIR}/.env.backup"
BACKUP_DIR="/opt/backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql.gz"

# Сеть и хост БД (из compose.yaml)
NETWORK="17-04_backend"
DB_HOST="172.20.0.10"

# Загружаем секреты из защищённого файла (НЕ в git!)
if [[ -f "$ENV_BACKUP" ]]; then
  source "$ENV_BACKUP"
else
  echo "ERROR: $ENV_BACKUP not found. Create with MYSQL_ROOT_PASS" >&2
  exit 1
fi

# Создаём директорию для бэкапов
mkdir -p "$BACKUP_DIR"

docker run --rm \
  --network "$NETWORK" \
  -v "${BACKUP_DIR}:/backup" \
  schnitzler/mysqldump:latest \
  --host="$DB_HOST" --user=root --password="${MYSQL_ROOT_PASS}" virtd \
  | gzip > "$BACKUP_FILE"

# Проверка и логирование
if [[ -s "$BACKUP_FILE" ]]; then
  SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
  echo "[$(date)] ✓ Backup: $BACKUP_FILE ($SIZE)" >> /var/log/mysql-backup.log

  # Ротация: оставляем последние 5 бэкапов
  cd "$BACKUP_DIR"
  ls -t backup_*.sql.gz 2>/dev/null | tail -n +6 | xargs -r rm -v >> /var/log/mysql-backup.log 2>&1
else
  echo "[$(date)] ✗ Backup FAILED: $BACKUP_FILE" >&2
  exit 1
fi