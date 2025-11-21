#!/bin/bash
echo "🚀 AI Chat Mobile - Сборка APK в Termux"
echo "========================================"

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${YELLOW}📝 $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "=== Начало сборки ==="

log_info "1. Обновление пакетов..."
pkg update -y && pkg upgrade -y

log_info "2. Установка необходимых пакетов..."
pkg install -y nodejs git openjdk-17

log_info "3. Проверка версии Java..."
java -version
javac -version

log_info "4. Установка Cordova..."
npm install -g cordova

log_info "5. Создание Cordova проекта..."
cordova create ai-chat-app com.aichat.mobile "AI Chat Mobile"
cd ai-chat-app

log_info "6. Копирование вашего index.html..."
if [ -f ../index.html ]; then
    cp ../index.html www/
    log_success "index.html скопирован в www/"
else
    log_error "index.html не найден в родительской директории"
    exit 1
fi

log_info "7. Добавление Android платформы..."
cordova platform add android@11.0.0

log_info "8. Сборка APK..."
cordova build android

if [ -f "platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
    log_success "Сборка завершена успешно!"
    log_success "📱 APK: platforms/android/app/build/outputs/apk/debug/app-debug.apk"
    
    # Показываем размер файла
    APK_SIZE=$(du -h platforms/android/app/build/outputs/apk/debug/app-debug.apk | cut -f1)
    log_success "💾 Размер APK: $APK_SIZE"
    
    # Копируем APK для удобства
    cp platforms/android/app/build/outputs/apk/debug/app-debug.apk ../ai-chat-app.apk
    log_success "📂 Копия: ../ai-chat-app.apk"
    
    echo ""
    echo "🚀 Для установки выполните:"
    echo "termux-open ../ai-chat-app.apk"
    echo ""
    echo "📤 Или скопируйте на устройство:"
    echo "cp ../ai-chat-app.apk /sdcard/Download/"
else
    log_error "APK не найден!"
    exit 1
fi
