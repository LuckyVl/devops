#!/bin/bash
set -euo pipefail

# ====== СКРИПТ РАЗВЁРТЫВАНИЯ НА VM ======

REPO_URL="https://github.com/LuckyVl/devops/tree/main/17-04"
PROJECT_DIR="/opt/project"

echo "[*] Клонируем репозиторий в ${PROJECT_DIR}..."
if [[ -d "$PROJECT_DIR" ]]; then
  cd "$PROJECT_DIR"
  git pull origin main
else
  git clone "$REPO_URL" "$PROJECT_DIR"
  cd "$PROJECT_DIR"
fi

echo "[*] Создаём .env (если не существует)..."
if [[ ! -f "$PROJECT_DIR/.env" ]]; then
  cat > "$PROJECT_DIR/.env" << 'EOF'
DB_ROOT_PASS=Str0ngR00tP@ss!2026
DB_PASS=AppUs3rP@ss!2026
DB_NAME=virtd
EOF
  chmod 600 "$PROJECT_DIR/.env"
  echo "[✓] Создан .env"
fi

echo "[*] Создаём директории..."
mkdir -p "$PROJECT_DIR/logs/nginx" /opt/backup

echo "[*] Запускаем docker compose..."
cd "$PROJECT_DIR"
docker compose up -d --build

echo "[*] Ждём запуска..."
sleep 10

echo "[*] Проверка..."
docker ps -a
curl -s -o /dev/null -w "HTTP: %{http_code}\n" http://127.0.0.1:8090 || echo "[!] Проверьте логи"

echo "[✓] Готово!"