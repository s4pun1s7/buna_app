import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Secure Firebase configuration with environment variables
class FirebaseConfig {
  FirebaseConfig._();

  /// Get Firebase options based on platform
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return _webOptions;
    }
    // Add platform-specific options for other platforms
    throw UnsupportedError(
      'Firebase configuration not supported for this platform',
    );
  }

  /// Web Firebase configuration using environment variables
  static FirebaseOptions get _webOptions {
    return FirebaseOptions(
      // Use environment variables instead of hardcoded values
      apiKey: const String.fromEnvironment(
        'FIREBASE_API_KEY',
        defaultValue: '', // Empty default for security
      ),
      authDomain: const String.fromEnvironment(
        'FIREBASE_AUTH_DOMAIN',
        defaultValue: '',
      ),
      projectId: const String.fromEnvironment(
        'FIREBASE_PROJECT_ID',
        defaultValue: '',
      ),
      storageBucket: const String.fromEnvironment(
        'FIREBASE_STORAGE_BUCKET',
        defaultValue: '',
      ),
      messagingSenderId: const String.fromEnvironment(
        'FIREBASE_MESSAGING_SENDER_ID',
        defaultValue: '',
      ),
      appId: const String.fromEnvironment(
        'FIREBASE_APP_ID',
        defaultValue: '',
      ),
      measurementId: const String.fromEnvironment(
        'FIREBASE_MEASUREMENT_ID',
        defaultValue: '',
      ),
    );
  }

  /// Validate that all required Firebase configuration is present
  static bool get isConfigurationValid {
    final options = currentPlatform;
    return options.apiKey.isNotEmpty &&
        options.authDomain.isNotEmpty &&
        options.projectId.isNotEmpty &&
        options.storageBucket.isNotEmpty &&
        options.messagingSenderId.isNotEmpty &&
        options.appId.isNotEmpty;
  }

  /// Get fallback Firebase options for development/testing
  /// These should be used only in development and never in production
  static FirebaseOptions get _developmentOptions {
    return const FirebaseOptions(
      apiKey: 'AIzaSyD2xqxPjbnA6t-TFsn2pNAuy1VHDOK4l-0',
      authDomain: 'buna-app-4e064.firebaseapp.com',
      projectId: 'buna-app-4e064',
      storageBucket: 'buna-app-4e064.appspot.com',
      messagingSenderId: '177152010877',
      appId: '1:177152010877:web:96f0625f1a29a0bc825f14',
      measurementId: 'G-3XR3FVMHZY',
    );
  }

  /// Get Firebase options with fallback for development
  static FirebaseOptions get optionsWithFallback {
    if (kDebugMode && !isConfigurationValid) {
      // Use development options only in debug mode
      print('⚠️ Using development Firebase configuration');
      print('⚠️ Set environment variables for production');
      return _developmentOptions;
    }
    return currentPlatform;
  }
}