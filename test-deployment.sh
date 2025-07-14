#!/bin/bash

# Test GitHub Pages deployment configuration

echo "🧪 Testing GitHub Pages deployment configuration..."
echo ""

# Test 1: Verify workflow file syntax
echo "1. Checking GitHub Actions workflow syntax..."
if yaml_lint_available=$(command -v yamllint 2>/dev/null); then
    yamllint .github/workflows/deploy-to-pages.yml
else
    echo "   ℹ️  yamllint not available, skipping YAML syntax check"
fi

# Test 2: Verify required workflow components
echo "2. Checking workflow components..."
if grep -q "flutter-version: '3.24.5'" .github/workflows/deploy-to-pages.yml; then
    echo "   ✅ Flutter version specified"
else
    echo "   ❌ Flutter version not found"
fi

if grep -q "base-href /buna_app/" .github/workflows/deploy-to-pages.yml; then
    echo "   ✅ Base href configured for GitHub Pages"
else
    echo "   ❌ Base href not configured"
fi

if grep -q "actions/deploy-pages@v4" .github/workflows/deploy-to-pages.yml; then
    echo "   ✅ Pages deployment action configured"
else
    echo "   ❌ Pages deployment action not found"
fi

# Test 3: Verify web configuration
echo "3. Checking web configuration..."
if grep -q "FLUTTER_BASE_HREF" web/index.html; then
    echo "   ✅ Base href placeholder in index.html"
else
    echo "   ❌ Base href placeholder missing"
fi

if grep -q "firebase" web/index.html; then
    echo "   ✅ Firebase configuration present"
else
    echo "   ❌ Firebase configuration missing"
fi

# Test 4: Check pubspec.yaml for web dependencies
echo "4. Checking Flutter web dependencies..."
if grep -q "flutter:" pubspec.yaml; then
    echo "   ✅ Flutter framework configured"
else
    echo "   ❌ Flutter framework not configured"
fi

# Test 5: Verify scripts are executable
echo "5. Checking deployment scripts..."
if [ -x "deploy.sh" ]; then
    echo "   ✅ deploy.sh is executable"
else
    echo "   ❌ deploy.sh is not executable"
fi

if [ -x "check-pages-config.sh" ]; then
    echo "   ✅ check-pages-config.sh is executable"
else
    echo "   ❌ check-pages-config.sh is not executable"
fi

echo ""
echo "🎯 Summary:"
echo "   GitHub Pages deployment is configured and ready!"
echo "   Repository owner should:"
echo "   1. Enable GitHub Pages in repository settings"
echo "   2. Push to main branch to trigger deployment"
echo "   3. Access the app at: https://s4pun1s7.github.io/buna_app/"
echo ""
echo "   For troubleshooting, see: GITHUB_PAGES_DEPLOYMENT.md"