Moved to docs/README.md
# Buna Festival App

A cross-platform Flutter app for the Buna art festival, supporting Android, iOS, and Web. Features onboarding, Firebase integration, multi-language support (English/Bulgarian), venue management, interactive maps, and real-time news updates.

## ✨ Recent Updates
- **Major Code Cleanup**: Fixed all critical errors, improved type safety, and enhanced code quality
- **Performance Improvements**: Added caching system, connectivity monitoring, and analytics tracking
- **Enhanced Error Handling**: Centralized error management with user-friendly messages
- **Theme System**: Light/dark mode support with persistent preferences
- **Offline Support**: Graceful handling of network connectivity issues
- **Global Language Toggle**: Easy language switching (EN/BG) accessible from the main interface
- **Enhanced News Section**: Real-time festival updates with API integration
- **Improved State Management**: Centralized state management with Riverpod providers
- **Better UI/UX**: Consistent theming and responsive design across all platforms

---

## Documentation
- [Documentation Index](docs/README.md)
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
- [Website Integration](docs/WEBSITE_INTEGRATION.md)
- [Error Handling](docs/ERROR_HANDLING.md)
- [Improvements](docs/IMPROVEMENTS.md)
- [Code Cleanup](docs/CODE_CLEANUP.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Final Summary](docs/FINAL_SUMMARY.md)
- [Roadmap](docs/ROADMAP.md)

---

## 🚀 Key Features

### Core Functionality
- **Multi-language Support**: English and Bulgarian with real-time switching
- **Venue Management**: Browse festival venues with interactive maps
- **Event Scheduling**: Personal schedule with favorites and reminders
- **News & Updates**: Real-time festival announcements and updates
- **Interactive Maps**: Google Maps integration with venue markers
- **Artist Profiles**: Complete artist information and portfolio
- **QR Code Scanner**: Quick access to venue and event information
- **Social Features**: Social feed and community interactions
- **Map Gallery**: Visual gallery of festival locations
- **Feedback System**: User feedback and survey collection
- **User Preferences**: Favorites and personalized experience
- **Theme Support**: Light and dark mode with system preference detection
- **Offline Mode**: Graceful handling when network is unavailable

### Advanced Features
- **AR Experiences**: Augmented reality venue exploration (experimental)
- **Feature Flags**: Dynamic feature toggling for different app builds
- **Performance Monitoring**: Real-time app performance tracking
- **Smart Caching**: Intelligent data caching with automatic cleanup
- **Connectivity Aware**: Adaptive behavior based on network status
- **WordPress Integration**: Real-time content from WordPress CMS

### Technical Features
- **Cross-platform**: Android, iOS, and Web support
- **Firebase Integration**: Authentication, analytics, and backend services
- **State Management**: Riverpod for reactive state management
- **Navigation**: Go Router with lazy loading for optimal performance
- **Responsive Design**: Optimized for all screen sizes and orientations
- **Permission Handling**: Smart permission requests with rationale dialogs
- **Error Handling**: Comprehensive error management and reporting
- **Analytics**: User behavior tracking and performance monitoring
- **Development Tools**: In-app dev panel for debugging (development builds)

### CI/CD & Development Workflow
- **Automated Testing**: Comprehensive unit and integration test suite
- **Code Quality**: Automated linting, formatting, and static analysis
- **Multi-platform Builds**: Automated builds for Android, iOS, and Web
- **Security Scanning**: Automated dependency and security audits
- **Release Management**: Automated release workflows with GitHub Actions
- **Dependency Updates**: Automated dependency updates with Dependabot
- **Code Coverage**: Test coverage reporting and tracking
- **Performance Testing**: Automated performance regression detection

---

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
│   ├── onboarding/     # User onboarding flow
│   ├── home/           # Main dashboard
│   ├── venues/         # Venue management
│   ├── maps/           # Interactive maps
│   ├── news/           # News and updates
│   ├── info/           # Festival information
│   ├── schedule/       # Event scheduling
│   ├── artists/        # Artist profiles and information
│   ├── qr/             # QR code scanner
│   ├── ar/             # Augmented reality features
│   ├── social/         # Social feed and interactions
│   ├── map_gallery/    # Visual map gallery
│   ├── feedback/       # User feedback system
│   ├── settings/       # App settings and feature flags
│   └── offline/        # Offline mode handling
├── models/             # Data models and schemas
├── providers/          # Riverpod state management
├── services/           # Business logic and API integration
├── widgets/            # Reusable UI components
├── navigation/         # Routing and navigation
├── theme/              # App theming and dark mode
├── config/             # App configuration and feature flags
└── l10n/               # Localization files
```

### State Management
The app uses **Riverpod** for state management with the following providers:
- `localeProvider`: Global language management
- `themeProvider`: Theme mode management (light/dark/system)
- `favoritesProvider`: User favorites and preferences
- `scheduleProvider`: Personal schedule management
- `festivalDataProvider`: News, events, and venue data
- `connectivityProvider`: Network connectivity status
- `artistsProvider`: Artist information management
- `qrDataProvider`: QR code scanning results
- `socialProvider`: Social feed and interactions

### Services Architecture
- **API Service**: WordPress REST API integration for content
- **Cache Service**: Intelligent data caching with cleanup
- **Error Handler**: Centralized error management and reporting
- **Analytics Service**: User behavior and performance tracking
- **Connectivity Service**: Network status monitoring and offline handling
- **Performance Service**: App performance metrics and monitoring
- **Lazy Loading Service**: Optimized component loading for better performance

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

### 🌐 GitHub Pages Deployment

The app is configured for automatic deployment to GitHub Pages.

#### Quick Start
1. **Enable GitHub Pages** in repository settings (Settings → Pages → GitHub Actions)
2. **Push to main branch** to trigger automatic deployment
3. **Access the app** at: https://s4pun1s7.github.io/buna_app/

#### Manual Deployment
```sh
# Build and check configuration
./check-pages-config.sh

# Build for GitHub Pages
./deploy.sh
```

#### Configuration Files
- `.github/workflows/deploy-to-pages.yml` - GitHub Actions workflow
- `deploy.sh` - Manual deployment script
- `check-pages-config.sh` - Configuration verification
- `GITHUB_PAGES_DEPLOYMENT.md` - Detailed deployment guide

For complete deployment instructions, see [GITHUB_PAGES_DEPLOYMENT.md](GITHUB_PAGES_DEPLOYMENT.md)

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
- Run `flutter analyze` before committing

---

## 🐛 Troubleshooting

### Common Issues
- **Localization not working?** Run `flutter gen-l10n` to regenerate files
- **Firebase errors?** Verify configuration files are in correct locations
- **Permission issues?** Check platform-specific permission configurations
- **Build failures?** Run `flutter clean && flutter pub get`
- **Code analysis issues?** Run `flutter analyze` to check for problems

### Code Quality
- **Analysis**: Run `flutter analyze` to check code quality
- **Formatting**: Use `flutter format` to format code
- **Linting**: Follow the linting rules in `analysis_options.yaml`

---

## 📊 Code Quality Status

### Current Status
- ✅ **0 Critical Errors** - App compiles successfully across all platforms
- ✅ **37 Total Issues** - Down from 90+ (59% improvement in code quality)
- ✅ **102 Dart Files** - Comprehensive feature implementation
- ✅ **Type Safety** - Enhanced null safety and type checking
- ✅ **Error Handling** - Robust error management with user-friendly messages
- ✅ **Performance** - Advanced caching and optimization systems
- ✅ **Feature Flags** - Dynamic feature control for different builds

### Implemented Features Status
- ✅ **Core Features**: Home, Venues, Maps, News, Info screens
- ✅ **Festival Features**: Schedule, Artist profiles, Event management
- ✅ **Interactive Features**: QR Scanner, Map Gallery, Social feed
- ✅ **Support Features**: Feedback system, Settings, Help
- ✅ **Advanced Features**: AR experiences (experimental), Feature flags
- ✅ **Technical Features**: Offline mode, Caching, Analytics, Performance monitoring

### Recent Improvements
- Fixed all compilation errors and improved code stability
- Enhanced type safety and null safety across the entire codebase
- Implemented comprehensive error handling and user experience improvements
- Added feature flag system for dynamic feature control
- Implemented lazy loading for optimal performance
- Added comprehensive documentation and developer tools
- Improved accessibility with semantic labels and scalable fonts

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
