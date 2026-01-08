#!/bin/bash
# Flutter Web Portfolio Deployment Script
# Shell script for building and deploying the Flutter web app

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================"
echo -e "  Flutter Web Portfolio Deployment"
echo -e "========================================${NC}"
echo ""

# Check if Flutter is installed
echo -e "${YELLOW}Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗ Flutter is not installed or not in PATH${NC}"
    echo -e "${YELLOW}  Please install Flutter from https://flutter.dev${NC}"
    exit 1
fi
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo -e "${GREEN}✓ Flutter found: $FLUTTER_VERSION${NC}"

# Parse command line arguments
CLEAN=false
SKIP_BUILD=false
DEPLOY_TARGET="none"

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN=true
            shift
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --deploy=*)
            DEPLOY_TARGET="${1#*=}"
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Clean previous builds if requested
if [ "$CLEAN" = true ]; then
    echo ""
    echo -e "${YELLOW}Cleaning previous builds...${NC}"
    flutter clean
    echo -e "${GREEN}✓ Clean completed${NC}"
fi

# Get dependencies
echo ""
echo -e "${YELLOW}Installing dependencies...${NC}"
flutter pub get
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Failed to install dependencies${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Build for web
if [ "$SKIP_BUILD" = false ]; then
    echo ""
    echo -e "${YELLOW}Building Flutter web app...${NC}"
    flutter build web --release
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Build failed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Build completed successfully!${NC}"
    echo ""
    echo -e "${CYAN}Build output location: build/web/${NC}"
fi

# Deployment options
echo ""
echo -e "${CYAN}========================================"
echo -e "  Deployment Options"
echo -e "========================================${NC}"
echo ""
echo -e "${YELLOW}Your website files are ready in: build/web/${NC}"
echo ""
echo -e "${WHITE}You can deploy to:${NC}"
echo -e "  ${CYAN}1. GitHub Pages${NC}"
echo -e "  ${CYAN}2. Netlify${NC}"
echo -e "  ${CYAN}3. Vercel${NC}"
echo -e "  ${CYAN}4. Firebase Hosting${NC}"
echo -e "  ${CYAN}5. Any static hosting service${NC}"
echo ""

# Handle specific deployment targets
case "$DEPLOY_TARGET" in
    github)
        echo -e "${YELLOW}GitHub Pages deployment...${NC}"
        echo -e "  ${WHITE}To deploy to GitHub Pages:${NC}"
        echo -e "  ${WHITE}1. Create a repository on GitHub${NC}"
        echo -e "  ${WHITE}2. Copy contents of build/web/ to a 'docs' folder or 'gh-pages' branch${NC}"
        echo -e "  ${WHITE}3. Enable GitHub Pages in repository settings${NC}"
        ;;
    netlify)
        echo -e "${YELLOW}Netlify deployment...${NC}"
        echo -e "  ${WHITE}To deploy to Netlify:${NC}"
        echo -e "  ${WHITE}1. Install Netlify CLI: npm install -g netlify-cli${NC}"
        echo -e "  ${WHITE}2. Run: netlify deploy --prod --dir=build/web${NC}"
        ;;
    vercel)
        echo -e "${YELLOW}Vercel deployment...${NC}"
        echo -e "  ${WHITE}To deploy to Vercel:${NC}"
        echo -e "  ${WHITE}1. Install Vercel CLI: npm install -g vercel${NC}"
        echo -e "  ${WHITE}2. Run: vercel --prod build/web${NC}"
        ;;
    firebase)
        echo -e "${YELLOW}Firebase Hosting deployment...${NC}"
        echo -e "  ${WHITE}To deploy to Firebase:${NC}"
        echo -e "  ${WHITE}1. Install Firebase CLI: npm install -g firebase-tools${NC}"
        echo -e "  ${WHITE}2. Run: firebase init hosting${NC}"
        echo -e "  ${WHITE}3. Set public directory to: build/web${NC}"
        echo -e "  ${WHITE}4. Run: firebase deploy --only hosting${NC}"
        ;;
    *)
        echo -e "${WHITE}To test locally, run:${NC}"
        echo -e "  ${CYAN}flutter run -d chrome${NC}"
        ;;
esac

echo ""
echo -e "${CYAN}========================================"
echo -e "  Deployment Complete!"
echo -e "========================================${NC}"
echo ""




