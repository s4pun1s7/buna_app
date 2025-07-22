import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// Centralized logging service for the Buna Festival app
/// 
/// This service provides consistent logging across the app with different
/// levels for debug, info, warning, and error messages. It automatically
/// configures different log levels based on the build mode.
class LogService {
  static final Logger _logger = Logger(
    filter: _CustomLogFilter(),
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log debug messages (only in debug mode)
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log info messages
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning messages
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error messages
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error messages
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log trace messages (only in debug mode)
  static void trace(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.t(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log API requests
  static void apiRequest(String method, String url, [Map<String, dynamic>? headers, dynamic body]) {
    if (kDebugMode) {
      _logger.i('🌐 API Request: $method $url', error: {
        'headers': headers,
        'body': body,
      });
    }
  }

  /// Log API responses
  static void apiResponse(String method, String url, int statusCode, [dynamic body]) {
    if (kDebugMode) {
      _logger.i('📡 API Response: $method $url ($statusCode)', error: body);
    }
  }

  /// Log performance metrics
  static void performance(String operation, Duration duration) {
    if (kDebugMode) {
      _logger.i('⚡ Performance: $operation took ${duration.inMilliseconds}ms');
    }
  }

  /// Log user actions
  static void userAction(String action, [Map<String, dynamic>? parameters]) {
    if (kDebugMode) {
      _logger.i('👤 User Action: $action', error: parameters);
    }
  }

  /// Log navigation events
  static void navigation(String from, String to) {
    if (kDebugMode) {
      _logger.i('🧭 Navigation: $from → $to');
    }
  }

  /// Log cache operations
  static void cache(String operation, String key, [dynamic data]) {
    if (kDebugMode) {
      _logger.i('💾 Cache: $operation $key', error: data);
    }
  }

  /// Log authentication events
  static void auth(String event, [Map<String, dynamic>? details]) {
    if (kDebugMode) {
      _logger.i('🔐 Auth: $event', error: details);
    }
  }
}

/// Custom log filter to control log levels based on build mode
class _CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) {
      // In debug mode, log everything
      return true;
    } else {
      // In release mode, only log warnings and errors
      return event.level.index >= Level.warning.index;
    }
  }
}

/// Extension to add logging to any class
extension LoggingExtension on Object {
  /// Get a logger instance for this class
  Logger get logger => LogService._logger;
} 