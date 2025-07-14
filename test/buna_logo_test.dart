import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/widgets/branding/buna_logo.dart';

void main() {
  testWidgets('BunaLogo widget displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: BunaLogo(width: 100, height: 100),
          ),
        ),
      ),
    );
    // Check for presence of BunaLogo widget
    expect(find.byType(BunaLogo), findsOneWidget);
    // Check for presence of Image widget inside BunaLogo
    expect(find.byType(Image), findsWidgets);
  });
}
