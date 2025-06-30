/// Centralized route constants for the Buna Festival app
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Public routes (no authentication required)
  static const String onboarding = '/onboarding';
  
  // Main app routes (protected by shell layout)
  static const String home = '/home';
  static const String venues = '/venues';
  static const String maps = '/maps';
  static const String news = '/news';
  static const String info = '/info';
  
  // Detail routes with parameters
  static const String venueDetails = '/venue/:id';
  static const String eventDetails = '/event/:id';
  static const String newsDetails = '/news/:id';
  
  // Utility routes
  static const String error = '/error';
  static const String notFound = '/404';
  
  // Route names for navigation
  static const String onboardingName = 'onboarding';
  static const String homeName = 'home';
  static const String venuesName = 'venues';
  static const String mapsName = 'maps';
  static const String newsName = 'news';
  static const String infoName = 'info';
  static const String venueDetailsName = 'venue-details';
  static const String eventDetailsName = 'event-details';
  static const String newsDetailsName = 'news-details';
  
  /// Get route path with parameters
  static String venueDetailsPath(String id) => '/venue/$id';
  static String eventDetailsPath(String id) => '/event/$id';
  static String newsDetailsPath(String id) => '/news/$id';
  
  /// Check if route requires authentication
  static bool requiresAuth(String path) {
    final publicRoutes = [onboarding, error, notFound];
    return !publicRoutes.contains(path);
  }
  
  /// Check if route is a main navigation route
  static bool isMainRoute(String path) {
    final mainRoutes = [home, venues, maps, news, info];
    return mainRoutes.contains(path);
  }
  
  /// Get route index for bottom navigation
  static int getRouteIndex(String path) {
    switch (path) {
      case home:
        return 0;
      case venues:
        return 1;
      case maps:
        return 2;
      case news:
        return 3;
      case info:
        return 4;
      default:
        return 0;
    }
  }
  
  /// Get route title
  static String getRouteTitle(String path) {
    switch (path) {
      case home:
        return 'Buna Festival';
      case venues:
        return 'Venues';
      case maps:
        return 'Map';
      case news:
        return 'News';
      case info:
        return 'Info';
      case onboarding:
        return 'Welcome';
      default:
        return 'Buna Festival';
    }
  }
} 