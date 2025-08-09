#!/bin/bash

# Скрипт для настройки MCP интеграции с Figma
# Использование: ./setup_figma_mcp.sh

echo "🎨 Настройка MCP интеграции с Figma для проекта Tasker"
echo "=================================================="

# Проверяем наличие Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js не найден. Пожалуйста, установите Node.js с https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js найден: $(node --version)"

# Проверяем наличие npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm не найден. Пожалуйста, установите npm"
    exit 1
fi

echo "✅ npm найден: $(npm --version)"

# Устанавливаем MCP серверы для Figma
echo ""
echo "📦 Установка MCP серверов для Figma..."

echo "Установка figma-developer-mcp..."
npm install -g figma-developer-mcp

echo ""
echo "✅ MCP серверы установлены успешно!"

# Проверяем наличие файлов конфигурации
echo ""
echo "🔧 Проверка файлов конфигурации..."

if [ -f "mcp.json" ]; then
    echo "✅ Файл mcp.json найден"
else
    echo "❌ Файл mcp.json не найден"
fi

if [ -f "claude_desktop_config.json" ]; then
    echo "✅ Файл claude_desktop_config.json найден"
else
    echo "❌ Файл claude_desktop_config.json не найден"
fi

if [ -f ".gitignore" ]; then
    echo "✅ Файл .gitignore настроен для исключения конфиденциальных файлов"
else
    echo "❌ Файл .gitignore не найден"
fi

# Создаем .env файл если его нет
if [ ! -f ".env" ]; then
    echo ""
    echo "📝 Создание файла .env для хранения токенов..."
    cat > .env << EOL
# Figma MCP Configuration
# Заполните реальными значениями

# Figma Personal Access Token
# Получите токен в Figma: Profile > Settings > Security > Personal access tokens
FIGMA_ACCESS_TOKEN=your_figma_personal_access_token_here

# Figma API Key (альтернативное название для совместимости)
FIGMA_API_KEY=your_figma_personal_access_token_here
EOL
    echo "✅ Файл .env создан. Пожалуйста, заполните его реальными токенами."
else
    echo "✅ Файл .env уже существует"
fi

echo ""
echo "🎉 Настройка завершена!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Откройте настольное приложение Figma"
echo "2. Перейдите в Figma > Preferences"
echo "3. Включите 'Enable Dev Mode MCP Server'"
echo "4. Сгенерируйте персональный токен доступа в Profile > Settings > Security"
echo "5. Замените 'your_figma_personal_access_token_here' в файлах конфигурации на реальный токен"
echo "6. Настройте ваш MCP-клиент (Cursor/Claude Desktop) используя созданные конфигурации"
echo ""
echo "📖 Подробные инструкции смотрите в файле FIGMA_MCP_SETUP.md"
echo ""
echo "⚠️  ВАЖНО: Никогда не коммитьте файлы с реальными токенами в Git!"
