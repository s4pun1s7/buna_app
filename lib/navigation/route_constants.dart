/// Centralized route constants for the Buna Festival app
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Public routes (no authentication required)
  static const String onboarding = '/onboarding';
  static const String splash = '/splash';

  // Main app routes (protected by shell layout)
  static const String home = '/home';
  static const String venues = '/venues';
  static const String maps = '/maps';
  static const String news = '/news';
  static const String info = '/info';

  // Festival feature routes
  static const String schedule = '/schedule';
  static const String artists = '/artists';
  static const String sponsors = '/sponsors';
  static const String ticketing = '/ticketing';
  static const String streaming = '/streaming';

  // Interactive feature routes
  static const String qrScanner = '/qr';
  static const String ar = '/ar';
  static const String mapGallery = '/map-gallery';
  static const String social = '/social';

  // Support feature routes
  static const String feedback = '/feedback';
  static const String featureFlags = '/feature-flags';

  // Detail routes with parameters
  static const String venueDetails = '/venue/:id';
  static const String eventDetails = '/event/:id';
  static const String newsDetails = '/news/:id';

  // Utility routes
  static const String error = '/error';
  static const String notFound = '/404';

  // Route names for navigation
  static const String onboardingName = 'onboarding';
  static const String splashName = 'splash';
  static const String homeName = 'home';
  static const String venuesName = 'venues';
  static const String mapsName = 'maps';
  static const String newsName = 'news';
  static const String infoName = 'info';
  static const String scheduleName = 'schedule';
  static const String artistsName = 'artists';
  static const String sponsorsName = 'sponsors';
  static const String ticketingName = 'ticketing';
  static const String streamingName = 'streaming';
  static const String qrScannerName = 'qr';
  static const String arName = 'ar';
  static const String mapGalleryName = 'map-gallery';
  static const String socialName = 'social';
  static const String feedbackName = 'feedback';
  static const String featureFlagsName = 'feature-flags';
  static const String venueDetailsName = 'venue-details';
  static const String eventDetailsName = 'event-details';
  static const String newsDetailsName = 'news-details';

  /// Get route path with parameters
  static String venueDetailsPath(String id) => '/venue/$id';
  static String eventDetailsPath(String id) => '/event/$id';
  static String newsDetailsPath(String id) => '/news/$id';

  /// Check if route requires authentication
  static bool requiresAuth(String path) {
    final publicRoutes = [onboarding, splash, error, notFound];
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
      case schedule:
        return 'Schedule';
      case artists:
        return 'Artists';
      case sponsors:
        return 'Sponsors';
      case ticketing:
        return 'Tickets';
      case streaming:
        return 'Live Streams';
      case qrScanner:
        return 'QR Scanner';
      case ar:
        return 'AR Experiences';
      case mapGallery:
        return 'Map Gallery';
      case social:
        return 'Social Feed';
      case feedback:
        return 'Feedback';
      case featureFlags:
        return 'Feature Flags';
      case onboarding:
        return 'Welcome';
      case splash:
        return 'Loading';
      default:
        return 'Buna Festival';
    }
  }
}
