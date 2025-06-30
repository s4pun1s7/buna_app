import 'dart:async';
import 'package:flutter/material.dart';

/// A utility class for debouncing function calls
class Debouncer {
  Timer? _timer;
  final Duration _delay;

  /// Create a debouncer with the specified delay
  Debouncer({Duration? delay}) : _delay = delay ?? const Duration(milliseconds: 500);

  /// Debounce a function call
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(_delay, action);
  }

  /// Cancel the current timer
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Check if the debouncer is active
  bool get isActive => _timer?.isActive ?? false;

  /// Dispose of the debouncer
  void dispose() {
    cancel();
  }
}

/// A debouncer specifically for search operations
class SearchDebouncer extends Debouncer {
  SearchDebouncer() : super(delay: const Duration(milliseconds: 300));
}

/// A debouncer for UI updates
class UIDebouncer extends Debouncer {
  UIDebouncer() : super(delay: const Duration(milliseconds: 100));
}

/// A debouncer for API calls
class APIDebouncer extends Debouncer {
  APIDebouncer() : super(delay: const Duration(milliseconds: 1000));
}

/// A debouncer for scroll events
class ScrollDebouncer extends Debouncer {
  ScrollDebouncer() : super(delay: const Duration(milliseconds: 150));
} 