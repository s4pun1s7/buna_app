#!/bin/bash

# Build and deploy Flutter web app to GitHub Pages

echo "Building Flutter web app for GitHub Pages..."

# Clean previous build
echo "Cleaning previous build..."
rm -rf build/web

# Build for web with GitHub Pages base href
echo "Building web app..."
flutter build web --release --base-href /buna_app/

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📁 Build output is in: build/web"
    echo "🌐 The app will be available at: https://s4pun1s7.github.io/buna_app/"
    echo ""
    echo "To deploy:"
    echo "1. Commit and push your changes to the main branch"
    echo "2. The GitHub Actions workflow will automatically deploy to GitHub Pages"
    echo "3. Enable GitHub Pages in your repository settings if not already done"
else
    echo "❌ Build failed!"
    exit 1
fi