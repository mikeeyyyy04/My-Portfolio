@echo off
REM GitHub Setup Script (Batch version)
REM This script helps you initialize git and connect to GitHub

echo ========================================
echo   GitHub Setup for Flutter Portfolio
echo ========================================
echo.

REM Check if git is installed
echo Checking Git installation...
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed
    echo Please install Git from https://git-scm.com/download/win
    pause
    exit /b 1
)
echo [OK] Git found
echo.

REM Check if already a git repository
if exist ".git" (
    echo [WARNING] Git repository already initialized
    echo.
) else (
    echo Initializing Git repository...
    call git init
    echo [OK] Git repository initialized
    echo.
)

REM Get GitHub details
set /p GITHUB_USERNAME="Enter your GitHub username: "
set /p REPO_NAME="Enter your GitHub repository name: "

REM Check if remote already exists
git remote get-url origin >nul 2>&1
if not errorlevel 1 (
    echo.
    echo [WARNING] Remote 'origin' already exists
    set /p REPLACE="Do you want to replace it? (y/n): "
    if /i "%REPLACE%"=="y" (
        git remote remove origin
    ) else (
        echo Keeping existing remote. Skipping remote setup.
        pause
        exit /b 0
    )
)

REM Add remote
echo.
echo Adding remote repository...
set REMOTE_URL=https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
echo   URL: %REMOTE_URL%
call git remote add origin %REMOTE_URL%
echo [OK] Remote added
echo.

REM Stage all files
echo Staging files...
call git add .
echo [OK] Files staged
echo.

REM Create initial commit
echo Creating initial commit...
call git commit -m "Initial commit: Flutter portfolio website"
if errorlevel 1 (
    echo [WARNING] No changes to commit or commit failed
) else (
    echo [OK] Initial commit created
)
echo.

REM Set branch to main
echo Setting branch to 'main'...
call git branch -M main
echo [OK] Branch set to 'main'
echo.

REM Instructions
echo ========================================
echo   Next Steps
echo ========================================
echo.
echo 1. Make sure you've created the repository on GitHub:
echo    https://github.com/new
echo.
echo 2. Push your code to GitHub:
echo    git push -u origin main
echo.
echo    If prompted for credentials:
echo    - Username: %GITHUB_USERNAME%
echo    - Password: Use a Personal Access Token (not your GitHub password)
echo    - Get token from: https://github.com/settings/tokens
echo.
echo 3. After pushing, set up GitHub Pages:
echo    See GITHUB_SETUP.md for detailed instructions
echo.
echo ========================================
echo.
pause




