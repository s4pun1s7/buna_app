import 'package:flutter/foundation.dart';

/// Utility class for validating and sanitizing user inputs
class InputValidator {
  InputValidator._();

  /// Validate route parameter IDs
  static bool isValidId(String? id) {
    if (id?.isEmpty ?? true) return false;
    
    // Allow alphanumeric characters, hyphens, and underscores
    // Prevent potential injection attacks
    final idRegex = RegExp(r'^[a-zA-Z0-9_-]{1,50}$');
    return idRegex.hasMatch(id!);
  }

  /// Sanitize route parameter
  static String? sanitizeRouteParam(String? param) {
    if (param?.isEmpty ?? true) return null;
    
    // Remove potentially harmful characters
    final sanitized = param!
        .replaceAll(RegExp(r'[<>"\'\\\x00-\x1f\x7f-\x9f]'), '')
        .trim();
    
    return sanitized.isEmpty ? null : sanitized;
  }

  /// Validate venue ID format
  static bool isValidVenueId(String? venueId) {
    return isValidId(venueId);
  }

  /// Validate event ID format
  static bool isValidEventId(String? eventId) {
    return isValidId(eventId);
  }

  /// Validate news ID format
  static bool isValidNewsId(String? newsId) {
    return isValidId(newsId);
  }

  /// Validate search query
  static bool isValidSearchQuery(String? query) {
    if (query?.isEmpty ?? true) return false;
    
    // Prevent extremely long queries and potential attacks
    if (query!.length > 100) return false;
    
    // Basic content validation
    final queryRegex = RegExp(r'^[a-zA-Z0-9\s\-_.,!?]{1,100}$');
    return queryRegex.hasMatch(query);
  }

  /// Validate and sanitize user feedback text
  static String? sanitizeFeedback(String? feedback) {
    if (feedback?.isEmpty ?? true) return null;
    
    // Limit length and remove harmful content
    if (feedback!.length > 1000) {
      feedback = feedback.substring(0, 1000);
    }
    
    // Remove potential script injection attempts
    final sanitized = feedback
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '')
        .trim();
    
    return sanitized.isEmpty ? null : sanitized;
  }

  /// Log validation failures for security monitoring
  static void _logValidationFailure(String type, String? value) {
    if (kDebugMode) {
      print('🚨 Input validation failed for $type');
    }
    // In production, this could be sent to security monitoring
  }

  /// Validate route parameter with logging
  static bool validateRouteParam(String paramName, String? value) {
    final isValid = isValidId(value);
    if (!isValid) {
      _logValidationFailure(paramName, value);
    }
    return isValid;
  }
}