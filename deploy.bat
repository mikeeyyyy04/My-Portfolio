@echo off
REM Flutter Web Portfolio Deployment Script
REM Batch file for building the Flutter web app

echo ========================================
echo   Flutter Web Portfolio Deployment
echo ========================================
echo.

REM Check if Flutter is installed
echo Checking Flutter installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev
    pause
    exit /b 1
)
echo [OK] Flutter found
echo.

REM Get dependencies
echo Installing dependencies...
call flutter pub get
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [OK] Dependencies installed
echo.

REM Build for web
echo Building Flutter web app...
call flutter build web --release
if errorlevel 1 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)
echo [OK] Build completed successfully!
echo.

echo ========================================
echo   Deployment Options
echo ========================================
echo.
echo Your website files are ready in: build\web\
echo.
echo You can deploy to:
echo   1. GitHub Pages
echo   2. Netlify
echo   3. Vercel
echo   4. Firebase Hosting
echo   5. Any static hosting service
echo.
echo To test locally, run:
echo   flutter run -d chrome
echo.
echo ========================================
echo   Deployment Complete!
echo ========================================
echo.
pause

