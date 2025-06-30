import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = true;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connection status
    await _checkConnectionStatus();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });
  }

  /// Check current connection status
  Future<void> _checkConnectionStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking connectivity: $e');
      }
      _updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  /// Update connection status and notify listeners
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected =
        results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);

    if (wasConnected != _isConnected) {
      _connectionStatusController.add(_isConnected);

      if (kDebugMode) {
        print(
          '🌐 Connectivity changed: ${_isConnected ? 'Online' : 'Offline'}',
        );
      }
    }
  }

  /// Check if currently connected
  bool get isConnected => _isConnected;

  /// Check if currently offline
  bool get isOffline => !_isConnected;

  /// Get connection type
  Future<String> getConnectionType() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) return 'None';

      final result = results.first;
      switch (result) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.vpn:
          return 'VPN';
        case ConnectivityResult.bluetooth:
          return 'Bluetooth';
        case ConnectivityResult.other:
          return 'Other';
        case ConnectivityResult.none:
          return 'None';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Dispose resources
  void dispose() {
    _connectionStatusController.close();
  }
}
