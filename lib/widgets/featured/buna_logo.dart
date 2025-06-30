import 'package:flutter/material.dart';

class BunaLogo extends StatelessWidget {
  final double size;
  const BunaLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    // Placeholder: Replace with your actual logo asset or widget
    return Icon(
      Icons.local_cafe,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
