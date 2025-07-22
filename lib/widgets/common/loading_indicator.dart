import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A reusable loading indicator widget for the Buna Festival App.
///
/// You can easily swap out the indicator style by editing this widget.
class LoadingIndicator extends ConsumerWidget {
  final String? message;
  final Color? color;
  final double? size;

  const LoadingIndicator({super.key, this.message, this.color, this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).colorScheme.primary,
            ),
            strokeWidth: 3.0,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated modal loading dialog for blocking UI during async operations.
class AnimatedLoadingDialog extends ConsumerWidget {
  final String? message;
  const AnimatedLoadingDialog({super.key, this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                ),
              ],
            ),
            child: LoadingIndicator(message: message),
          ),
        ),
      ),
    );
  }
}
