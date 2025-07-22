import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/features/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen adapts to different screen sizes', (tester) async {
    // Small screen
    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    expect(find.byType(HomeScreen), findsOneWidget);

    // Large screen
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    expect(find.byType(HomeScreen), findsOneWidget);

    // Reset size
    await tester.binding.setSurfaceSize(null);
  });
} 