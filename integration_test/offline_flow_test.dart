import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Shows offline banner when offline', (tester) async {
    // Simulate offline by mocking connectivity (requires DI or test flag)
    // For now, just run the app and check for offline UI if possible

    await app.main();
    await tester.pumpAndSettle();

    // Expect offline banner or message
    expect(find.textContaining('offline'), findsWidgets);
  });
} 