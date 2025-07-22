import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('User completes onboarding flow', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // Verify onboarding screen is shown
    expect(find.text('Welcome to Buna Festival'), findsOneWidget);

    // Select language (if needed)
    if (find.text('Български').evaluate().isNotEmpty) {
      await tester.tap(find.text('Български'));
      await tester.pumpAndSettle();
    }

    // Tap Get Started
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Should show loading, then proceed to main app
    expect(find.text('Loading...'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify onboarding is complete (e.g., home screen or main nav is shown)
    expect(find.textContaining('Home'), findsWidgets);
  });
} 