import '../config/feature_flags.dart';

/// Utility class for feature flag management
class FeatureUtils {
  // Private constructor to prevent instantiation
  FeatureUtils._();

  /// Check if a feature is enabled by name
  static bool isEnabled(String featureName) {
    return FeatureFlags.isFeatureEnabled(featureName);
  }

  /// Get all enabled features
  static List<String> get enabledFeatures => FeatureFlags.enabledFeatures;

  /// Get all disabled features
  static List<String> get disabledFeatures => FeatureFlags.disabledFeatures;

  /// Get feature status summary
  static Map<String, bool> get featureStatus => FeatureFlags.featureStatus;

  /// Check if all core features are enabled
  static bool get allCoreFeaturesEnabled => FeatureFlags.allCoreFeaturesEnabled;

  /// Check if all festival features are enabled
  static bool get allFestivalFeaturesEnabled =>
      FeatureFlags.allFestivalFeaturesEnabled;

  /// Check if all interactive features are enabled
  static bool get allInteractiveFeaturesEnabled =>
      FeatureFlags.allInteractiveFeaturesEnabled;

  /// Check if all support features are enabled
  static bool get allSupportFeaturesEnabled =>
      FeatureFlags.allSupportFeaturesEnabled;

  /// Get feature group status
  static Map<String, bool> get featureGroupStatus => {
    'Core Features': allCoreFeaturesEnabled,
    'Festival Features': allFestivalFeaturesEnabled,
    'Interactive Features': allInteractiveFeaturesEnabled,
    'Support Features': allSupportFeaturesEnabled,
  };

  /// Get feature count statistics
  static Map<String, int> get featureStats {
    final status = featureStatus;
    final enabled = status.values.where((enabled) => enabled).length;
    final disabled = status.values.where((enabled) => !enabled).length;
    final total = status.length;

    return {
      'enabled': enabled,
      'disabled': disabled,
      'total': total,
      'enabledPercentage': ((enabled / total) * 100).round(),
    };
  }

  /// Get features by category
  static Map<String, List<String>> get featuresByCategory => {
    'Core': ['Home', 'Venues', 'Maps', 'News', 'Info'],
    'Festival': ['Schedule', 'Artists'],
    'Interactive': [
      'QR Scanner',
      'AR Experiences',
      'Map Gallery',
      'Social Feed',
    ],
    'Support': ['Feedback', 'Help', 'Settings'],
    'Functionality': [
      'Search',
      'Filtering',
      'Favorites',
      'Notifications',
      'Offline Mode',
      'Caching',
    ],
    'UI/UX': ['Animations', 'Dark Mode', 'Accessibility', 'Haptic Feedback'],
    'Development': [
      'Debug Mode',
      'Debug Logging',
      'Performance Monitoring',
      'Mock Data',
    ],
    'Experimental': ['Experimental Features', 'Beta Features'],
  };

  /// Get enabled features by category
  static Map<String, List<String>> get enabledFeaturesByCategory {
    final result = <String, List<String>>{};

    for (final entry in featuresByCategory.entries) {
      final enabled = entry.value
          .where((feature) => isEnabled(feature))
          .toList();
      if (enabled.isNotEmpty) {
        result[entry.key] = enabled;
      }
    }

    return result;
  }

  /// Get disabled features by category
  static Map<String, List<String>> get disabledFeaturesByCategory {
    final result = <String, List<String>>{};

    for (final entry in featuresByCategory.entries) {
      final disabled = entry.value
          .where((feature) => !isEnabled(feature))
          .toList();
      if (disabled.isNotEmpty) {
        result[entry.key] = disabled;
      }
    }

    return result;
  }

  /// Check if a feature group is fully enabled
  static bool isGroupFullyEnabled(String groupName) {
    final features = featuresByCategory[groupName];
    if (features == null) return false;

    return features.every((feature) => isEnabled(feature));
  }

  /// Check if a feature group is partially enabled
  static bool isGroupPartiallyEnabled(String groupName) {
    final features = featuresByCategory[groupName];
    if (features == null) return false;

    final enabledCount = features.where((feature) => isEnabled(feature)).length;
    return enabledCount > 0 && enabledCount < features.length;
  }

  /// Check if a feature group is fully disabled
  static bool isGroupFullyDisabled(String groupName) {
    final features = featuresByCategory[groupName];
    if (features == null) return false;

    return features.every((feature) => !isEnabled(feature));
  }

  /// Get feature group statistics
  static Map<String, Map<String, dynamic>> get groupStats {
    final result = <String, Map<String, dynamic>>{};

    for (final entry in featuresByCategory.entries) {
      final features = entry.value;
      final enabled = features.where((feature) => isEnabled(feature)).length;
      final total = features.length;

      result[entry.key] = {
        'enabled': enabled,
        'total': total,
        'disabled': total - enabled,
        'enabledPercentage': ((enabled / total) * 100).round(),
        'fullyEnabled': enabled == total,
        'partiallyEnabled': enabled > 0 && enabled < total,
        'fullyDisabled': enabled == 0,
      };
    }

    return result;
  }

  /// Get critical features (features that should always be enabled)
  static List<String> get criticalFeatures => [
    'Home',
    'Venues',
    'Maps',
    'News',
    'Info',
  ];

  /// Check if all critical features are enabled
  static bool get allCriticalFeaturesEnabled {
    return criticalFeatures.every((feature) => isEnabled(feature));
  }

  /// Get non-critical features
  static List<String> get nonCriticalFeatures {
    final allFeatures = featureStatus.keys.toList();
    return allFeatures
        .where((feature) => !criticalFeatures.contains(feature))
        .toList();
  }

  /// Get feature health status
  static String get featureHealthStatus {
    final stats = featureStats;
    final enabledPercentage = stats['enabledPercentage']!;

    if (enabledPercentage >= 90) return 'Excellent';
    if (enabledPercentage >= 75) return 'Good';
    if (enabledPercentage >= 50) return 'Fair';
    if (enabledPercentage >= 25) return 'Poor';
    return 'Critical';
  }

  /// Get feature health color
  static int get featureHealthColor {
    final status = featureHealthStatus;
    switch (status) {
      case 'Excellent':
        return 0xFF4CAF50; // Green
      case 'Good':
        return 0xFF8BC34A; // Light Green
      case 'Fair':
        return 0xFFFF9800; // Orange
      case 'Poor':
        return 0xFFFF5722; // Red
      case 'Critical':
        return 0xFFD32F2F; // Dark Red
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Validate feature configuration
  static List<String> validateConfiguration() {
    final issues = <String>[];

    // Check if critical features are disabled
    for (final feature in criticalFeatures) {
      if (!isEnabled(feature)) {
        issues.add('Critical feature "$feature" is disabled');
      }
    }

    // Check for potential conflicts
    if (isEnabled('Mock Data') && isEnabled('API')) {
      issues.add(
        'Both Mock Data and API are enabled - this may cause conflicts',
      );
    }

    // Check for missing dependencies
    if (isEnabled('Streaming') && !isEnabled('Notifications')) {
      issues.add(
        'Streaming is enabled but Notifications are disabled - users may miss live events',
      );
    }

    return issues;
  }

  /// Get feature recommendations
  static List<String> getRecommendations() {
    final recommendations = <String>[];

    if (!isEnabled('Search')) {
      recommendations.add(
        'Consider enabling Search for better user experience',
      );
    }

    if (!isEnabled('Favorites')) {
      recommendations.add(
        'Consider enabling Favorites to let users save events',
      );
    }

    if (!isEnabled('Offline Mode')) {
      recommendations.add(
        'Consider enabling Offline Mode for better connectivity handling',
      );
    }

    if (!isEnabled('Dark Mode')) {
      recommendations.add(
        'Consider enabling Dark Mode for better accessibility',
      );
    }

    return recommendations;
  }
}
