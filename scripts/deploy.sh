#!/bin/bash

echo "🚀 Starting AI Chat Mobile deployment..."

# Проверяем Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Проверяем npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "📦 Installing dependencies..."
npm install

echo "🔨 Building web application..."
npm run build

echo "🤖 Setting up Capacitor Android..."
npx cap init "AI Chat Mobile" com.aichat.mobile --web-dir www
npx cap add android

echo "🏗️ Building Android APK..."
cd android
chmod +x gradlew
./gradlew assembleDebug

echo "✅ Build completed!"
echo "📱 APK location: android/app/build/outputs/apk/debug/app-debug.apk"

# Копируем APK в корневую папку
cd ..
cp android/app/build/outputs/apk/debug/app-debug.apk ./ai-chat-mobile.apk

echo "🎉 APK ready: ai-chat-mobile.apk"
echo "📲 Install with: adb install ai-chat-mobile.apk"
