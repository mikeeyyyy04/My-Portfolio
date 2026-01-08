# GitHub Setup Script
# This script helps you initialize git and connect to GitHub

param(
    [string]$GitHubUsername = "",
    [string]$RepositoryName = ""
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  GitHub Setup for Flutter Portfolio" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if git is installed
Write-Host "Checking Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>&1
    Write-Host "✓ Git found: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Git is not installed" -ForegroundColor Red
    Write-Host "  Please install Git from https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# Check if already a git repository
if (Test-Path ".git") {
    Write-Host ""
    Write-Host "⚠ Git repository already initialized" -ForegroundColor Yellow
    $continue = Read-Host "Do you want to continue? (y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 0
    }
} else {
    Write-Host ""
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host "✓ Git repository initialized" -ForegroundColor Green
}

# Get GitHub details if not provided
if ([string]::IsNullOrEmpty($GitHubUsername)) {
    Write-Host ""
    $GitHubUsername = Read-Host "Enter your GitHub username"
}

if ([string]::IsNullOrEmpty($RepositoryName)) {
    Write-Host ""
    $RepositoryName = Read-Host "Enter your GitHub repository name"
}

# Check if remote already exists
$remoteExists = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "⚠ Remote 'origin' already exists: $remoteExists" -ForegroundColor Yellow
    $replace = Read-Host "Do you want to replace it? (y/n)"
    if ($replace -eq "y" -or $replace -eq "Y") {
        git remote remove origin
    } else {
        Write-Host "Keeping existing remote. Skipping remote setup." -ForegroundColor Yellow
        exit 0
    }
}

# Add remote
$remoteUrl = "https://github.com/$GitHubUsername/$RepositoryName.git"
Write-Host ""
Write-Host "Adding remote repository..." -ForegroundColor Yellow
Write-Host "  URL: $remoteUrl" -ForegroundColor Gray
git remote add origin $remoteUrl
Write-Host "✓ Remote added" -ForegroundColor Green

# Stage all files
Write-Host ""
Write-Host "Staging files..." -ForegroundColor Yellow
git add .
Write-Host "✓ Files staged" -ForegroundColor Green

# Check if there are changes to commit
$status = git status --porcelain
if ([string]::IsNullOrEmpty($status)) {
    Write-Host ""
    Write-Host "⚠ No changes to commit" -ForegroundColor Yellow
    Write-Host "  Repository is up to date" -ForegroundColor Gray
} else {
    Write-Host ""
    Write-Host "Creating initial commit..." -ForegroundColor Yellow
    git commit -m "Initial commit: Flutter portfolio website"
    Write-Host "✓ Initial commit created" -ForegroundColor Green
}

# Set branch to main
Write-Host ""
Write-Host "Setting branch to 'main'..." -ForegroundColor Yellow
git branch -M main
Write-Host "✓ Branch set to 'main'" -ForegroundColor Green

# Instructions for pushing
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Make sure you've created the repository on GitHub:" -ForegroundColor White
Write-Host "   https://github.com/new" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Push your code to GitHub:" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "   If prompted for credentials:" -ForegroundColor Yellow
Write-Host "   - Username: $GitHubUsername" -ForegroundColor Gray
Write-Host "   - Password: Use a Personal Access Token (not your GitHub password)" -ForegroundColor Gray
Write-Host "   - Get token from: https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host ""
Write-Host "3. After pushing, set up GitHub Pages:" -ForegroundColor White
Write-Host "   See GITHUB_SETUP.md for detailed instructions" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""




