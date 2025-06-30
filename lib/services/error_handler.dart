import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom exception types for better error handling
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException(this.message, {this.code, this.originalError, this.stackTrace});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class ApiException extends AppException {
  final int? statusCode;
  final String? endpoint;

  ApiException(
    super.message, {
    this.statusCode,
    this.endpoint,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class CacheException extends AppException {
  CacheException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(
    super.message, {
    this.fieldErrors,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Centralized error handling service
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Handle and categorize errors
  AppException handleError(dynamic error, [StackTrace? stackTrace]) {
    // Log the error for debugging
    _logError(error, stackTrace);

    if (error is AppException) {
      return error;
    }

    if (error is SocketException) {
      return NetworkException(
        'No internet connection. Please check your network and try again.',
        code: 'NETWORK_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is HttpException) {
      return NetworkException(
        'Network request failed. Please try again later.',
        code: 'HTTP_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return ValidationException(
        'Invalid data format received from server.',
        code: 'FORMAT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is TimeoutException) {
      return NetworkException(
        'Request timed out. Please try again.',
        code: 'TIMEOUT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Generic error handling
    return AppException(
      'An unexpected error occurred. Please try again.',
      code: 'UNKNOWN_ERROR',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Handle API-specific errors
  ApiException handleApiError(
    dynamic error,
    String endpoint, [
    int? statusCode,
  ]) {
    _logError(error);

    if (error is ApiException) {
      return error;
    }

    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return ApiException(
            'Invalid request. Please check your input and try again.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'BAD_REQUEST',
            originalError: error,
          );
        case 401:
          return ApiException(
            'Authentication required. Please log in again.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'UNAUTHORIZED',
            originalError: error,
          );
        case 403:
          return ApiException(
            'Access denied. You don\'t have permission to access this resource.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'FORBIDDEN',
            originalError: error,
          );
        case 404:
          return ApiException(
            'The requested resource was not found.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'NOT_FOUND',
            originalError: error,
          );
        case 429:
          return ApiException(
            'Too many requests. Please wait a moment and try again.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'RATE_LIMITED',
            originalError: error,
          );
        case 500:
          return ApiException(
            'Server error. Please try again later.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'SERVER_ERROR',
            originalError: error,
          );
        case 502:
        case 503:
        case 504:
          return ApiException(
            'Service temporarily unavailable. Please try again later.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'SERVICE_UNAVAILABLE',
            originalError: error,
          );
        default:
          return ApiException(
            'Network error occurred. Please try again.',
            statusCode: statusCode,
            endpoint: endpoint,
            code: 'HTTP_ERROR',
            originalError: error,
          );
      }
    }

    return ApiException(
      'API request failed. Please try again.',
      endpoint: endpoint,
      code: 'API_ERROR',
      originalError: error,
    );
  }

  /// Get user-friendly error message
  String getUserFriendlyMessage(AppException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return error.message;
      case ApiException:
        return error.message;
      case CacheException:
        return 'Unable to load cached data. Please refresh.';
      case ValidationException:
        return error.message;
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Get error icon for UI
  IconData getErrorIcon(AppException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return Icons.wifi_off;
      case ApiException:
        return Icons.error_outline;
      case CacheException:
        return Icons.cached;
      case ValidationException:
        return Icons.warning_amber;
      default:
        return Icons.error;
    }
  }

  /// Get error color for UI
  Color getErrorColor(AppException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return Colors.orange;
      case ApiException:
        return Colors.red;
      case CacheException:
        return Colors.blue;
      case ValidationException:
        return Colors.amber;
      default:
        return Colors.red;
    }
  }

  /// Check if error is retryable
  bool isRetryable(AppException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return true;
      case ApiException:
        final apiError = error as ApiException;
        return apiError.statusCode == null ||
            apiError.statusCode! >= 500 ||
            apiError.statusCode == 429;
      case CacheException:
        return true;
      case ValidationException:
        return false;
      default:
        return false;
    }
  }

  /// Log error for debugging
  void _logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('Error: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
    // In production, you might want to send this to a logging service
    // like Firebase Crashlytics, Sentry, etc.
  }

  /// Report error to analytics/crash reporting service
  void reportError(AppException error) {
    // Implement error reporting to your preferred service
    // Example: Firebase Crashlytics, Sentry, etc.
    if (kDebugMode) {
      print('Reporting error: ${error.message}');
    }
  }
}

/// Extension to add error handling to Future
extension FutureErrorHandling<T> on Future<T> {
  Future<T> handleError(ErrorHandler errorHandler) async {
    try {
      return await this;
    } catch (error, stackTrace) {
      throw errorHandler.handleError(error, stackTrace);
    }
  }
}

/// Extension to add error handling to Stream
extension StreamErrorHandling<T> on Stream<T> {
  Stream<T> handleErrorWith(ErrorHandler errorHandler) {
    return handleError((error, stackTrace) {
      throw errorHandler.handleError(error, stackTrace);
    });
  }
}
