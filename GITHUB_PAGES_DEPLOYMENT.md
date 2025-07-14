# GitHub Pages Deployment Guide

This guide explains how to deploy the Buna Festival App to GitHub Pages for public web access.

## 🚀 Automatic Deployment

The repository is configured for automatic deployment to GitHub Pages using GitHub Actions.

### Setup Steps

1. **Enable GitHub Pages** in your repository settings:
   - Go to Settings → Pages
   - Select "GitHub Actions" as the source
   - Save the settings

2. **Push to main branch**:
   ```bash
   git push origin main
   ```

3. **Monitor deployment**:
   - Check the "Actions" tab in your repository
   - The workflow will automatically build and deploy your app

### Live URL

Once deployed, your app will be available at:
**https://s4pun1s7.github.io/buna_app/**

## 🔧 Manual Deployment

If you prefer to deploy manually, use the provided script:

```bash
# Make sure you have Flutter installed
flutter --version

# Run the deployment script
./deploy.sh
```

## 📝 Configuration Details

### GitHub Actions Workflow

The deployment is handled by `.github/workflows/deploy-to-pages.yml`:

- **Triggers**: Push to main branch, pull requests, manual dispatch
- **Flutter Version**: 3.24.5 (stable)
- **Build Command**: `flutter build web --release --base-href /buna_app/`
- **Deployment**: Automatic to GitHub Pages

### Web Configuration

The web app is configured with:

- **Base href**: `/buna_app/` (for GitHub Pages subdirectory)
- **Firebase integration**: Pre-configured for production
- **PWA support**: Service worker and manifest ready
- **Responsive design**: Optimized for all devices

## 🐛 Troubleshooting

### Common Issues

1. **Build fails**:
   - Check Flutter version compatibility
   - Ensure all dependencies are properly installed
   - Verify Firebase configuration

2. **App doesn't load**:
   - Verify GitHub Pages is enabled in repository settings
   - Check if the deployment workflow completed successfully
   - Ensure base href is correctly configured

3. **Firebase errors**:
   - Check Firebase project configuration
   - Verify API keys and domains in Firebase Console
   - Ensure web app is registered in Firebase project

### Debug Steps

1. **Check workflow logs**:
   ```bash
   # View in GitHub Actions tab
   https://github.com/s4pun1s7/buna_app/actions
   ```

2. **Test local build**:
   ```bash
   flutter build web --release
   cd build/web
   python -m http.server 8000
   ```

3. **Verify configuration**:
   - Check `web/index.html` for correct Firebase config
   - Verify `pubspec.yaml` dependencies
   - Test web app locally before deployment

## 🔄 Updates

To update the deployed app:

1. Make your changes
2. Commit and push to main branch
3. GitHub Actions will automatically rebuild and deploy
4. Changes will be live within 5-10 minutes

## 🌐 Custom Domain (Optional)

To use a custom domain:

1. Add a `CNAME` file to the `web/` directory:
   ```
   yourdomain.com
   ```

2. Configure DNS records with your domain provider
3. Update Firebase hosting settings if using custom domain

## 📊 Performance Notes

The web app includes:
- **Optimized assets**: WebP images for better performance
- **Caching**: Intelligent caching for offline support
- **Lazy loading**: Components loaded on demand
- **PWA features**: Service worker for offline functionality

## 🔒 Security

- All API keys are properly configured for production
- Firebase security rules are in place
- HTTPS is enforced through GitHub Pages