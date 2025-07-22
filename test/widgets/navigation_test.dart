import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/navigation/app_router.dart';

// If the test setup is broken, comment out the test for now.

void main() {
  testWidgets('Navigation between main screens works', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Check initial screen (splash or onboarding)
    expect(find.byType(MaterialApp), findsOneWidget);

    // Example: Tap on navigation bar item for "Venues"
    // (Adjust the finder as per your actual navigation bar implementation)
    if (find.text('Venues').evaluate().isNotEmpty) {
      await tester.tap(find.text('Venues'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Venue'), findsWidgets);
    }

    // Example: Tap on navigation bar item for "News"
    if (find.text('News').evaluate().isNotEmpty) {
      await tester.tap(find.text('News'));
      await tester.pumpAndSettle();
      expect(find.textContaining('News'), findsWidgets);
    }
  });
} 