import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app.dart';
import 'utils/restart_widget.dart';
import 'providers/riverpod_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'services/connectivity_service.dart';
import 'services/analytics_service.dart';
import 'services/lazy_loading_service.dart';
import 'services/performance_monitoring_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:async';

/// Request permissions asynchronously without blocking startup
Future<void> requestFestivalPermissions() async {
  if (!kIsWeb) {
    // Request permissions in background after app starts
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Camera permission with rationale
      if (await Permission.camera.status.isDenied) {
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
    });
  }
}

/// Initialize Firebase and services asynchronously
Future<void> initializeAppServices() async {
  try {
    // Initialize performance monitoring first
    PerformanceMonitoringService().initialize();

    // Track app initialization start
    final appInitStart = DateTime.now();

    // Initialize Firebase with platform-specific options
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyD2xqxPjbnA6t-TFsn2pNAuy1VHDOK4l-0',
          authDomain: 'buna-app-4e064.firebaseapp.com',
          projectId: 'buna-app-4e064',
          storageBucket: 'buna-app-4e064.appspot.com',
          messagingSenderId: '177152010877',
          appId: '1:177152010877:web:96f0625f1a29a0bc825f14',
          measurementId: 'G-3XR3FVMHZY',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    // Initialize services in parallel for faster startup
    await Future.wait([
      ConnectivityService().initialize(),
      LazyLoadingService().preloadCriticalComponents(),
      // Add other service initializations here
    ]);

    // Track app initialization completion
    final initDuration = DateTime.now().difference(appInitStart);
    if (kDebugMode) {
      print('✅ All services initialized in ${initDuration.inMilliseconds}ms');
    }

    // Track app launch after services are initialized
    AnalyticsService.logEvent(name: 'app_launch');
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ Service initialization error: $e');
    }
    // Continue without Firebase/services for now
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services asynchronously in background
  await initializeAppServices();

  // Start app immediately with loading state
  runApp(RestartWidget(child: const BunaAppWithPermissions()));

  // Request permissions after app starts
  requestFestivalPermissions();
}

/// App wrapper with optimized initialization
class BunaAppWithPermissions extends StatefulWidget {
  const BunaAppWithPermissions({super.key});

  @override
  State<BunaAppWithPermissions> createState() => _BunaAppWithPermissionsState();
}

class _BunaAppWithPermissionsState extends State<BunaAppWithPermissions> {
  // Toggleable iOS device size simulation
  bool _iosSizeMode = false;
  final Size _iosSize = const Size(390, 844); // iPhone 14 Pro

  void _toggleIosSizeMode() {
    setState(() {
      _iosSizeMode = !_iosSizeMode;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkServicesInitialization();

    // Clean up lazy loading cache periodically
    _setupPeriodicCleanup();
  }

  void _checkServicesInitialization() {
    // Check if services are initialized
    // For now, we'll assume they initialize quickly
    // In a real app, you'd listen to service initialization state
    final bindingType = WidgetsBinding.instance.runtimeType.toString();
    if (bindingType.contains('TestWidgetsFlutterBinding')) {
      // Skip timer in test mode
      return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          // Services initialized
        });
      }
    });
  }

  Timer? _cleanupTimer;
  void _setupPeriodicCleanup() {
    // Set up periodic cleanup of unused components
    const isTest =
        bool.fromEnvironment('FLUTTER_TEST') ||
        String.fromEnvironment('FLUTTER_TEST') == 'true';
    if (isTest) {
      return;
    }
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      LazyLoadingService().cleanupUnusedComponents();
    });
  }

  @override
  void dispose() {
    // Clean up periodic timer
    _cleanupTimer?.cancel();
    // Clean up performance monitoring when app is disposed
    PerformanceMonitoringService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use Consumer to watch themeProvider and pass to BunaApp
    return RiverpodApp(
      child: Consumer(
        builder: (context, ref, _) {
          final themeMode = ref.watch(themeProvider);
          final locale = ref.watch(localeProvider);
          return BunaApp(
            iosSizeMode: _iosSizeMode,
            iosSize: _iosSize,
            toggleIosSizeMode: _toggleIosSizeMode,
            themeMode: themeMode,
            locale: locale,
          );
        },
      ),
    );
  }
}
