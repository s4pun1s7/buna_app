# Troubleshooting & FAQ

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
