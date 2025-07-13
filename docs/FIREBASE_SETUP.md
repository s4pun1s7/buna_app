# Firebase Setup Guide

This guide walks you through setting up Firebase for the Buna Festival app on all supported platforms.

## 🔥 Firebase Console Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `buna-festival-app` (or your preferred name)
4. Enable Google Analytics (recommended)
5. Choose or create Analytics account
6. Click "Create project"

### 2. Enable Required Services
In your Firebase project, enable these services:

#### Authentication
1. Go to **Authentication** > **Sign-in method**
2. Enable **Anonymous** authentication
3. Optionally enable **Google Sign-In** for future use

#### Firestore Database
1. Go to **Firestore Database**
2. Click "Create database"
3. Choose "Start in test mode" for development
4. Select database location closest to your users

#### Analytics
1. Go to **Analytics** > **Events**
2. Analytics is automatically enabled if configured during project creation
3. Review default events and custom event tracking

#### Performance Monitoring
1. Go to **Performance**
2. Enable Performance Monitoring
3. SDK will automatically start collecting data

## 📱 Platform Configuration

### Android Setup

#### 1. Register Android App
1. In Firebase Console, click "Add app" > Android icon
2. Enter package name: `com.example.buna_app` (or your package name)
3. Enter app nickname: "Buna Festival - Android"
4. Enter SHA-1 certificate fingerprint (optional for development)

#### 2. Download Configuration
1. Download `google-services.json`
2. Place it in `android/app/` directory
3. **Important**: Verify the file is in the correct location:
   ```
   android/
   ├── app/
   │   ├── google-services.json  ← Here
   │   ├── build.gradle
   │   └── src/
   ```

#### 3. Configure Build Files
The project is already configured with necessary dependencies in:
- `android/build.gradle` - Google Services plugin
- `android/app/build.gradle` - Google Services plugin application

#### 4. Verify Setup
```sh
flutter run -d android
# Check logs for Firebase initialization success
```

### iOS Setup

#### 1. Register iOS App
1. In Firebase Console, click "Add app" > iOS icon
2. Enter bundle ID: `com.example.bunaApp` (or your bundle ID)
3. Enter app nickname: "Buna Festival - iOS"
4. Enter App Store ID (optional)

#### 2. Download Configuration
1. Download `GoogleService-Info.plist`
2. Place it in `ios/Runner/` directory
3. **Important**: Add file to Xcode project:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Right-click `Runner` folder > "Add Files to Runner"
   - Select `GoogleService-Info.plist`
   - Ensure "Add to target: Runner" is checked

#### 3. Verify Setup
```sh
flutter run -d ios
# Check logs for Firebase initialization success
```

### Web Setup

#### 1. Register Web App
1. In Firebase Console, click "Add app" > Web icon
2. Enter app nickname: "Buna Festival - Web"
3. Enable Firebase Hosting (optional)
4. Copy the configuration object

#### 2. Update Configuration
The Firebase config is already set up in `lib/main.dart`. Update with your config:

```dart
// In lib/main.dart, update the FirebaseOptions
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'your-api-key',
    authDomain: 'your-project.firebaseapp.com',
    projectId: 'your-project-id',
    storageBucket: 'your-project.appspot.com',
    messagingSenderId: '123456789',
    appId: 'your-app-id',
    measurementId: 'G-XXXXXXXXXX',
  ),
);
```

#### 3. Verify Setup
```sh
flutter run -d chrome
# Check browser console for Firebase initialization
```

## 🔐 Security Configuration

### Firestore Security Rules
Update Firestore rules for production:

```javascript
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anonymous users to read public data
    match /venues/{document} {
      allow read: if true;
    }
    
    match /events/{document} {
      allow read: if true;
    }
    
    match /news/{document} {
      allow read: if true;
    }
    
    // User-specific data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Authentication Settings
1. **Anonymous Auth**: Already enabled for guest access
2. **Password Requirements**: Set strong password policies if enabling email/password
3. **Domain Restrictions**: Add authorized domains for production

## 🧪 Testing Firebase Integration

### Verify Installation
Run the app and check for these log messages:

**Android/iOS:**
```
[firebase_core] Firebase app '[DEFAULT]' configured successfully
[firebase_analytics] Analytics initialized
```

**Web:**
```javascript
Firebase initialized successfully
Analytics enabled
```

### Test Features
1. **Anonymous Authentication**: User should be automatically signed in
2. **Analytics**: Events should appear in Firebase Console > Analytics
3. **Performance**: Metrics should appear in Firebase Console > Performance
4. **Firestore**: Data should sync if you add any cloud features

## 🔧 Troubleshooting

### Common Issues

#### Android Build Errors
```sh
# Clean and rebuild
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter run
```

#### iOS Build Errors
- Ensure `GoogleService-Info.plist` is added to Xcode project
- Check bundle ID matches Firebase configuration
- Verify iOS deployment target is 13.0 or higher

#### Web Console Errors
- Verify Firebase config object is correct
- Check that all required Firebase services are enabled
- Ensure domain is added to authorized domains

#### Configuration File Issues
```sh
# Verify files are in correct locations
ls android/app/google-services.json
ls ios/Runner/GoogleService-Info.plist
```

### Debug Commands
```sh
# Check Firebase plugins
flutter doctor

# Verbose logging
flutter run --verbose

# Clean installation
flutter clean
flutter pub get
```

## 📊 Development vs Production

### Development Setup
- Use test mode for Firestore
- Enable debug logging
- Use development certificates
- Test with Firebase emulators (optional)

### Production Setup
- Configure production Firestore rules
- Set up proper authentication
- Add production domains to authorized domains
- Enable crash reporting
- Set up monitoring and alerts

## 🚀 Additional Features

### Firebase Hosting (Optional)
For hosting the web version:
```sh
npm install -g firebase-tools
firebase init hosting
firebase deploy
```

### Cloud Functions (Future)
For server-side functionality:
```sh
firebase init functions
# Implement cloud functions as needed
```

### Remote Config (Advanced)
For dynamic app configuration:
1. Enable Remote Config in Firebase Console
2. Add remote config parameters
3. Update app to use remote values

## 📚 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)

## ✅ Setup Checklist

- [ ] Firebase project created
- [ ] Authentication enabled (Anonymous)
- [ ] Firestore database created
- [ ] Android app registered and `google-services.json` added
- [ ] iOS app registered and `GoogleService-Info.plist` added
- [ ] Web app registered and config updated in `main.dart`
- [ ] App runs successfully on target platforms
- [ ] Firebase initialization logs appear
- [ ] Analytics events are being tracked
- [ ] Security rules configured for production (if applicable)

**Note**: Keep your Firebase configuration files secure and never commit them to public repositories. They're already included in `.gitignore`.
