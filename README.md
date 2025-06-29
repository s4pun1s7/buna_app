<<<<<<< HEAD
<<<<<<< HEAD
=======
# buna_app
=======
>>>>>>> a67ea8da79b29d7866b04a5e0198895c14d71ba1
# Buna Festival App

A cross-platform Flutter app for the Buna art festival, supporting Android, iOS, and Web. Features onboarding, Firebase integration, multi-language support (English/Bulgarian), and more.

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
- [Project Tracking](docs/PROJECT_TRACKING.md)
- [Dependency Issues](docs/DEPENDENCY_ISSUES.md)

---

## iOS Minimum Version

The minimum supported iOS version is **13.0**.  
Make sure your environment and device meet this requirement.

---

<<<<<<< HEAD
For license information, see [LICENSE](LICENSE).
=======
# buna_app
>>>>>>> 5a9f087 (Initial commit)
=======
### Setup
1. Clone the repo:
   ```sh
   git clone https://github.com/YOUR_USERNAME/buna_app.git
   cd buna_app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Add Firebase config files:
   - Android: `google-services.json` in `android/app/`
   - iOS: `GoogleService-Info.plist` in `ios/Runner/`
   - Web: Register app in Firebase Console and use config in `main.dart`

## Firebase Setup
- Register your app for Android, iOS, and Web in the Firebase Console.
- For web, copy the config snippet and paste it into `main.dart` as shown in the code.
- Enable anonymous authentication in the Firebase Console.

## Localization
- ARB files for English and Bulgarian are in `lib/l10n/`.
- To add more languages, create a new ARB file and update the onboarding screen and localization delegates.

## Running & Building
- **Android/iOS:**
  ```sh
  flutter run
  ```
- **Web:**
  ```sh
  flutter run -d chrome
  ```
- **Build for release:**
  ```sh
  flutter build apk   # Android
  flutter build ios   # iOS (on Mac)
  flutter build web   # Web
  ```

## Testing
- Run all tests:
  ```sh
  flutter test
  ```
- Add widget and integration tests in the `test/` directory.

## Contributing
- Fork the repo and create a feature branch.
- Follow the code style and use meaningful commit messages.
- Open a pull request with a clear description.
- Use GitHub Issues for bug reports and feature requests.

## Troubleshooting & FAQ
- **Localization not working?**
  - Ensure ARB files are valid and in `lib/l10n/`.
  - Run `flutter gen-l10n` or `flutter run` to generate localization files.
- **Firebase web error?**
  - Make sure you registered the app in Firebase Console and copied the config to `main.dart`.
- **Permission errors on web?**
  - Some permissions are not supported on web and are skipped automatically.
- **Other issues?**
  - Run `flutter clean` and `flutter pub get`.
  - Check the [Flutter documentation](https://docs.flutter.dev/).

## Changelog
See [PROJECT_TRACKING.md](PROJECT_TRACKING.md) for recent progress and completed features.

## License
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
>>>>>>> dev
>>>>>>> a67ea8da79b29d7866b04a5e0198895c14d71ba1
