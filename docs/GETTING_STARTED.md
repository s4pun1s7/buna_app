# Getting Started

## Prerequisites
- Flutter SDK (>=3.8.0) - See [Flutter install guide](https://docs.flutter.dev/get-started/install)
- Dart SDK (>=3.0.0) - Included with Flutter
- Firebase account and project setup
- Android Studio / Xcode for mobile development
- Git for version control

## Quick Setup

### 1. Clone the Repository
```sh
git clone https://github.com/s4pun1s7/buna_app.git
cd buna_app
```

### 2. Install Dependencies
```sh
flutter pub get
```

### 3. Configure Firebase
Set up Firebase for each platform:

#### Android
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add an Android app to your project
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### iOS
1. Add an iOS app to your Firebase project
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/` directory

#### Web
1. Add a Web app to your Firebase project
2. Copy the configuration and update `lib/main.dart` with your Firebase config

### 4. Platform Setup

#### Android Permissions
The app uses these permissions (already configured):
- `INTERNET` - For API calls and maps
- `ACCESS_FINE_LOCATION` - For location-based features
- `ACCESS_COARSE_LOCATION` - For general location services
- `CAMERA` - For QR code scanning
- `VIBRATE` - For haptic feedback

#### iOS Permissions
Update `ios/Runner/Info.plist` with required permission descriptions:
- Location services
- Camera access
- Network access

### 5. Run the App
```sh
# For Android/iOS
flutter run

# For Web
flutter run -d chrome

# For specific platform
flutter run -d android
flutter run -d ios
```

## Development Features

### Feature Flags
The app uses feature flags for dynamic control. Enable development features:
```sh
flutter run --dart-define=DEV_TOOLS=true
```

This enables:
- In-app development panel
- Debug logging
- Feature flag configuration
- Performance metrics display

### Available Build Configurations
```sh
# Debug build with all features
flutter run --debug

# Profile build for performance testing
flutter run --profile

# Release build for production
flutter run --release

# Web build with development tools
flutter run -d chrome --dart-define=DEV_TOOLS=true
```

## Project Structure Overview

```
buna_app/
├── lib/
│   ├── features/          # Feature modules
│   │   ├── onboarding/    # User onboarding
│   │   ├── home/          # Main dashboard
│   │   ├── venues/        # Venue management
│   │   ├── artists/       # Artist profiles
│   │   ├── qr/            # QR code scanner
│   │   ├── ar/            # AR experiences
│   │   └── ...            # Other features
│   ├── services/          # Business logic
│   ├── providers/         # State management
│   ├── models/            # Data models
│   └── config/            # App configuration
├── docs/                  # Documentation
├── assets/                # Images and resources
└── platform files/       # Android, iOS, Web configs
```

## First-Time Setup Checklist

- [ ] Flutter SDK installed and configured
- [ ] Repository cloned and dependencies installed
- [ ] Firebase project created and configured
- [ ] Platform-specific setup completed
- [ ] App runs successfully on target platform
- [ ] Feature flags configured (if needed)
- [ ] Development tools enabled (optional)

## Troubleshooting

### Common Issues

**Flutter not found**
```sh
# Add Flutter to your PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

**Firebase configuration errors**
- Verify config files are in the correct locations
- Check Firebase project settings
- Ensure all required Firebase services are enabled

**Build failures**
```sh
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**Permission issues on iOS**
- Verify Info.plist has required permission descriptions
- Check iOS deployment target (minimum iOS 13.0)

**Web build issues**
- Check Firebase web configuration
- Verify CORS settings if using external APIs

## Next Steps

1. **Explore Features**: Check out the [Features Guide](FEATURES.md)
2. **Read Documentation**: Browse the [Documentation Index](README.md)
3. **Understand Architecture**: Review [Architecture Guide](ARCHITECTURE.md)
4. **Start Contributing**: Follow the [Contributing Guidelines](CONTRIBUTING.md)

## Support

- 📖 [Documentation](README.md)
- 🐛 [Troubleshooting](TROUBLESHOOTING.md)
- 🔧 [Firebase Setup](FIREBASE_SETUP.md)
- 📱 [Running & Building](RUNNING_BUILDING.md)
