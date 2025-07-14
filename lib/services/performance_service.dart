import 'package:flutter/foundation.dart';
import 'analytics_service.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<double>> _metrics = {};

  /// Start timing an operation
  void startTimer(String operation) {
    _timers[operation] = Stopwatch()..start();

    if (kDebugMode) {
      print('⏱️ Started timing: $operation');
    }
  }

  /// End timing an operation and record the duration
  void endTimer(String operation, {String? screen}) {
    final timer = _timers[operation];
    if (timer == null) return;

    timer.stop();
    final duration = timer.elapsedMilliseconds.toDouble();

    // Store metric
    _metrics.putIfAbsent(operation, () => []).add(duration);

    // Track in analytics
    AnalyticsService.logPerformance(
      metric: operation,
      value: duration,
      screen: screen,
    );

    if (kDebugMode) {
      print('⏱️ $operation took ${duration}ms');
    }

    _timers.remove(operation);
  }

  /// Get average duration for an operation
  double getAverageDuration(String operation) {
    final durations = _metrics[operation];
    if (durations == null || durations.isEmpty) return 0.0;

    return durations.reduce((a, b) => a + b) / durations.length;
  }

  /// Get all metrics
  Map<String, List<double>> get allMetrics => Map.unmodifiable(_metrics);

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    _timers.clear();
  }

  /// Track memory usage
  void trackMemoryUsage() {
    // This is a simplified version - in a real app you might use
    // platform-specific APIs to get actual memory usage
    if (kDebugMode) {
      print('💾 Memory tracking not implemented in debug mode');
    }
  }

  /// Track frame rate
  void trackFrameRate() {
    // This would typically be done with Flutter's performance overlay
    // or custom frame rate monitoring
    if (kDebugMode) {
      print('🎬 Frame rate tracking not implemented in debug mode');
    }
  }

  /// Generate performance report
  Map<String, dynamic> generateReport() {
    final report = <String, dynamic>{};

    for (final entry in _metrics.entries) {
      final operation = entry.key;
      final durations = entry.value;

      if (durations.isNotEmpty) {
        final average = durations.reduce((a, b) => a + b) / durations.length;
        final min = durations.reduce((a, b) => a < b ? a : b);
        final max = durations.reduce((a, b) => a > b ? a : b);

        report[operation] = {
          'count': durations.length,
          'average_ms': average,
          'min_ms': min,
          'max_ms': max,
        };
      }
    }

    return report;
  }
}
