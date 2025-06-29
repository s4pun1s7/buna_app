# Getting Started

## Prerequisites
- Flutter SDK (see [Flutter install guide](https://docs.flutter.dev/get-started/install))
- Dart SDK
- Firebase account

## Setup
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
