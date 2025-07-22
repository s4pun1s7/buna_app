import 'dart:async';
import 'package:flutter/foundation.dart';
import 'log_service.dart';

/// Service for monitoring app performance metrics
class PerformanceMonitoringService {
  static final PerformanceMonitoringService _instance =
      PerformanceMonitoringService._internal();
  factory PerformanceMonitoringService() => _instance;
  PerformanceMonitoringService._internal();

  final Map<String, DateTime> _routeStartTimes = {};
  final Map<String, Duration> _routeNavigationTimes = {};
  final Map<String, int> _imageLoadCounts = {};
  final Map<String, Duration> _imageLoadTimes = {};

  Timer? _memoryMonitorTimer;
  final List<double> _memoryUsageHistory = [];

  /// Initialize performance monitoring
  void initialize() {
    if (kDebugMode) {
      LogService.info('🔍 Performance monitoring initialized');
      _startMemoryMonitoring();
    }
  }

  /// Start monitoring memory usage
  void _startMemoryMonitoring() {
    _memoryMonitorTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _collectMemoryMetrics();
    });
  }

  /// Collect memory usage metrics
  void _collectMemoryMetrics() async {
    try {
      // Get memory usage (platform-specific implementation would be needed)
      final memoryInfo = await _getMemoryUsage();
      _memoryUsageHistory.add(memoryInfo);

      // Keep only last 20 measurements (10 minutes)
      if (_memoryUsageHistory.length > 20) {
        _memoryUsageHistory.removeAt(0);
      }

      // Alert if memory usage is high
      if (memoryInfo > 200.0) {
        // MB
        if (kDebugMode) {
          LogService.warning(
            '⚠️ High memory usage detected: ${memoryInfo.toStringAsFixed(1)}MB',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        LogService.error('Failed to collect memory metrics', e);
      }
    }
  }

  /// Get current memory usage (simplified implementation)
  Future<double> _getMemoryUsage() async {
    // In a real implementation, you'd use platform channels
    // to get actual memory usage from the platform
    return _memoryUsageHistory.isNotEmpty
        ? _memoryUsageHistory.last +
              (DateTime.now().millisecondsSinceEpoch % 10 - 5)
        : 50.0 + (DateTime.now().millisecondsSinceEpoch % 20);
  }

  /// Track route navigation start
  void trackRouteNavigationStart(String routeName) {
    _routeStartTimes[routeName] = DateTime.now();
    if (kDebugMode) {
      LogService.navigation('current', routeName);
    }
  }

  /// Track route navigation completion
  void trackRouteNavigationEnd(String routeName) {
    final startTime = _routeStartTimes[routeName];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _routeNavigationTimes[routeName] = duration;
      _routeStartTimes.remove(routeName);

      if (kDebugMode) {
        LogService.performance('Navigation to $routeName', duration);
      }

      // Alert for slow navigation (> 2 seconds)
      if (duration.inMilliseconds > 2000) {
        if (kDebugMode) {
          LogService.warning(
            '⚠️ Slow navigation detected for $routeName: ${duration.inMilliseconds}ms',
          );
        }
      }
    }
  }

  /// Track image loading start
  void trackImageLoadStart(String imagePath) {
    _imageLoadCounts[imagePath] = (_imageLoadCounts[imagePath] ?? 0) + 1;
    _routeStartTimes['image_$imagePath'] = DateTime.now();
  }

  /// Track image loading completion
  void trackImageLoadEnd(String imagePath) {
    final startTime = _routeStartTimes['image_$imagePath'];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _imageLoadTimes[imagePath] = duration;
      _routeStartTimes.remove('image_$imagePath');

      if (kDebugMode) {
        LogService.performance('Image loaded: $imagePath', duration);
      }

      // Alert for slow image loading (> 1 second)
      if (duration.inMilliseconds > 1000) {
        if (kDebugMode) {
          LogService.warning(
            '⚠️ Slow image loading: $imagePath took ${duration.inMilliseconds}ms',
          );
        }
      }
    }
  }

  /// Get performance metrics summary
  Map<String, dynamic> getPerformanceMetrics() {
    final avgNavigationTime = _routeNavigationTimes.values.isNotEmpty
        ? _routeNavigationTimes.values
                  .map((d) => d.inMilliseconds)
                  .reduce((a, b) => a + b) /
              _routeNavigationTimes.length
        : 0.0;

    final avgImageLoadTime = _imageLoadTimes.values.isNotEmpty
        ? _imageLoadTimes.values
                  .map((d) => d.inMilliseconds)
                  .reduce((a, b) => a + b) /
              _imageLoadTimes.length
        : 0.0;

    final currentMemory = _memoryUsageHistory.isNotEmpty
        ? _memoryUsageHistory.last
        : 0.0;
    final avgMemory = _memoryUsageHistory.isNotEmpty
        ? _memoryUsageHistory.reduce((a, b) => a + b) /
              _memoryUsageHistory.length
        : 0.0;

    return {
      'navigation': {
        'average_time_ms': avgNavigationTime,
        'total_navigations': _routeNavigationTimes.length,
        'slow_navigations': _routeNavigationTimes.values
            .where((d) => d.inMilliseconds > 2000)
            .length,
      },
      'images': {
        'average_load_time_ms': avgImageLoadTime,
        'total_loads': _imageLoadTimes.length,
        'slow_loads': _imageLoadTimes.values
            .where((d) => d.inMilliseconds > 1000)
            .length,
        'most_loaded': _getMostLoadedImage(),
      },
      'memory': {
        'current_mb': currentMemory,
        'average_mb': avgMemory,
        'peak_mb': _memoryUsageHistory.isNotEmpty
            ? _memoryUsageHistory.reduce((a, b) => a > b ? a : b)
            : 0.0,
      },
    };
  }

  /// Get the most frequently loaded image
  String _getMostLoadedImage() {
    if (_imageLoadCounts.isEmpty) return 'none';

    var maxCount = 0;
    var mostLoaded = 'none';

    _imageLoadCounts.forEach((path, count) {
      if (count > maxCount) {
        maxCount = count;
        mostLoaded = path;
      }
    });

    return '$mostLoaded ($maxCount times)';
  }

  /// Get detailed performance report
  String getPerformanceReport() {
    final metrics = getPerformanceMetrics();

    return '''
🔍 Performance Report
====================

📱 Navigation Performance:
   Average navigation time: ${metrics['navigation']['average_time_ms'].toStringAsFixed(1)}ms
   Total navigations: ${metrics['navigation']['total_navigations']}
   Slow navigations (>2s): ${metrics['navigation']['slow_navigations']}

🖼️ Image Loading Performance:
   Average load time: ${metrics['images']['average_load_time_ms'].toStringAsFixed(1)}ms
   Total image loads: ${metrics['images']['total_loads']}
   Slow loads (>1s): ${metrics['images']['slow_loads']}
   Most loaded image: ${metrics['images']['most_loaded']}

💾 Memory Usage:
   Current usage: ${metrics['memory']['current_mb'].toStringAsFixed(1)}MB
   Average usage: ${metrics['memory']['average_mb'].toStringAsFixed(1)}MB
   Peak usage: ${metrics['memory']['peak_mb'].toStringAsFixed(1)}MB

Recommendations:
${_generateRecommendations(metrics)}
    ''';
  }

  /// Generate performance recommendations
  String _generateRecommendations(Map<String, dynamic> metrics) {
    final recommendations = <String>[];

    if (metrics['navigation']['slow_navigations'] > 0) {
      recommendations.add(
        '• Consider implementing lazy loading for slow routes',
      );
    }

    if (metrics['images']['slow_loads'] > 0) {
      recommendations.add(
        '• Optimize large images or implement progressive loading',
      );
    }

    if (metrics['memory']['peak_mb'] > 150.0) {
      recommendations.add(
        '• Monitor memory usage - consider implementing image cache cleanup',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        '• Performance looks good! Keep monitoring for regressions',
      );
    }

    return recommendations.join('\n');
  }

  /// Clear all performance data
  void clearMetrics() {
    _routeStartTimes.clear();
    _routeNavigationTimes.clear();
    _imageLoadCounts.clear();
    _imageLoadTimes.clear();
    _memoryUsageHistory.clear();

    if (kDebugMode) {
      LogService.info('🧹 Performance metrics cleared');
    }
  }

  /// Dispose of the service
  void dispose() {
    _memoryMonitorTimer?.cancel();
    clearMetrics();
  }
}
