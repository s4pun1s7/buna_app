import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app.dart';
import 'providers/riverpod_setup.dart';
import 'services/connectivity_service.dart';
import 'services/analytics_service.dart';

Future<void> requestFestivalPermissions() async {
  if (!kIsWeb) {
    // Camera permission with rationale
    if (await Permission.camera.status.isDenied) {
      // Note: In a real app, you'd need to handle this differently
      // since we can't use BuildContext here
      await Permission.camera.request();
    }
    // Location permission with rationale
    if (await Permission.locationWhenInUse.status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
    // Notification permission with rationale (Android 13+)
    if (await Permission.notification.status.isDenied) {
      await Permission.notification.request();
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
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
  
  // Initialize services
  await ConnectivityService().initialize();
  
  // Anonymous sign-in for development
  await FirebaseAuth.instance.signInAnonymously();
  
  // Track app launch
  AnalyticsService.logEvent(name: 'app_launch');
  
  runApp(BunaAppWithPermissions());
}

class BunaAppWithPermissions extends StatelessWidget {
  const BunaAppWithPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return RiverpodApp(
      child: Builder(
        builder: (context) {
          // Request permissions after first build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            requestFestivalPermissions();
          });
          return const BunaApp();
        },
      ),
    );
  }
}
