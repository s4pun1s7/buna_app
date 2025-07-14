#!/bin/bash

# GitHub Pages Deployment Configuration Check

echo "🔍 Checking GitHub Pages deployment configuration..."
echo ""

# Check if required files exist
check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1 - Found"
    else
        echo "❌ $1 - Missing"
        return 1
    fi
}

# Check if required directories exist
check_directory() {
    if [ -d "$1" ]; then
        echo "✅ $1/ - Found"
    else
        echo "❌ $1/ - Missing"
        return 1
    fi
}

echo "📁 Checking required files and directories:"
check_file ".github/workflows/deploy-to-pages.yml"
check_file "web/index.html"
check_file "web/manifest.json"
check_file "pubspec.yaml"
check_file "deploy.sh"
check_file "GITHUB_PAGES_DEPLOYMENT.md"

echo ""
echo "📂 Checking directories:"
check_directory "web"
check_directory "lib"
check_directory ".github/workflows"

echo ""
echo "⚙️  Checking web configuration:"

# Check if base href is configured for GitHub Pages
if grep -q 'base href="\$FLUTTER_BASE_HREF"' web/index.html; then
    echo "✅ Base href placeholder found in index.html"
else
    echo "❌ Base href not properly configured"
fi

# Check if Firebase is configured
if grep -q "firebase" web/index.html; then
    echo "✅ Firebase configuration found"
else
    echo "❌ Firebase configuration not found"
fi

# Check if PWA manifest is configured
if grep -q "manifest.json" web/index.html; then
    echo "✅ PWA manifest linked"
else
    echo "❌ PWA manifest not linked"
fi

echo ""
echo "🔧 Checking Flutter configuration:"

# Check pubspec.yaml for web dependencies
if grep -q "flutter:" pubspec.yaml; then
    echo "✅ Flutter configuration found"
else
    echo "❌ Flutter configuration not found"
fi

echo ""
echo "🚀 GitHub Pages deployment setup:"
echo "1. Enable GitHub Pages in repository settings"
echo "2. Select 'GitHub Actions' as source"
echo "3. Push to main branch to trigger deployment"
echo "4. App will be available at: https://s4pun1s7.github.io/buna_app/"
echo ""
echo "Run ./deploy.sh to build locally or push to main for automatic deployment."