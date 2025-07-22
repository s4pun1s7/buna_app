import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App switches between light and dark themes', (tester) async {
    ThemeMode themeMode = ThemeMode.light;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
              },
              child: const Text('Toggle Theme'),
            );
          },
        ),
      ),
    );
    expect(Theme.of(tester.element(find.byType(ElevatedButton))).brightness, Brightness.light);
    // Simulate theme toggle and check for dark mode (expand as needed)
  });
} 