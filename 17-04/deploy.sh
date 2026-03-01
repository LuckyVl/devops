#!/bin/bash
set -euo pipefail

# ====== СКРИПТ РАЗВЁРТЫВАНИЯ НА VM ======

REPO_URL="https://github.com/LuckyVl/devops.git"
BASE_DIR="/opt/devops"
PROJECT_DIR="/opt/devops/17-04"

echo "[*] Клонируем репозиторий..."
if [[ -d "$BASE_DIR" ]]; then
  cd "$BASE_DIR"
  git pull origin main
else
  sudo git clone "$REPO_URL" "$BASE_DIR"
fi

echo "[*] Переходим в директорию проекта..."
cd "$PROJECT_DIR"

echo "[*] Создаём .env (если не существует)..."
if [[ ! -f "$PROJECT_DIR/.env" ]]; then
  sudo bash -c "cat > '$PROJECT_DIR/.env' << 'EOF'
DB_ROOT_PASS=Str0ngR00tP@ss!2026
DB_PASS=AppUs3rP@ss!2026
DB_NAME=virtd
EOF"
  sudo chmod 600 "$PROJECT_DIR/.env"
  echo "[✓] Создан .env"
fi

echo "[*] Создаём директории..."
sudo mkdir -p "$PROJECT_DIR/logs/nginx" /opt/backup
sudo chown -R $USER:$USER "$PROJECT_DIR/logs" /opt/backup 2>/dev/null || true

echo "[*] Запускаем docker compose..."
docker compose up -d --build

echo "[*] Ждём запуска..."
sleep 10

echo "[*] Проверка..."
docker ps -a
curl -s -o /dev/null -w "HTTP: %{http_code}\n" http://127.0.0.1:8090 || echo "[!] Проверьте логи"

echo "[✓] Готово!"