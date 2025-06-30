<<<<<<< HEAD
<<<<<<< HEAD
# buna_app
=======
>>>>>>> d6432e1de732e79f0c39f66dd142f9d3cc1307e5
=======
>>>>>>> d6432e1de732e79f0c39f66dd142f9d3cc1307e5
# Buna Festival App

A cross-platform Flutter app for the Buna art festival, supporting Android, iOS, and Web. Features onboarding, Firebase integration, multi-language support (English/Bulgarian), venue management, interactive maps, and real-time news updates.

## ✨ Recent Updates
- **Code Cleanup**: Organized imports, removed unused dependencies, and improved code structure
- **Global Language Toggle**: Easy language switching (EN/BG) accessible from the main interface
- **Enhanced News Section**: Real-time festival updates including app development announcements
- **Improved State Management**: Centralized locale management with Riverpod providers
- **Better UI/UX**: Consistent theming and responsive design across all platforms

---

## Documentation
- [Features](docs/FEATURES.md)
- [Getting Started](docs/GETTING_STARTED.md)
- [Firebase Setup](docs/FIREBASE_SETUP.md)
- [Localization](docs/LOCALIZATION.md)
- [Running & Building](docs/RUNNING_BUILDING.md)
- [Testing](docs/TESTING.md)
- [Contributing](docs/CONTRIBUTING.md)
- [Troubleshooting & FAQ](docs/TROUBLESHOOTING.md)
- [Changelog](docs/CHANGELOG.md)
- [Project Tracking](PROJECT_TRACKING.md)
- [Dependency Issues](docs/DEPENDENCY_ISSUES.md)

---

## 🚀 Key Features

### Core Functionality
- **Multi-language Support**: English and Bulgarian with real-time switching
- **Venue Management**: Browse festival venues with interactive maps
- **Event Scheduling**: Personal schedule with favorites and reminders
- **News & Updates**: Real-time festival announcements and updates
- **Interactive Maps**: Google Maps integration with venue markers
- **User Preferences**: Favorites, notes, and personalized experience

### Technical Features
- **Cross-platform**: Android, iOS, and Web support
- **Firebase Integration**: Authentication and backend services
- **State Management**: Riverpod for reactive state management
- **Navigation**: Go Router for type-safe navigation
- **Responsive Design**: Optimized for all screen sizes
- **Permission Handling**: Smart permission requests with rationale dialogs

---

<<<<<<< HEAD
<<<<<<< HEAD
## 📱 Platform Support

### iOS
- **Minimum Version**: 13.0
- **Features**: Full native support with iOS-specific optimizations

### Android
- **Minimum Version**: API 21 (Android 5.0)
- **Features**: Material Design 3 components and Android-specific features

### Web
- **Browser Support**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Features**: Progressive Web App capabilities

---

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK (>=3.8.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode (for mobile development)
- Firebase project setup

### Quick Start
1. **Clone the repository**:
=======
=======
>>>>>>> d6432e1de732e79f0c39f66dd142f9d3cc1307e5
For license information, see [LICENSE](LICENSE).

### Setup
1. Clone the repo:
>>>>>>> d6432e1de732e79f0c39f66dd142f9d3cc1307e5
   ```sh
   git clone <your-repo-url>
   cd buna_app
   ```

2. **Install dependencies**:
   ```sh
   flutter pub get
   ```

3. **Configure Firebase**:
   - Android: Place `google-services.json` in `android/app/`
   - iOS: Place `GoogleService-Info.plist` in `ios/Runner/`
   - Web: Configure in Firebase Console and update `main.dart`

4. **Run the app**:
   ```sh
   flutter run
   ```

---

## 🔧 Development

### Project Structure
```
lib/
├── features/           # Feature modules
│   ├── onboarding/     # Onboarding flow
│   ├── venues/         # Venue management
│   ├── maps/           # Interactive maps
│   ├── news/           # News and updates
│   └── info/           # Festival information
├── models/             # Data models
├── providers/          # Riverpod state management
├── services/           # Business logic
├── widgets/            # Reusable UI components
├── theme/              # App theming
└── l10n/               # Localization files
```

### State Management
The app uses **Riverpod** for state management with the following providers:
- `localeProvider`: Global language management
- `favoritesProvider`: User favorites and preferences
- `scheduleProvider`: Personal schedule management

### Localization
- **Supported Languages**: English (EN) and Bulgarian (BG)
- **Files**: ARB files in `lib/l10n/`
- **Implementation**: Flutter's built-in localization with custom providers

---

## 🧪 Testing

### Run Tests
```sh
# All tests
flutter test

# Specific test file
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Test Coverage
- Widget tests for UI components
- Unit tests for business logic
- Integration tests for user flows

---

## 📦 Building & Deployment

### Development
```sh
# Run on device/emulator
flutter run

# Run on web
flutter run -d chrome
```

### Production Builds
```sh
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS (requires Mac)
flutter build ios

# Web
flutter build web
```

---

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Code Style
- Follow Flutter's official style guide
- Use meaningful commit messages
- Add tests for new features
- Update documentation as needed

---

## 🐛 Troubleshooting

### Common Issues
- **Localization not working?** Run `flutter gen-l10n` to regenerate files
- **Firebase errors?** Verify configuration files are in correct locations
- **Permission issues?** Check platform-specific permission configurations
- **Build failures?** Run `flutter clean && flutter pub get`

### Getting Help
- Check the [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- Review [Flutter Documentation](https://docs.flutter.dev/)
- Open an issue with detailed error information

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
<<<<<<< HEAD
<<<<<<< HEAD

---

## 🔗 Links

- **Festival Website**: [bunavarna.com](https://bunavarna.com/)
- **Facebook**: [Buna Varna](https://www.facebook.com/BunaVarna/)
- **Instagram**: [@buna.varna](https://www.instagram.com/buna.varna/)

---

**Note**: Sensitive files like Firebase configuration files are excluded by `.gitignore` and should not be committed to version control.
=======
>>>>>>> d6432e1de732e79f0c39f66dd142f9d3cc1307e5
=======
>>>>>>> d6432e1de732e79f0c39f66dd142f9d3cc1307e5
