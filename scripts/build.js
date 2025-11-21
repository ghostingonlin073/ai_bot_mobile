const fs = require('fs-extra');
const path = require('path');

console.log('🚀 Building AI Chat Mobile Application...');

// Очищаем и создаем папку www
fs.removeSync('www');
fs.ensureDirSync('www');
fs.ensureDirSync('www/icons');

// Создаем основной HTML файл
const htmlContent = `<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>AI Chat Mobile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/styles/github-dark.min.css">
    <link rel="manifest" href="manifest.json">
    <meta name="theme-color" content="#10a37f">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <style>
        /* ВАШ CSS КОД БУДЕТ ЗДЕСЬ */
        ${fs.readFileSync(path.join(__dirname, '../src/styles.css'), 'utf8')}
    </style>
</head>
<body>
    <div class="app-container" id="appContainer">
        ${fs.readFileSync(path.join(__dirname, '../src/index.html'), 'utf8')}
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.8.0/highlight.min.js"></script>
    <script>
        hljs.configure({languages: []});
        
        // ВАШ JAVASCRIPT КОД БУДЕТ ЗДЕСЬ
        ${fs.readFileSync(path.join(__dirname, '../src/app.js'), 'utf8')}
        
        // PWA Service Worker Registration
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', function() {
                navigator.serviceWorker.register('sw.js')
                    .then(function(registration) {
                        console.log('ServiceWorker registered with scope:', registration.scope);
                    })
                    .catch(function(error) {
                        console.log('ServiceWorker registration failed:', error);
                    });
            });
        }
        
        // Capacitor ready event
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof Capacitor !== 'undefined') {
                Capacitor.Plugins.SplashScreen.hide();
            }
        });
    </script>
</body>
</html>`;

fs.writeFileSync('www/index.html', htmlContent);

// Копируем остальные файлы
fs.copySync('src/icons', 'www/icons');
fs.writeFileSync('www/manifest.json', fs.readFileSync('src/manifest.json'));
fs.writeFileSync('www/sw.js', fs.readFileSync('src/sw.js'));

console.log('✅ Build completed!');
console.log('📁 Output directory: www/');
