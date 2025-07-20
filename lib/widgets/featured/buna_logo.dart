import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BunaLogo extends ConsumerWidget {
  final double size;
  const BunaLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Placeholder: Replace with your actual logo asset or widget
    return Icon(
      Icons.local_cafe,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
