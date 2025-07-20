import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'log_service.dart';

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
      case NetworkException _:
        return error.message;
      case ApiException _:
        return error.message;
      case CacheException _:
        return 'Unable to load cached data. Please refresh.';
      case ValidationException _:
        return error.message;
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Get error icon for UI
  IconData getErrorIcon(AppException error) {
    switch (error.runtimeType) {
      case NetworkException _:
        return Icons.wifi_off;
      case ApiException _:
        return Icons.error_outline;
      case CacheException _:
        return Icons.cached;
      case ValidationException _:
        return Icons.warning_amber;
      default:
        return Icons.error;
    }
  }

  /// Get error color for UI
  Color getErrorColor(AppException error) {
    switch (error.runtimeType) {
      case NetworkException _:
        return Colors.orange;
      case ApiException _:
        return Colors.red;
      case CacheException _:
        return Colors.blue;
      case ValidationException _:
        return Colors.amber;
      default:
        return Colors.red;
    }
  }

  /// Check if error is retryable
  bool isRetryable(AppException error) {
    switch (error.runtimeType) {
      case NetworkException _:
        return true;
      case ApiException _:
        final apiError = error as ApiException;
        return apiError.statusCode == null ||
            apiError.statusCode! >= 500 ||
            apiError.statusCode == 429;
      case CacheException _:
        return true;
      case ValidationException _:
        return false;
      default:
        return false;
    }
  }

  /// Log error for debugging
  void _logError(dynamic error, [StackTrace? stackTrace]) {
    LogService.error('Error occurred', error, stackTrace);
  }

  /// Report error to analytics/crash reporting service
  void reportError(AppException error) {
    LogService.error('Error reported', error);
    // In production, you might want to send this to a logging service
    // like Firebase Crashlytics, Sentry, etc.
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

  /// Retry operation with exponential backoff
  Future<T> retryWithBackoff(
    ErrorHandler errorHandler, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (attempts < maxRetries) {
      try {
        return await this;
      } catch (error, stackTrace) {
        attempts++;
        final appError = errorHandler.handleError(error, stackTrace);
        
        if (!errorHandler.isRetryable(appError) || attempts >= maxRetries) {
          throw appError;
        }

        LogService.warning('Retry attempt $attempts after error', appError);
        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }

    throw errorHandler.handleError(
      Exception('Max retries exceeded'),
      StackTrace.current,
    );
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
