/// Feature flags configuration for the Buna Festival app
/// This allows easy enabling/disabling of features during development
class FeatureFlags {
  // Private constructor to prevent instantiation
  FeatureFlags._();

  // ===== CORE FEATURES =====

  /// Enable/disable API integration
  static const bool enableApi = true;

  /// Enable/disable Firebase integration
  static const bool enableFirebase = true;

  /// Enable/disable analytics
  static const bool enableAnalytics = true;

  /// Enable/disable crash reporting
  static const bool enableCrashReporting = true;

  // ===== MAIN NAVIGATION FEATURES =====

  /// Enable/disable home screen
  static const bool enableHome = true;

  /// Enable/disable venues screen
  static const bool enableVenues = true;

  /// Enable/disable maps screen
  static const bool enableMaps = true;

  /// Enable/disable news screen
  static const bool enableNews = true;

  /// Enable/disable info screen
  static const bool enableInfo = true;

  // ===== FESTIVAL FEATURE FLAGS =====

  /// Enable/disable schedule screen
  static const bool enableSchedule = true;

  /// Enable/disable artists screen
  static const bool enableArtists = true;

  // ===== INTERACTIVE FEATURE FLAGS =====

  /// Enable/disable QR scanner
  static const bool enableQRScanner = true;

  /// Enable/disable AR experiences
  static const bool enableAR = true;

  /// Enable/disable map gallery
  static const bool enableMapGallery = true;

  /// Enable/disable social feed
  static const bool enableSocialFeed = true;

  // ===== SUPPORT FEATURE FLAGS =====

  /// Enable/disable feedback screen
  static const bool enableFeedback = true;

  /// Enable/disable help system
  static const bool enableHelp = true;

  /// Enable/disable settings screen
  static const bool enableSettings = true;

  // ===== FUNCTIONALITY FLAGS =====

  /// Enable/disable search functionality
  static const bool enableSearch = true;

  /// Enable/disable filtering
  static const bool enableFiltering = true;

  /// Enable/disable favorites
  static const bool enableFavorites = true;

  /// Enable/disable notifications
  static const bool enableNotifications = true;

  /// Enable/disable offline mode
  static const bool enableOfflineMode = true;

  /// Enable/disable caching
  static const bool enableCaching = true;

  // ===== UI/UX FLAGS =====

  /// Enable/disable animations
  static const bool enableAnimations = true;

  /// Enable/disable dark mode
  static const bool enableDarkMode = true;

  /// Enable/disable accessibility features
  static const bool enableAccessibility = true;

  /// Enable/disable haptic feedback
  static const bool enableHapticFeedback = true;

  // ===== DEVELOPMENT FLAGS =====

  /// Enable/disable debug mode
  static const bool enableDebugMode = true;

  /// Enable/disable debug logging
  static const bool enableDebugLogging = true;

  /// Enable/disable performance monitoring
  static const bool enablePerformanceMonitoring = true;

  /// Enable/disable mock data
  static const bool enableMockData = true;

  // ===== EXPERIMENTAL FEATURES =====

  /// Enable/disable experimental features
  static const bool enableExperimentalFeatures = false;

  /// Enable/disable beta features
  static const bool enableBetaFeatures = false;

  // ===== FEATURE GROUPS =====

  /// Check if all core features are enabled
  static bool get allCoreFeaturesEnabled =>
      enableHome && enableVenues && enableMaps && enableNews && enableInfo;

  /// Check if all festival features are enabled
  static bool get allFestivalFeaturesEnabled => enableSchedule && enableArtists;

  /// Check if all interactive features are enabled
  static bool get allInteractiveFeaturesEnabled =>
      enableQRScanner && enableAR && enableMapGallery && enableSocialFeed;

  /// Check if all support features are enabled
  static bool get allSupportFeaturesEnabled =>
      enableFeedback && enableHelp && enableSettings;

  // ===== UTILITY METHODS =====

  /// Get all enabled features as a list
  static List<String> get enabledFeatures {
    final features = <String>[];

    if (enableHome) features.add('Home');
    if (enableVenues) features.add('Venues');
    if (enableMaps) features.add('Maps');
    if (enableNews) features.add('News');
    if (enableInfo) features.add('Info');
    if (enableSchedule) features.add('Schedule');
    if (enableArtists) features.add('Artists');
    if (enableQRScanner) features.add('QR Scanner');
    if (enableAR) features.add('AR Experiences');
    if (enableMapGallery) features.add('Map Gallery');
    if (enableSocialFeed) features.add('Social Feed');
    if (enableFeedback) features.add('Feedback');
    if (enableHelp) features.add('Help');
    if (enableSettings) features.add('Settings');

    return features;
  }

  /// Get all disabled features as a list
  static List<String> get disabledFeatures {
    final features = <String>[];

    if (!enableHome) features.add('Home');
    if (!enableVenues) features.add('Venues');
    if (!enableMaps) features.add('Maps');
    if (!enableNews) features.add('News');
    if (!enableInfo) features.add('Info');
    if (!enableSchedule) features.add('Schedule');
    if (!enableArtists) features.add('Artists');
    if (!enableQRScanner) features.add('QR Scanner');
    if (!enableAR) features.add('AR Experiences');
    if (!enableMapGallery) features.add('Map Gallery');
    if (!enableSocialFeed) features.add('Social Feed');
    if (!enableFeedback) features.add('Feedback');
    if (!enableHelp) features.add('Help');
    if (!enableSettings) features.add('Settings');

    return features;
  }

  /// Check if a specific feature is enabled
  static bool isFeatureEnabled(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'home':
        return enableHome;
      case 'venues':
        return enableVenues;
      case 'maps':
        return enableMaps;
      case 'news':
        return enableNews;
      case 'info':
        return enableInfo;
      case 'schedule':
        return enableSchedule;
      case 'artists':
        return enableArtists;
      case 'qr scanner':
      case 'qr':
        return enableQRScanner;
      case 'ar':
      case 'ar experiences':
        return enableAR;
      case 'map gallery':
        return enableMapGallery;
      case 'social feed':
      case 'social':
        return enableSocialFeed;
      case 'feedback':
        return enableFeedback;
      case 'help':
        return enableHelp;
      case 'settings':
        return enableSettings;
      default:
        return false;
    }
  }

  /// Get feature status summary
  static Map<String, bool> get featureStatus {
    return {
      'Home': enableHome,
      'Venues': enableVenues,
      'Maps': enableMaps,
      'News': enableNews,
      'Info': enableInfo,
      'Schedule': enableSchedule,
      'Artists': enableArtists,
      'QR Scanner': enableQRScanner,
      'AR Experiences': enableAR,
      'Map Gallery': enableMapGallery,
      'Social Feed': enableSocialFeed,
      'Feedback': enableFeedback,
      'Help': enableHelp,
      'Settings': enableSettings,
    };
  }
}
