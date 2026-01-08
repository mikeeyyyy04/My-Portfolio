# GitHub Setup Guide

This guide will help you add your Flutter portfolio project to GitHub and deploy it using GitHub Pages.

## Step 1: Create a GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **+** icon in the top right corner
3. Select **New repository**
4. Fill in the details:
   - **Repository name**: `portfolio` (or any name you prefer)
   - **Description**: "My portfolio website built with Flutter Web"
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click **Create repository**

## Step 2: Initialize Git in Your Project

Open PowerShell or Command Prompt in your project directory and run:

```powershell
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Flutter portfolio website"

# Add your GitHub repository as remote (replace USERNAME and REPO_NAME)
git remote add origin https://github.com/USERNAME/REPO_NAME.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

**Replace `USERNAME` and `REPO_NAME` with your actual GitHub username and repository name.**

For example, if your username is `johndoe` and repository is `portfolio`:
```powershell
git remote add origin https://github.com/johndoe/portfolio.git
```

## Step 3: Verify Upload

1. Go to your GitHub repository page
2. You should see all your project files
3. Verify that `lib/main.dart`, `pubspec.yaml`, and other files are present

## Step 4: Deploy to GitHub Pages

### Option A: Using GitHub Actions (Recommended)

1. **Create the workflow file:**
   - In your repository, click **Add file** → **Create new file**
   - Name it: `.github/workflows/deploy.yml`
   - Copy and paste the content below:

```yaml
name: Deploy Flutter Web to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.0.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build web
        run: flutter build web --release --base-href "/REPO_NAME/"
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

**Important:** Replace `REPO_NAME` with your actual repository name in the build command.

2. **Enable GitHub Pages:**
   - Go to your repository **Settings**
   - Click **Pages** in the left sidebar
   - Under **Source**, select **GitHub Actions**
   - Save

3. **Trigger deployment:**
   - Make a small change and commit, OR
   - Go to **Actions** tab → Select the workflow → Click **Run workflow**

### Option B: Manual Deployment (Simple)

1. **Build your website:**
   ```powershell
   flutter build web --release --base-href "/REPO_NAME/"
   ```
   (Replace `REPO_NAME` with your repository name)

2. **Create a `gh-pages` branch:**
   ```powershell
   git checkout --orphan gh-pages
   git rm -rf .
   ```

3. **Copy build files:**
   ```powershell
   # Copy all files from build/web to root
   Copy-Item -Path "build\web\*" -Destination "." -Recurse -Force
   ```

4. **Commit and push:**
   ```powershell
   git add .
   git commit -m "Deploy to GitHub Pages"
   git push origin gh-pages
   ```

5. **Enable GitHub Pages:**
   - Go to repository **Settings** → **Pages**
   - Select **gh-pages** branch as source
   - Your site will be at: `https://USERNAME.github.io/REPO_NAME/`

## Step 5: Update Base URL (Important!)

If your repository name is not `portfolio`, you need to update the base href:

**In the GitHub Actions workflow**, make sure the build command includes:
```yaml
run: flutter build web --release --base-href "/YOUR_REPO_NAME/"
```

For example, if your repo is `my-portfolio`:
```yaml
run: flutter build web --release --base-href "/my-portfolio/"
```

## Quick Commands Reference

### Initial Setup (One-time)
```powershell
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

### Regular Updates
```powershell
git add .
git commit -m "Update portfolio"
git push
```

### Build and Deploy Locally
```powershell
.\deploy.ps1
```

## Troubleshooting

### Authentication Issues

If you get authentication errors when pushing:

**Option 1: Use Personal Access Token**
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Generate a new token with `repo` permissions
3. Use token as password when pushing

**Option 2: Use GitHub CLI**
```powershell
# Install GitHub CLI
winget install GitHub.cli

# Login
gh auth login

# Then push normally
git push
```

### GitHub Pages Not Working

1. Check that GitHub Actions workflow completed successfully
2. Verify the base-href matches your repository name
3. Wait a few minutes for GitHub Pages to update
4. Check repository Settings → Pages for any errors

### Files Not Showing

- Make sure `.gitignore` isn't excluding important files
- Verify all files are committed: `git status`
- Check that `build/` folder is in `.gitignore` (it should be)

## Next Steps

After deployment:
- Your site will be live at: `https://USERNAME.github.io/REPO_NAME/`
- Share the link with others!
- Update your portfolio content and push changes
- GitHub Actions will automatically rebuild and redeploy

## Custom Domain (Optional)

To use a custom domain:
1. Add a `CNAME` file in `build/web/` with your domain
2. Update the GitHub Actions workflow to include the CNAME file
3. Configure DNS settings with your domain provider




