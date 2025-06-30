import 'package:flutter/material.dart';
import '../services/error_handler.dart';

class ErrorScreen extends StatelessWidget {
  final AppException? error;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;
  final String? retryText;
  final String? backText;
  final bool showBackButton;

  const ErrorScreen({
    super.key,
    this.error,
    this.message,
    this.onRetry,
    this.onBack,
    this.retryText,
    this.backText,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final errorHandler = ErrorHandler();
    final appError = error ?? AppException(message ?? 'An error occurred');
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: errorHandler.getErrorColor(appError).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  errorHandler.getErrorIcon(appError),
                  size: 60,
                  color: errorHandler.getErrorColor(appError),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Error Title
              Text(
                _getErrorTitle(appError),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: errorHandler.getErrorColor(appError),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Error Message
              Text(
                errorHandler.getUserFriendlyMessage(appError),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Action Buttons
              Column(
                children: [
                  // Retry Button
                  if (errorHandler.isRetryable(appError) && onRetry != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: Text(retryText ?? 'Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: errorHandler.getErrorColor(appError),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  
                  if (errorHandler.isRetryable(appError) && onRetry != null)
                    const SizedBox(height: 16),
                  
                  // Back Button
                  if (showBackButton)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onBack ?? () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: Text(backText ?? 'Go Back'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Additional Help (for specific error types)
              if (appError is NetworkException) _buildNetworkHelp(context),
              if (appError is ApiException) _buildApiHelp(context, appError),
              if (appError is ValidationException) _buildValidationHelp(context),
            ],
          ),
        ),
      ),
    );
  }

  String _getErrorTitle(AppException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return 'Connection Error';
      case ApiException:
        return 'Service Error';
      case CacheException:
        return 'Data Error';
      case ValidationException:
        return 'Invalid Data';
      default:
        return 'Something Went Wrong';
    }
  }

  Widget _buildNetworkHelp(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Network Tips',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Check your internet connection\n'
            '• Try switching between WiFi and mobile data\n'
            '• Restart the app if the problem persists',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiHelp(BuildContext context, ApiException error) {
    String helpText = 'The service is temporarily unavailable.';
    
    if (error.statusCode == 404) {
      helpText = 'The requested content was not found.';
    } else if (error.statusCode == 429) {
      helpText = 'Too many requests. Please wait a moment before trying again.';
    } else if (error.statusCode != null && error.statusCode! >= 500) {
      helpText = 'Our servers are experiencing issues. Please try again later.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Service Information',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            helpText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationHelp(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Data Issue',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.amber.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'The data received is not in the expected format. '
            'This might be a temporary issue with the server.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.amber.shade700,
            ),
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
      message: message,
      onRetry: onRetry,
      showBackButton: false,
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
