# Установка Node.js для работы с MCP Figma

## Для macOS

### Вариант 1: Homebrew (рекомендуется)

1. Установите Homebrew, если его нет:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Установите Node.js:
```bash
brew install node
```

3. Проверьте установку:
```bash
node --version
npm --version
```

### Вариант 2: Официальный установщик

1. Перейдите на https://nodejs.org/
2. Скачайте LTS версию для macOS
3. Запустите установщик и следуйте инструкциям
4. Перезапустите терминал
5. Проверьте установку:
```bash
node --version
npm --version
```

### Вариант 3: Node Version Manager (nvm)

1. Установите nvm:
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

2. Перезапустите терминал или выполните:
```bash
source ~/.zshrc
```

3. Установите последнюю LTS версию Node.js:
```bash
nvm install --lts
nvm use --lts
```

4. Проверьте установку:
```bash
node --version
npm --version
```

## После установки Node.js

1. Вернитесь в папку проекта:
```bash
cd /Users/akozlov/Documents/Tasker/Tasker
```

2. Запустите скрипт настройки MCP:
```bash
./setup_figma_mcp.sh
```

## Альтернативная установка MCP серверов

Если автоматический скрипт не работает, установите MCP серверы вручную:

```bash
# Установка MCP сервера для Figma
npm install -g figma-developer-mcp
```

## Проверка установки

После установки Node.js и MCP серверов проверьте:

```bash
# Проверка Node.js
node --version
npm --version

# Проверка MCP сервера
npx figma-developer-mcp --help
```

## Возможные проблемы

### Ошибка прав доступа при установке глобальных пакетов

Если получаете ошибки EACCES при установке глобальных пакетов:

```bash
# Настройте npm для использования другой папки для глобальных пакетов
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

# Добавьте в ~/.zshrc или ~/.bash_profile:
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

### Конфликты версий Node.js

Если у вас уже установлена другая версия Node.js:

```bash
# Используйте nvm для управления версиями
nvm list
nvm install 18  # или другую LTS версию
nvm use 18
```

## Следующие шаги

После успешной установки Node.js:

1. ✅ Запустите `./setup_figma_mcp.sh`
2. ✅ Следуйте инструкциям в `FIGMA_MCP_SETUP.md`
3. ✅ Настройте токены доступа Figma
4. ✅ Протестируйте интеграцию используя примеры из `FIGMA_MCP_EXAMPLES.md`

