# Flutter Web Portfolio Deployment Script
# PowerShell script for building and deploying the Flutter web app

param(
    [switch]$Clean,
    [switch]$SkipBuild,
    [string]$DeployTarget = "none"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Flutter Web Portfolio Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "✓ Flutter found: $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host "  Please install Flutter from https://flutter.dev" -ForegroundColor Yellow
    exit 1
}

# Clean previous builds if requested
if ($Clean) {
    Write-Host ""
    Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
    flutter clean
    Write-Host "✓ Clean completed" -ForegroundColor Green
}

# Get dependencies
Write-Host ""
Write-Host "Installing dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to install dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependencies installed" -ForegroundColor Green

# Build for web
if (-not $SkipBuild) {
    Write-Host ""
    Write-Host "Building Flutter web app..." -ForegroundColor Yellow
    flutter build web --release
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Build failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Build completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Build output location: build\web\" -ForegroundColor Cyan
}

# Deployment options
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Options" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your website files are ready in: build\web\" -ForegroundColor Yellow
Write-Host ""
Write-Host "You can deploy to:" -ForegroundColor White
Write-Host "  1. GitHub Pages" -ForegroundColor Cyan
Write-Host "  2. Netlify" -ForegroundColor Cyan
Write-Host "  3. Vercel" -ForegroundColor Cyan
Write-Host "  4. Firebase Hosting" -ForegroundColor Cyan
Write-Host "  5. Any static hosting service" -ForegroundColor Cyan
Write-Host ""

# Handle specific deployment targets
switch ($DeployTarget.ToLower()) {
    "github" {
        Write-Host "GitHub Pages deployment..." -ForegroundColor Yellow
        Write-Host "  To deploy to GitHub Pages:" -ForegroundColor White
        Write-Host "  1. Create a repository on GitHub" -ForegroundColor Gray
        Write-Host "  2. Copy contents of build\web\ to a 'docs' folder or 'gh-pages' branch" -ForegroundColor Gray
        Write-Host "  3. Enable GitHub Pages in repository settings" -ForegroundColor Gray
    }
    "netlify" {
        Write-Host "Netlify deployment..." -ForegroundColor Yellow
        Write-Host "  To deploy to Netlify:" -ForegroundColor White
        Write-Host "  1. Install Netlify CLI: npm install -g netlify-cli" -ForegroundColor Gray
        Write-Host "  2. Run: netlify deploy --prod --dir=build\web" -ForegroundColor Gray
    }
    "vercel" {
        Write-Host "Vercel deployment..." -ForegroundColor Yellow
        Write-Host "  To deploy to Vercel:" -ForegroundColor White
        Write-Host "  1. Install Vercel CLI: npm install -g vercel" -ForegroundColor Gray
        Write-Host "  2. Run: vercel --prod build\web" -ForegroundColor Gray
    }
    "firebase" {
        Write-Host "Firebase Hosting deployment..." -ForegroundColor Yellow
        Write-Host "  To deploy to Firebase:" -ForegroundColor White
        Write-Host "  1. Install Firebase CLI: npm install -g firebase-tools" -ForegroundColor Gray
        Write-Host "  2. Run: firebase init hosting" -ForegroundColor Gray
        Write-Host "  3. Set public directory to: build\web" -ForegroundColor Gray
        Write-Host "  4. Run: firebase deploy --only hosting" -ForegroundColor Gray
    }
    default {
        Write-Host "To test locally, run:" -ForegroundColor White
        Write-Host "  flutter run -d chrome" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

