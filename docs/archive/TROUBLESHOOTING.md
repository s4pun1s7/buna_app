# Troubleshooting & FAQ

Common issues and solutions for the Buna Festival app development and usage.

## 🔧 Development Issues

### Flutter & Dart Issues

#### Flutter Command Not Found
**Problem**: `flutter: command not found`

**Solution**:
```sh
# Add Flutter to PATH
export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"

# Add to shell profile (.bashrc, .zshrc, etc.)
echo 'export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"' >> ~/.bashrc
```

#### Flutter Doctor Issues
**Problem**: `flutter doctor` shows issues

**Solution**:
```sh
# Check Flutter installation
flutter doctor -v

# Fix common issues
flutter doctor --android-licenses
flutter config --android-studio-dir [PATH_TO_ANDROID_STUDIO]
```

#### Dependency Conflicts
**Problem**: Package version conflicts

**Solution**:
```sh
# Clean and reinstall dependencies
flutter clean
flutter pub get

# Update dependencies
flutter pub upgrade

# Resolve conflicts manually in pubspec.yaml
```

### Firebase Issues

#### Firebase Not Initializing
**Problem**: Firebase initialization errors

**Solution**:
1. Verify configuration files are in correct locations:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
2. Check Firebase project configuration
3. Ensure all required Firebase services are enabled

#### Web Firebase Configuration
**Problem**: Firebase not working on web

**Solution**:
```dart
// Verify config in lib/main.dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'your-api-key',
    authDomain: 'your-project.firebaseapp.com',
    projectId: 'your-project-id',
    // ... other config
  ),
);
```

#### Authentication Issues
**Problem**: Anonymous authentication not working

**Solution**:
1. Enable Anonymous Authentication in Firebase Console
2. Check Firebase rules allow anonymous users
3. Verify app configuration matches Firebase project

### Build Issues

#### Android Build Failures
**Problem**: Android build fails

**Solution**:
```sh
# Clean Android build
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get

# Check Java version
java -version  # Should be Java 8 or 11

# Update Android SDK
# Open Android Studio > SDK Manager > Update SDK
```

#### iOS Build Failures (macOS only)
**Problem**: iOS build fails

**Solution**:
```sh
# Clean iOS build
flutter clean
cd ios && rm -rf build && pod install && cd ..
flutter pub get

# Update CocoaPods
sudo gem install cocoapods
cd ios && pod update && cd ..

# Check Xcode version
xcode-select --print-path
```

#### Web Build Issues
**Problem**: Web build fails or doesn't work

**Solution**:
```sh
# Enable web support
flutter config --enable-web

# Clean web build
flutter clean
flutter pub get
flutter build web

# Check browser compatibility
# Use Chrome for development and testing
```

## 🌐 Localization Issues

### Localization Not Working
**Problem**: App doesn't show translated text

**Solution**:
1. Check ARB files are valid JSON in `lib/l10n/`:
   ```
   lib/l10n/
   ├── app_en.arb
   └── app_bg.arb
   ```

2. Generate localization files:
   ```sh
   flutter gen-l10n
   # or
   flutter run  # Auto-generates on run
   ```

3. Verify `l10n.yaml` configuration:
   ```yaml
   arb-dir: lib/l10n
   template-arb-file: app_en.arb
   output-localization-file: app_localizations.dart
   ```

### Missing Translations
**Problem**: Some text not translated

**Solution**:
1. Add missing keys to both ARB files
2. Use consistent key naming
3. Regenerate localization files
4. Restart the app

### Language Not Switching
**Problem**: Language toggle doesn't work

**Solution**:
1. Check locale provider implementation
2. Verify `MaterialApp` uses the locale provider
3. Ensure all text uses `AppLocalizations.of(context)`

## 🗺️ Maps & Location Issues

### Google Maps Not Loading
**Problem**: Maps don't display

**Solution**:
1. **Android**: Add API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY" />
   ```

2. **iOS**: Add API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY")
   ```

3. **Web**: Check API key in `web/index.html`

### Location Permission Denied
**Problem**: Location permissions not granted

**Solution**:
1. Check permission configuration in platform files
2. Request permissions with proper rationale
3. Handle permission denied gracefully
4. Test on real devices (permissions don't work in simulators)

### Maps Performance Issues
**Problem**: Maps are slow or laggy

**Solution**:
1. Optimize marker clustering
2. Reduce map complexity
3. Use appropriate zoom levels
4. Implement lazy loading for markers

## 📱 Platform-Specific Issues

### Android Issues

#### Permission Errors
**Problem**: Runtime permission errors

**Solution**:
1. Check `android/app/src/main/AndroidManifest.xml`
2. Request permissions at runtime
3. Handle permission rationale dialogs
4. Test on different Android versions

#### Build Errors
**Problem**: Gradle build failures

**Solution**:
```sh
# Update Gradle wrapper
cd android && ./gradlew wrapper --gradle-version=7.6 && cd ..

# Clean and rebuild
flutter clean
cd android && ./gradlew clean && cd ..
flutter build apk
```

### iOS Issues

#### Provisioning Profile Errors
**Problem**: Code signing issues

**Solution**:
1. Check bundle identifier matches provisioning profile
2. Update development team in Xcode
3. Refresh provisioning profiles
4. Clean and rebuild project

#### Deployment Target
**Problem**: Minimum iOS version errors

**Solution**:
1. Set deployment target to iOS 13.0 in Xcode
2. Update `ios/Podfile`:
   ```ruby
   platform :ios, '13.0'
   ```

### Web Issues

#### CORS Errors
**Problem**: Cross-origin request blocked

**Solution**:
1. Configure server CORS headers
2. Use proxy during development
3. Deploy to same domain as API

#### PWA Not Installing
**Problem**: Progressive Web App not installable

**Solution**:
1. Check `web/manifest.json` configuration
2. Ensure HTTPS deployment
3. Add service worker
4. Verify PWA requirements

## 🎨 UI/UX Issues

### Theme Not Applying
**Problem**: Dark/light theme not working

**Solution**:
1. Check theme provider implementation
2. Verify `MaterialApp` uses theme provider
3. Ensure persistent theme storage
4. Test theme switching functionality

### Responsive Design Issues
**Problem**: UI doesn't adapt to different screen sizes

**Solution**:
1. Use `MediaQuery` for screen dimensions
2. Implement responsive breakpoints
3. Test on various screen sizes
4. Use flexible layouts (`Flex`, `Expanded`, etc.)

### Performance Issues
**Problem**: App is slow or laggy

**Solution**:
1. Enable performance monitoring
2. Optimize image loading and caching
3. Implement lazy loading
4. Profile with Flutter DevTools
5. Reduce rebuild frequency

## 🔄 State Management Issues

### Riverpod Provider Errors
**Problem**: Provider not updating or errors

**Solution**:
1. Check provider scope and lifecycle
2. Verify provider dependencies
3. Use proper provider types (`StateProvider`, `FutureProvider`, etc.)
4. Handle loading and error states

### State Not Persisting
**Problem**: App state resets on restart

**Solution**:
1. Implement state persistence with `SharedPreferences`
2. Save critical state in provider lifecycle
3. Restore state on app initialization

## 🌐 Network & API Issues

### API Calls Failing
**Problem**: Network requests fail

**Solution**:
1. Check network connectivity
2. Verify API endpoints and authentication
3. Handle timeout and retry logic
4. Test with different network conditions

### Caching Issues
**Problem**: Cached data not updating

**Solution**:
1. Implement cache invalidation strategy
2. Add manual refresh options
3. Check cache expiration logic
4. Clear cache when needed

## 🧪 Testing Issues

### Tests Failing
**Problem**: Tests don't pass

**Solution**:
```sh
# Clean and run tests
flutter clean
flutter pub get
flutter test

# Run specific test
flutter test test/widget_test.dart

# Debug test failures
flutter test --verbose
```

### Mock Issues
**Problem**: Mocking not working

**Solution**:
1. Generate mocks properly:
   ```sh
   flutter packages pub run build_runner build
   ```
2. Check mock configuration
3. Verify test setup and teardown

## 📊 Performance Issues

### Memory Leaks
**Problem**: App memory usage increases over time

**Solution**:
1. Profile with Flutter DevTools
2. Dispose controllers and streams properly
3. Avoid retaining unnecessary objects
4. Use weak references where appropriate

### Startup Performance
**Problem**: App takes too long to start

**Solution**:
1. Optimize Firebase initialization
2. Implement lazy loading
3. Reduce initial widget tree complexity
4. Profile startup performance

## 🔧 Development Tools

### Hot Reload Not Working
**Problem**: Changes don't appear after hot reload

**Solution**:
1. Try hot restart instead (`R`)
2. Check for syntax errors
3. Restart development server
4. Clean and rebuild if needed

### DevTools Issues
**Problem**: Flutter DevTools not connecting

**Solution**:
1. Ensure Flutter DevTools is updated
2. Check browser compatibility
3. Try different port or restart
4. Use `flutter doctor` to check setup

## ❓ Frequently Asked Questions

### Q: How do I enable development features?
A: Run with development flag:
```sh
flutter run --dart-define=DEV_TOOLS=true
```

### Q: How do I reset app data during development?
A: Clear app data or use development panel to reset state.

### Q: Why are some features not visible?
A: Check feature flags in `lib/config/feature_flags.dart` - some features may be disabled.

### Q: How do I test on real devices?
A: Connect device via USB, enable developer options, and run:
```sh
flutter devices  # List available devices
flutter run -d [device-id]
```

### Q: How do I deploy to production?
A: See [Running & Building Guide](RUNNING_BUILDING.md) for detailed deployment instructions.

### Q: Where can I find logs?
A: 
- Development: Console output or Flutter DevTools
- Production: Firebase Crashlytics or device logs
- Web: Browser developer console

## 🆘 Getting Additional Help

### Resources
- **Flutter Documentation**: https://docs.flutter.dev/
- **Firebase Documentation**: https://firebase.google.com/docs
- **Stack Overflow**: Tag your questions with `flutter`
- **GitHub Issues**: Report bugs in the repository

### Debugging Commands
```sh
# Check Flutter installation
flutter doctor -v

# Analyze code
flutter analyze

# Clean project
flutter clean && flutter pub get

# Verbose logging
flutter run --verbose

# Performance profiling
flutter run --profile
```

### Log Collection
```sh
# Collect logs for debugging
flutter logs > debug.log

# Android device logs
adb logcat > android.log

# iOS device logs (Mac only)
idevicesyslog > ios.log
```

---

If you can't find a solution here, check the [Documentation Index](README.md) or open an issue in the GitHub repository.
