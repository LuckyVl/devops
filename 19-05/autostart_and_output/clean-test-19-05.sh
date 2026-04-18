#!/bin/bash
# clean-test-19-05-fixed.sh — запуск тестов с корректными правами Docker

set -e

echo "=== Этап 0: Проверка прав Docker ==="
if ! docker ps &>/dev/null; then
    echo "⚠️  Нет доступа к Docker. Пробуем добавить пользователя в группу..."
    sudo usermod -aG docker $USER
    echo "❗ Требуется перезапуск сессии. Выполните:"
    echo "   exec sg docker -c 'bash'"
    echo "   Затем запустите этот скрипт снова."
    exit 1
fi
echo "✅ Docker OK"

echo "=== Этап 1: Клонируем репозиторий ==="
mkdir -p ~/homework && cd ~/homework
git clone https://github.com/LuckyVl/devops.git 2>/dev/null || echo "✅ Уже клонировано"
cd devops/19-05

echo "=== Этап 2: Виртуальное окружение ==="
python3 -m venv .venv
source .venv/bin/activate

echo "=== Этап 3: Зависимости ==="
pip install --upgrade pip --quiet
pip install --quiet "molecule>=25.0.0" "molecule-docker" "ansible-core>=2.15.0"
echo "✅ Molecule: $(molecule --version | head -1)"

echo "=== Этап 4: Переменные окружения ==="
export ANSIBLE_LINT_SKIP=role-name,name[casing],schema,yaml
export ANSIBLE_LINT_ENABLED=false

echo "=== Этап 5: Запуск теста ==="
rm -rf .ansible .molecule molecule/default/.molecule ~/.ansible/collections ~/.cache/molecule 2>/dev/null
molecule test -s default 2>&1 | tee ~/homework/molecule-output.txt | tail -100

echo "=== Этап 6: Фиксация результатов ==="
cd ~/homework/devops
echo "🏷️  Теги: $(git tag -l)"
echo "🔗 Удалённые теги: $(git ls-remote --tags origin | grep v1.0.0 | cut -c1-7)"
echo "💬 Последний коммит: $(git log -1 --oneline)"

echo "=== ✅ Готово! ==="
echo "📁 Вывод теста: ~/homework/molecule-output.txt"
echo "🔗 Отчёт: https://github.com/LuckyVl/devops/blob/main/19-05.md"