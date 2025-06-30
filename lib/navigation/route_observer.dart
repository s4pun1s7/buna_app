import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

/// Custom route observer for analytics and debugging
class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackRouteChange(route, 'push', previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _trackRouteChange(route, 'pop', previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _trackRouteChange(newRoute, 'replace', oldRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _trackRouteChange(route, 'remove', previousRoute);
  }

  void _trackRouteChange(
    Route<dynamic> route,
    String action,
    Route<dynamic>? previousRoute,
  ) {
    final routeName = route.settings.name ?? 'unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'none';
    
    // Track route changes for analytics
    AnalyticsService.logEvent(
      name: 'route_change',
      parameters: {
        'action': action,
        'route': routeName,
        'previous_route': previousRouteName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    // Debug logging
    debugPrint('Route $action: $previousRouteName -> $routeName');
  }
} 