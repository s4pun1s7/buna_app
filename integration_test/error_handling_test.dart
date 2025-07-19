import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Shows error screen on API failure', (tester) async {
    // Simulate API failure (requires DI or test flag)
    // For now, just run the app and check for error UI if possible

    await app.main();
    await tester.pumpAndSettle();

    // Expect error screen or message
    expect(find.textContaining('Something went wrong'), findsWidgets);
  });
} 