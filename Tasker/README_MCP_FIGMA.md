# 🎨 MCP интеграция с Figma для проекта Tasker

Этот проект настроен для работы с Model Context Protocol (MCP) для интеграции с Figma. MCP позволяет автоматически генерировать SwiftUI код на основе дизайна из Figma.

## 📁 Структура файлов MCP

```
Tasker/
├── mcp.json                     # Конфигурация MCP для Cursor
├── claude_desktop_config.json   # Конфигурация MCP для Claude Desktop  
├── .env.example                 # Пример файла с переменными окружения
├── .gitignore                   # Исключает конфиденциальные файлы
├── setup_figma_mcp.sh          # Скрипт автоматической настройки
├── INSTALL_NODEJS.md           # Инструкции по установке Node.js
├── FIGMA_MCP_SETUP.md          # Подробные инструкции по настройке
├── FIGMA_MCP_EXAMPLES.md       # Примеры использования
└── README_MCP_FIGMA.md         # Этот файл
```

## 🚀 Быстрый старт

### 1. Предварительные требования

- ✅ **Подписка Figma**: Dev или Full seat (Professional/Organization/Enterprise)
- ✅ **Настольное приложение Figma** (не веб-версия)
- ✅ **Node.js** (см. `INSTALL_NODEJS.md` если не установлен)
- ✅ **MCP-клиент** (Cursor или Claude Desktop)

### 2. Автоматическая настройка

```bash
# В папке проекта Tasker
./setup_figma_mcp.sh
```

### 3. Ручная настройка (если автоматическая не работает)

1. **Установите MCP сервер:**
```bash
npm install -g figma-developer-mcp
```

2. **Включите MCP в Figma:**
   - Figma → Preferences → Enable Dev Mode MCP Server

3. **Получите токен доступа:**
   - Profile → Settings → Security → Personal access tokens

4. **Настройте MCP-клиент:**
   - Для Cursor: используйте `mcp.json`
   - Для Claude Desktop: используйте `claude_desktop_config.json`

## 🔧 Конфигурация

### Для Cursor

Скопируйте содержимое `mcp.json` в настройки Cursor и замените токен:

```json
{
  "mcpServers": {
    "figma-developer-mcp": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp", "--stdio"],
      "env": {
        "FIGMA_API_KEY": "YOUR_ACTUAL_TOKEN_HERE"
      }
    }
  }
}
```

### Для Claude Desktop

Скопируйте содержимое `claude_desktop_config.json` в настройки Claude:

```json
{
  "mcpServers": {
    "figma-developer-mcp": {
      "command": "npx",
      "args": ["-y", "figma-developer-mcp", "--stdio"],
      "env": {
        "FIGMA_API_KEY": "YOUR_ACTUAL_TOKEN_HERE"
      }
    }
  }
}
```

## 💡 Примеры использования

### Базовые команды

```
Сгенерируй выбранный элемент в Figma как SwiftUI View для проекта Tasker
```

```
Создай новый TaskRow компонент на основе дизайна из Figma
```

```
Обнови цветовую схему проекта на основе палитры из Figma
```

### Специфичные для проекта

```
Создай новый экран для UserStories следуя архитектуре проекта (View + ViewModel + Assembly)
```

```
Интегрируй новый компонент с TaskService и SwiftData моделями
```

Больше примеров в `FIGMA_MCP_EXAMPLES.md`

## 🏗️ Архитектурная интеграция

MCP настроен для работы с архитектурой проекта Tasker:

- **🏛️ Clean Architecture**: ExternalInterfacesLayer → GatewayLayer → UserStories
- **💉 Dependency Injection**: MokayDI для управления зависимостями
- **🗂️ MVVM Pattern**: View + ViewModel для каждого экрана
- **📱 SwiftUI + SwiftData**: Современный стек разработки iOS

## 🔒 Безопасность

**⚠️ ВАЖНО**: Файлы с токенами исключены из Git:

```gitignore
mcp.json
claude_desktop_config.json  
.env
*.env
figma_tokens.json
```

**Никогда не коммитьте файлы с реальными токенами!**

## 🧪 Тестирование

### Проверка подключения

```bash
# Проверка токена
curl -H "X-Figma-Token: YOUR_TOKEN" https://api.figma.com/v1/me

# Проверка MCP сервера
npx figma-developer-mcp --help
```

### Тест интеграции

1. Откройте файл в Figma
2. Выберите любой элемент
3. В MCP-клиенте: "Покажи информацию о выбранном элементе"

## 📚 Дополнительная документация

- 📖 **Подробная настройка**: `FIGMA_MCP_SETUP.md`
- 💻 **Установка Node.js**: `INSTALL_NODEJS.md`  
- 🎯 **Примеры команд**: `FIGMA_MCP_EXAMPLES.md`

## 🐛 Устранение проблем

### Частые ошибки

| Ошибка | Решение |
|--------|---------|
| "No selection in Figma" | Выберите элемент в Figma перед командой |
| "Invalid token" | Проверьте токен доступа в настройках |
| "Server not running" | Включите Dev Mode MCP Server в Figma |
| "Node.js not found" | Установите Node.js (см. `INSTALL_NODEJS.md`) |

### Логи и диагностика

Проверьте логи MCP-клиента для диагностики проблем подключения.

## 🤝 Поддержка

При возникновении проблем:

1. 📋 Проверьте все файлы документации
2. 🔍 Убедитесь в правильности токенов
3. 🖥️ Используйте настольное приложение Figma
4. 📱 Проверьте права доступа в команде Figma

---

**Готово! 🎉** Теперь вы можете использовать MCP для автоматической генерации SwiftUI кода из дизайна Figma прямо в проекте Tasker.
