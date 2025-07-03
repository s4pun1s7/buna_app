import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and shows dashboard', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Look for the dashboard title
    expect(find.text('Buna Festival Dashboard'), findsOneWidget);
  });
} 