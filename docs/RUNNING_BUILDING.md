# Running & Building the Buna Festival App

This guide covers running the app in development, building for production, and deploying across all supported platforms.

## 🚀 Development

### Prerequisites
- Flutter SDK (>=3.8.0) installed and configured
- Platform-specific tools:
  - **Android**: Android Studio with Android SDK
  - **iOS**: Xcode (macOS only)
  - **Web**: Chrome browser
- Firebase configuration completed (see [Firebase Setup](FIREBASE_SETUP.md))

### Running in Development

#### Basic Development
```sh
# Run on connected device/emulator
flutter run

# Run on specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

#### Development with Feature Flags
```sh
# Enable development tools and debugging features
flutter run --dart-define=DEV_TOOLS=true

# Web with dev tools
flutter run -d chrome --dart-define=DEV_TOOLS=true
```

#### Debug Mode Features
When running with `DEV_TOOLS=true`:
- In-app development panel
- Feature flag configuration screen
- Performance metrics display
- Debug logging enabled
- Error simulation tools

### Hot Reload & Hot Restart
```sh
# During development session
r  # Hot reload (preserves state)
R  # Hot restart (resets state)
p  # Toggle performance overlay
o  # Toggle platform (iOS <-> Android simulator)
q  # Quit
```

## 🏗️ Building for Production

### Android

#### Debug Build (Development)
```sh
# Create debug APK
flutter build apk --debug

# Create debug App Bundle
flutter build appbundle --debug
```

#### Release Build (Production)
```sh
# Create release APK
flutter build apk --release

# Create release App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build with specific flavor
flutter build apk --release --flavor production
```

#### Signing Configuration
For production builds, configure signing in `android/app/build.gradle`:
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### iOS

#### Debug Build (Development)
```sh
# Build for iOS simulator
flutter build ios --debug --simulator

# Build for iOS device
flutter build ios --debug
```

#### Release Build (Production)
```sh
# Build for App Store
flutter build ios --release

# Build with specific configuration
flutter build ios --release --flavor production
```

#### Xcode Configuration
1. Open `ios/Runner.xcworkspace` in Xcode
2. Configure signing & capabilities
3. Set deployment target (minimum iOS 13.0)
4. Configure app icons and launch screens
5. Archive and distribute through Xcode

### Web

#### Debug Build (Development)
```sh
# Build debug web version
flutter build web --debug

# Build with dev tools enabled
flutter build web --debug --dart-define=DEV_TOOLS=true
```

#### Release Build (Production)
```sh
# Build optimized web version
flutter build web --release

# Build with specific base URL
flutter build web --release --base-href "/buna-app/"

# Build with web renderer
flutter build web --release --web-renderer html
```

#### Web Deployment
Built files are in `build/web/` and can be deployed to:
- Firebase Hosting
- GitHub Pages
- Netlify
- Any static hosting service

## 🔧 Build Configurations

### Environment Variables
```sh
# Development build
flutter build apk --debug --dart-define=ENVIRONMENT=development

# Staging build
flutter build apk --release --dart-define=ENVIRONMENT=staging

# Production build
flutter build apk --release --dart-define=ENVIRONMENT=production
```

### Feature Flags in Builds
```sh
# Enable specific features
flutter build apk --release --dart-define=ENABLE_AR=true

# Disable experimental features
flutter build apk --release --dart-define=ENABLE_EXPERIMENTAL=false
```

### Build Flavors
The app supports different build flavors:

#### Android Flavors
```sh
# Development flavor
flutter build apk --flavor development

# Staging flavor
flutter build apk --flavor staging

# Production flavor
flutter build apk --flavor production
```

## 📱 Platform-Specific Setup

### Android Release Configuration

#### 1. App Signing
Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../keystore.jks
```

#### 2. ProGuard (Optional)
Enable code obfuscation in `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

#### 3. App Bundle Optimization
```sh
# Build optimized App Bundle
flutter build appbundle --release --target-platform android-arm,android-arm64,android-x64
```

### iOS Release Configuration

#### 1. App Store Configuration
- Configure Bundle ID in Xcode
- Set up App Store Connect listing
- Configure app icons and launch screens
- Set deployment target to iOS 13.0

#### 2. Bitcode (if required)
Enable in `ios/Runner.xcodeproj`:
```
Build Settings > Build Options > Enable Bitcode = YES
```

### Web Optimization

#### 1. Performance Optimization
```sh
# Build with split bundles
flutter build web --release --split-debug-info

# Build with tree shaking
flutter build web --release --tree-shake-icons
```

#### 2. PWA Configuration
Configure in `web/manifest.json`:
```json
{
  "name": "Buna Festival App",
  "short_name": "Buna",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2196F3"
}
```

## 🚢 Deployment

### Android Deployment

#### Google Play Store
1. Build signed App Bundle: `flutter build appbundle --release`
2. Upload to Google Play Console
3. Configure store listing and screenshots
4. Submit for review

#### Alternative Distribution
- Direct APK distribution
- Firebase App Distribution
- Third-party app stores

### iOS Deployment

#### App Store
1. Build release version: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect
4. Configure app metadata
5. Submit for review

#### Enterprise Distribution
- Configure enterprise certificate
- Build with enterprise provisioning profile
- Distribute through MDM or direct download

### Web Deployment

#### Firebase Hosting
```sh
# Install Firebase CLI
npm install -g firebase-tools

# Initialize hosting
firebase init hosting

# Build and deploy
flutter build web --release
firebase deploy
```

#### GitHub Pages
```sh
# Build for GitHub Pages
flutter build web --release --base-href "/buna_app/"

# Deploy to gh-pages branch
# (Configure GitHub Pages in repository settings)
```

#### Custom Hosting
```sh
# Build web version
flutter build web --release

# Upload build/web/ contents to your hosting provider
```

## 🧪 Testing Builds

### Pre-Release Testing

#### Android Testing
```sh
# Install debug build
flutter install --debug

# Install release build
flutter install --release

# Test on multiple devices
flutter run -d device1
flutter run -d device2
```

#### iOS Testing
```sh
# Test on simulator
flutter run -d "iPhone 14 Pro Simulator"

# Test on device
flutter run -d "Your iPhone"
```

#### Web Testing
```sh
# Test locally
flutter run -d chrome

# Test built version
cd build/web && python -m http.server 8000
```

### Performance Testing
```sh
# Build with performance profiling
flutter build apk --release --profile

# Run performance tests
flutter run --profile
```

## 🔍 Troubleshooting

### Common Build Issues

#### Android Build Failures
```sh
# Clean and rebuild
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter build apk
```

#### iOS Build Failures
```sh
# Clean iOS build
flutter clean
cd ios && rm -rf build && cd ..
flutter pub get
flutter build ios
```

#### Web Build Issues
```sh
# Clear web cache
flutter clean
flutter pub get
flutter build web --release
```

### Version Conflicts
```sh
# Check Flutter doctor
flutter doctor

# Update Flutter
flutter upgrade

# Check dependencies
flutter pub deps
```

### Build Size Optimization
```sh
# Analyze build size
flutter build apk --analyze-size

# Build with split architectures
flutter build apk --split-per-abi
```

## 📊 Build Metrics

### Android APK Size
- Debug: ~50-70 MB
- Release: ~25-35 MB
- App Bundle: ~20-30 MB (after Play Store optimization)

### iOS App Size
- Debug: ~80-100 MB
- Release: ~30-50 MB (after App Store thinning)

### Web Bundle Size
- Initial load: ~5-8 MB
- Cached: ~2-3 MB subsequent loads

## ✅ Release Checklist

### Pre-Release
- [ ] All tests pass: `flutter test`
- [ ] Code analysis clean: `flutter analyze`
- [ ] Performance tested on target devices
- [ ] Firebase configuration verified
- [ ] App icons and splash screens configured
- [ ] Version numbers updated in `pubspec.yaml`
- [ ] Release notes prepared

### Android Release
- [ ] Signed release build created
- [ ] Tested on multiple Android versions
- [ ] Google Play Console listing updated
- [ ] Screenshots and descriptions updated

### iOS Release
- [ ] Release build archived in Xcode
- [ ] Tested on multiple iOS versions
- [ ] App Store Connect listing updated
- [ ] Privacy policy and terms updated

### Web Release
- [ ] Release build optimized
- [ ] PWA functionality tested
- [ ] Hosting configured and tested
- [ ] Domain and SSL configured

---

For more detailed information, see:
- [Getting Started Guide](GETTING_STARTED.md)
- [Firebase Setup](FIREBASE_SETUP.md)
- [Troubleshooting](TROUBLESHOOTING.md)
