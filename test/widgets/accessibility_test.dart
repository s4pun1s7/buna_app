import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';

void main() {
  testWidgets('All buttons have semantic labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {},
            child: const Text('Continue'),
          ),
        ),
      ),
    );
    final semantics = tester.getSemantics(find.text('Continue'));
    expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    expect(semantics.label, 'Continue');
  });
} 