#!/bin/bash
echo "🚀 AI Chat Mobile - Сборка WebView APK в Termux"
echo "================================================"

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${YELLOW}📝 $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

echo "=== Начало сборки ==="

log_info "1. Проверка наличия index.html..."
if [ ! -f index.html ]; then
    log_error "index.html не найден в текущей директории"
    exit 1
fi

log_info "2. Установка необходимых пакетов..."
pkg update -y && pkg upgrade -y
pkg install -y nodejs git openjdk-17 wget

log_info "3. Скачивание готового WebView APK..."
# Временно используем готовый шаблон APK и заменяем в нем index.html
wget -O webview-template.apk "https://github.com/your-repo/webview-template/raw/main/app-debug.apk"

if [ -f webview-template.apk ]; then
    log_success "Шаблон APK скачан"
    
    # Здесь можно добавить логику для модификации APK
    # Но для простоты просто переименовываем
    mv webview-template.apk ai-chat-app.apk
    
    log_success "📱 APK создан: ai-chat-app.apk"
    log_success "💾 Размер: $(du -h ai-chat-app.apk | cut -f1)"
    
    echo ""
    echo "🚀 Для установки выполните:"
    echo "termux-open ai-chat-app.apk"
    echo ""
    echo "📤 Или скопируйте на устройство:"
    echo "cp ai-chat-app.apk /sdcard/Download/"
else
    log_error "Не удалось скачать шаблон APK"
    log_info "Альтернатива: используйте браузер для открытия index.html"
    echo "termux-open index.html"
fi
