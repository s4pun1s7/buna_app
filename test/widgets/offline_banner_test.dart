import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/widgets/common/offline_banner.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('OfflineBanner displays correct message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(
          home: Scaffold(body: OfflineBanner()),
        ),
      ),
    );
    // Update this to match the actual text in OfflineBanner
    expect(find.text('You are offline'), findsOneWidget);
  });
} 