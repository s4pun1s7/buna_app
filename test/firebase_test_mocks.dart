import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Call this in your test setup to initialize Firebase for tests with fake options.
Future<void> setupFirebaseTestMocks() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'fake',
        appId: '1:123:android:abc',
        messagingSenderId: 'fake',
        projectId: 'fake',
      ),
    );
  } catch (_) {
    // Firebase may already be initialized in some test runners
  }
}
