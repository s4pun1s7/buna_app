import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodApp extends ConsumerWidget {
  final Widget child;
  const RiverpodApp({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(child: child);
  }
}
