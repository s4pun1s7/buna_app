import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app.dart';

Future<void> requestFestivalPermissions() async {
  if (!kIsWeb) {
    // Request camera permission
    await Permission.camera.request();
    // Request location permission
    await Permission.locationWhenInUse.request();
    // Request notification permission (Android 13+)
    await Permission.notification.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyD2xqxPjbnA6t-TFsn2pNAuy1VHDOK4l-0',
        authDomain: 'buna-app-4e064.firebaseapp.com',
        projectId: 'buna-app-4e064',
        storageBucket: 'buna-app-4e064.firebasestorage.app',
        messagingSenderId: '177152010877',
        appId: '1:177152010877:web:96f0625f1a29a0bc825f14',
        measurementId: 'G-3XR3FVMHZY',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  // Anonymous sign-in for development
  await FirebaseAuth.instance.signInAnonymously();
  // Request permissions at app start (customize as needed)
  await requestFestivalPermissions();
  runApp(const BunaApp());
}
