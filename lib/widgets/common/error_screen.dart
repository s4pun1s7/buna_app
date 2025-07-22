import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/l10n/app_localizations.dart';

/// Flexible error widget for full screen, card, or dialog usage
class AppErrorWidget extends ConsumerWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String? details;
  final bool showDetailsButton;
  final bool isCard;
  final double? cardHeight;

  const AppErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.details,
    this.showDetailsButton = false,
    this.isCard = false,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: isCard ? 32 : 80,
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
        ),
        const SizedBox(height: 16),
        Text(
          message ?? l10n.error,
          style: isCard
              ? Theme.of(context).textTheme.bodyMedium
              : Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
        if (showDetailsButton && details != null) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _showErrorDetails(context, details!),
            child: Text(l10n.error),
          ),
        ],
      ],
    );
    if (isCard) {
      return Card(
        child: Container(
          height: cardHeight ?? 120,
          padding: const EdgeInsets.all(16),
          child: Center(child: content),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: content,
          ),
        ),
      );
    }
  }

  void _showErrorDetails(BuildContext context, String details) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.error),
        content: SingleChildScrollView(
          child: Text(details),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}


class AnimatedErrorDialog extends ConsumerWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  const AnimatedErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onCancel != null)
                      TextButton(
                        onPressed: onCancel,
                        child: const Text('Cancel'),
                      ),
                    if (onRetry != null)
                      ElevatedButton(
                        onPressed: onRetry,
                        child: const Text('Retry'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
