import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app.dart';
import 'widgets/rationale_dialog.dart';
import 'providers/riverpod_setup.dart';

Future<void> requestFestivalPermissions(BuildContext context) async {
  if (!kIsWeb) {
    // Camera permission with rationale
    if (await Permission.camera.status.isDenied) {
      final allow = await showRationaleDialog(
        context,
        'Camera Permission',
        'We need camera access for AR and QR features at the festival.',
      );
      if (allow) await Permission.camera.request();
    }
    // Location permission with rationale
    if (await Permission.locationWhenInUse.status.isDenied) {
      final allow = await showRationaleDialog(
        context,
        'Location Permission',
        'We use your location to show you nearby venues and events.',
      );
      if (allow) await Permission.locationWhenInUse.request();
    }
    // Notification permission with rationale (Android 13+)
    if (await Permission.notification.status.isDenied) {
      final allow = await showRationaleDialog(
        context,
        'Notification Permission',
        'Enable notifications to receive festival news and updates.',
      );
      if (allow) await Permission.notification.request();
    }
  }
}

Future<void> main() async {
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
            requestFestivalPermissions(context);
          });
          return const BunaApp();
        },
      ),
    );
  }
}
