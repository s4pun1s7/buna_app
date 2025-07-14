import 'dart:async';
import 'package:flutter/foundation.dart';

/// Service for managing lazy loading of components and services
class LazyLoadingService {
  static final LazyLoadingService _instance = LazyLoadingService._internal();
  factory LazyLoadingService() => _instance;
  LazyLoadingService._internal();

  // Cache for lazy-loaded components
  final Map<String, dynamic> _componentCache = {};
  final Map<String, bool> _loadingStates = {};
  final Map<String, Completer<dynamic>> _loadingCompleters = {};

  /// Load a component lazily with caching
  Future<T> loadComponent<T>(
    String key,
    Future<T> Function() loader, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    // Return cached component if available
    if (_componentCache.containsKey(key)) {
      return _componentCache[key] as T;
    }

    // If already loading, wait for existing loading operation
    if (_loadingStates[key] == true) {
      return await _loadingCompleters[key]!.future as T;
    }

    // Start loading
    _loadingStates[key] = true;
    _loadingCompleters[key] = Completer<T>();

    try {
      final component = await loader().timeout(timeout);
      _componentCache[key] = component;
      _loadingCompleters[key]!.complete(component);
      return component;
    } catch (e) {
      _loadingCompleters[key]!.completeError(e);
      rethrow;
    } finally {
      _loadingStates[key] = false;
      _loadingCompleters.remove(key);
    }
  }

  /// Preload critical components for better UX
  Future<void> preloadCriticalComponents() async {
    if (kDebugMode) {
      print('🚀 Preloading critical components...');
    }

    final preloadTasks = [
      // Preload commonly used screens
      loadComponent('home_widgets', () async {
        // Simulate preloading home screen components
        await Future.delayed(const Duration(milliseconds: 100));
        return 'home_widgets_loaded';
      }),

      loadComponent('navigation_data', () async {
        // Simulate preloading navigation data
        await Future.delayed(const Duration(milliseconds: 50));
        return 'navigation_data_loaded';
      }),
    ];

    try {
      await Future.wait(preloadTasks, eagerError: false);
      if (kDebugMode) {
        print('✅ Critical components preloaded');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Some components failed to preload: $e');
      }
    }
  }

  /// Get loading state for a component
  bool isLoading(String key) {
    return _loadingStates[key] ?? false;
  }

  /// Check if component is cached
  bool isCached(String key) {
    return _componentCache.containsKey(key);
  }

  /// Clear cache for a specific component
  void clearComponent(String key) {
    _componentCache.remove(key);
    _loadingStates.remove(key);
  }

  /// Clear all cached components
  void clearAllComponents() {
    _componentCache.clear();
    _loadingStates.clear();
    _loadingCompleters.clear();
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cached_components': _componentCache.length,
      'loading_components': _loadingStates.values
          .where((loading) => loading)
          .length,
      'total_memory_usage': _estimateMemoryUsage(),
    };
  }

  /// Estimate memory usage of cached components
  int _estimateMemoryUsage() {
    // Simple estimation - in a real app you'd want more sophisticated measurement
    return _componentCache.length * 1024; // Estimate 1KB per cached component
  }

  /// Clean up unused components to free memory
  void cleanupUnusedComponents() {
    final now = DateTime.now();

    // In a real implementation, you'd track last access times
    // For now, just limit cache size
    if (_componentCache.length > 50) {
      final keysToRemove = _componentCache.keys
          .take(_componentCache.length - 40)
          .toList();
      for (final key in keysToRemove) {
        _componentCache.remove(key);
      }

      if (kDebugMode) {
        print('🧹 Cleaned up ${keysToRemove.length} unused components');
      }
    }
  }
}
