import 'package:flutter/material.dart';
import '../services/error_handler.dart';
import '../theme/app_theme.dart';

class ErrorScreen extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;
  final String? customMessage;

  const ErrorScreen({
    super.key,
    required this.error,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getErrorIcon(),
                size: 80,
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 24),
              Text(
                customMessage ?? error.message,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _getErrorMessage(error),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _showErrorDetails(context),
                child: const Text('Error Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    switch (error.runtimeType) {
      case NetworkException _:
        return Icons.wifi_off;
      case ApiException _:
        return Icons.error_outline;
      case CacheException _:
        return Icons.storage;
      case ValidationException _:
        return Icons.warning;
      default:
        return Icons.error;
    }
  }

  String _getErrorMessage(AppException error) {
    switch (error.runtimeType) {
      case NetworkException _:
        return 'Please check your internet connection and try again.';
      case ApiException _:
        return 'There was a problem connecting to the server. Please try again later.';
      case CacheException _:
        return 'There was a problem loading cached data. Please refresh the page.';
      case ValidationException _:
        return 'The data provided is invalid. Please check your input and try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  void _showErrorDetails(BuildContext context) {
    final scale = MediaQuery.textScaleFactorOf(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type: ${error.runtimeType}'),
              const SizedBox(height: 8),
              Text('Message: ${error.message}'),
              if (error.code != null) ...[
                const SizedBox(height: 8),
                Text('Code: ${error.code}'),
              ],
              if (error.originalError != null) ...[
                const SizedBox(height: 8),
                Text('Original Error: ${error.originalError}'),
              ],
              if (error.stackTrace != null) ...[
                const SizedBox(height: 8),
                const Text('Stack Trace:'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    error.stackTrace.toString(),
                    style: TextStyle(fontSize: 12 * scale, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Convenience widget for simple error display
class SimpleErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const SimpleErrorScreen({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      error: AppException(message),
      onRetry: onRetry,
    );
  }
}

/// Error widget for use in lists or cards
class ErrorCard extends StatelessWidget {
  final AppException error;
  final VoidCallback? onRetry;
  final double? height;

  const ErrorCard({
    super.key,
    required this.error,
    this.onRetry,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final errorHandler = ErrorHandler();
    
    return Card(
      child: Container(
        height: height ?? 120,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorHandler.getErrorIcon(error),
              color: errorHandler.getErrorColor(error),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              errorHandler.getUserFriendlyMessage(error),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (errorHandler.isRetryable(error) && onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated error dialog for displaying errors with animation.
class AnimatedErrorDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 48),
                const SizedBox(height: 16),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onCancel != null)
                      TextButton(onPressed: onCancel, child: const Text('Cancel')),
                    if (onRetry != null)
                      ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
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
