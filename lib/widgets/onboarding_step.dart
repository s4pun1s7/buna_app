import 'package:flutter/material.dart';

class OnboardingStep extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onNext;
  final bool isLast;

  const OnboardingStep({
    Key? key,
    required this.title,
    required this.description,
    required this.onNext,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
