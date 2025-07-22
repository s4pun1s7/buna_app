import 'log_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Track screen views
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (kDebugMode) {
      LogService.debug('📊 Screen View: $screenName');
      return;
    }

    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Track user actions
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (kDebugMode) {
      LogService.debug('📊 Event: $name ${parameters ?? {}}');
      return;
    }

    await _analytics.logEvent(name: name, parameters: parameters);
  }

  /// Track custom events for festival app
  static Future<void> logFestivalEvent({
    required String eventName,
    String? venueName,
    String? eventType,
    String? action,
  }) async {
    await logEvent(
      name: 'festival_$eventName',
      parameters: {
        'venue_name': venueName ?? '',
        'event_type': eventType ?? '',
        'action': action ?? '',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track news interactions
  static Future<void> logNewsInteraction({
    required String action,
    String? articleTitle,
    String? category,
  }) async {
    await logEvent(
      name: 'news_interaction',
      parameters: {
        'action': action,
        'article_title': articleTitle ?? '',
        'category': category ?? '',
      },
    );
  }

  /// Track venue interactions
  static Future<void> logVenueInteraction({
    required String action,
    String? venueName,
    String? venueType,
  }) async {
    await logEvent(
      name: 'venue_interaction',
      parameters: {
        'action': action,
        'venue_name': venueName ?? '',
        'venue_type': venueType ?? '',
      },
    );
  }

  /// Track search queries
  static Future<void> logSearch({
    required String query,
    String? category,
    int? resultCount,
  }) async {
    await logEvent(
      name: 'search',
      parameters: {
        'query': query,
        'category': category ?? '',
        'result_count': resultCount ?? 0,
      },
    );
  }

  /// Track app performance
  static Future<void> logPerformance({
    required String metric,
    required double value,
    String? screen,
  }) async {
    await logEvent(
      name: 'performance',
      parameters: {'metric': metric, 'value': value, 'screen': screen ?? ''},
    );
  }

  /// Track errors
  static Future<void> logError({
    required String error,
    String? screen,
    String? action,
  }) async {
    await logEvent(
      name: 'app_error',
      parameters: {
        'error': error,
        'screen': screen ?? '',
        'action': action ?? '',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
