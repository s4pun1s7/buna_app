import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/widgets/common/index.dart';

import 'firebase_test_mocks.dart';

void main() {
  setUpAll(() async {
    await setupFirebaseTestMocks();
  });
  group('LoadingIndicator Widget', () {
    testWidgets('shows CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingIndicator())),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('shows message if provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingIndicator(message: 'Loading...')),
        ),
      );
      expect(find.text('Loading...'), findsOneWidget);
    });
  });
}
