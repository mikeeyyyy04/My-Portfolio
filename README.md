# Portfolio Website - Flutter Web

A modern, dark-themed portfolio website built with Flutter Web, featuring:
- Gradient purple background with animated star particles
- Interactive toggle switch
- Large typography with gradient text effects
- Animated tagline with typing dots
- Social media icon links
- Responsive design

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Chrome browser (for testing)

### Running the Project

1. Install dependencies:
```bash
flutter pub get
```

2. Run on web:
```bash
flutter run -d chrome
```

Or build for production:
```bash
flutter build web
```

### Quick Deployment

Use the provided deployment scripts for easy building:

**Windows (PowerShell):**
```powershell
.\deploy.ps1
```

**Windows (Command Prompt):**
```cmd
deploy.bat
```

**Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh
```

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

### GitHub Setup

To add this project to GitHub and deploy with GitHub Pages:

**Quick setup (PowerShell):**
```powershell
.\setup-github.ps1
```

**Or manually:**
```powershell
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

For complete GitHub setup and deployment instructions, see [GITHUB_SETUP.md](GITHUB_SETUP.md).

## Features

- **Dark Theme**: Beautiful purple gradient background
- **Animated Background**: Star particles scattered across the screen
- **Interactive Elements**: Toggle switch and buttons
- **Gradient Text**: Name displayed with gradient effect
- **Animated Tagline**: Typing dots animation
- **Social Media Links**: Footer with clickable social media icons

## Customization

- Update social media URLs in `lib/main.dart` in the `_buildFooter()` method
- Modify colors in the gradient and theme sections
- Replace the cat emoji with a custom icon/image
- Add resume download functionality to the Resume button
- Implement navigation for the Achievements button

