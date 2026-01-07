# Deployment Guide

This guide explains how to build and deploy your Flutter web portfolio.

## Quick Start

### Windows (PowerShell)
```powershell
.\deploy.ps1
```

### Windows (Command Prompt)
```cmd
deploy.bat
```

### Linux/Mac
```bash
chmod +x deploy.sh
./deploy.sh
```

## Script Options

### PowerShell Script (`deploy.ps1`)

**Basic build:**
```powershell
.\deploy.ps1
```

**Clean and build:**
```powershell
.\deploy.ps1 -Clean
```

**Skip build (only install dependencies):**
```powershell
.\deploy.ps1 -SkipBuild
```

**With deployment target info:**
```powershell
.\deploy.ps1 -DeployTarget github
.\deploy.ps1 -DeployTarget netlify
.\deploy.ps1 -DeployTarget vercel
.\deploy.ps1 -DeployTarget firebase
```

### Shell Script (`deploy.sh`)

**Basic build:**
```bash
./deploy.sh
```

**Clean and build:**
```bash
./deploy.sh --clean
```

**Skip build:**
```bash
./deploy.sh --skip-build
```

**With deployment target:**
```bash
./deploy.sh --deploy=github
./deploy.sh --deploy=netlify
./deploy.sh --deploy=vercel
./deploy.sh --deploy=firebase
```

## Manual Build Steps

If you prefer to build manually:

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Build for web:**
   ```bash
   flutter build web --release
   ```

3. **Output location:**
   The built files will be in `build/web/`

## Deployment Options

### 1. GitHub Pages

1. Create a new repository on GitHub
2. Copy all files from `build/web/` to a `docs` folder in your repository
3. Go to repository Settings → Pages
4. Select `docs` folder as source
5. Your site will be available at `https://username.github.io/repository-name/`

**Alternative:** Use the `gh-pages` branch:
```bash
git checkout --orphan gh-pages
git rm -rf .
cp -r build/web/* .
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
```

### 2. Netlify

**Using Netlify CLI:**
```bash
npm install -g netlify-cli
netlify login
netlify deploy --prod --dir=build/web
```

**Using Netlify Dashboard:**
1. Go to [netlify.com](https://netlify.com)
2. Drag and drop the `build/web` folder
3. Your site will be live instantly!

### 3. Vercel

**Using Vercel CLI:**
```bash
npm install -g vercel
vercel --prod build/web
```

**Using Vercel Dashboard:**
1. Go to [vercel.com](https://vercel.com)
2. Import your Git repository
3. Set build command: `flutter build web --release`
4. Set output directory: `build/web`
5. Deploy!

### 4. Firebase Hosting

1. **Install Firebase CLI:**
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase:**
   ```bash
   firebase login
   ```

3. **Initialize Firebase in your project:**
   ```bash
   firebase init hosting
   ```
   - Select your Firebase project
   - Set public directory to: `build/web`
   - Configure as single-page app: `Yes`
   - Set up automatic builds: `No` (or `Yes` if using CI/CD)

4. **Deploy:**
   ```bash
   flutter build web --release
   firebase deploy --only hosting
   ```

### 5. Other Static Hosting Services

You can deploy the `build/web` folder to any static hosting service:
- **AWS S3 + CloudFront**
- **Azure Static Web Apps**
- **Cloudflare Pages**
- **Surge.sh**
- **Any web server** (just copy `build/web` contents to your web root)

## Testing Locally

Before deploying, test your build locally:

```bash
flutter run -d chrome
```

Or serve the built files:
```bash
cd build/web
python -m http.server 8000
# Or with Node.js:
npx serve
```

Then open `http://localhost:8000` in your browser.

## Troubleshooting

### Build Errors

If you encounter build errors:

1. **Clean the build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release
   ```

2. **Check Flutter version:**
   ```bash
   flutter --version
   ```
   Ensure you're using Flutter 3.0.0 or higher.

3. **Update dependencies:**
   ```bash
   flutter pub upgrade
   ```

### Deployment Issues

- **404 errors on refresh:** Ensure your hosting service is configured for single-page apps (SPA mode)
- **Assets not loading:** Check that all assets are included in `pubspec.yaml`
- **CORS issues:** Configure CORS headers on your hosting service if accessing external APIs

## Continuous Deployment (CI/CD)

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Flutter Web

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.0.0'
      - run: flutter pub get
      - run: flutter build web --release
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

### Netlify Build

Create `netlify.toml`:

```toml
[build]
  command = "flutter build web --release"
  publish = "build/web"

[[plugins]]
  package = "@netlify/plugin-lighthouse"
```

## Notes

- The build output is optimized for production
- All assets are bundled and minified
- The app works offline (service worker included)
- Make sure to test on different browsers before deploying

