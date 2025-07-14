import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;
import 'package:flutter/material.dart'; // Import Material package for Scaffold

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Drawer', () {
    testWidgets('Open drawer and check menu items', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      // Try to open the drawer
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);
      // Open the drawer by dragging or tapping menu icon
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      // Check for expected menu items
      expect(find.text('Artists'), findsWidgets);
      expect(find.text('Venues'), findsWidgets);
    });
  });
}
