import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingStep extends ConsumerWidget {
  final String title;
  final String description;
  final VoidCallback onNext;
  final bool isLast;

  const OnboardingStep({
    super.key,
    required this.title,
    required this.description,
    required this.onNext,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text(description, textAlign: TextAlign.center),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onNext,
          child: Text(isLast ? 'Done' : 'Next'),
        ),
      ],
    );
  }
}
