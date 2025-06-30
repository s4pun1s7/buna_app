import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/feature_flags.dart';

/// Feature flags management screen for development
class FeatureFlagsScreen extends ConsumerStatefulWidget {
  const FeatureFlagsScreen({super.key});

  @override
  ConsumerState<FeatureFlagsScreen> createState() => _FeatureFlagsScreenState();
}

class _FeatureFlagsScreenState extends ConsumerState<FeatureFlagsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfo,
            tooltip: 'Info',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildFeatureFlagsList(),
        ),
        _buildSummary(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.toggle_on,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Feature Flags',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Configure which features are enabled in the app. Changes require a restart to take effect.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _enableAllFeatures,
            icon: const Icon(Icons.check_circle),
            label: const Text('Enable All'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _disableAllFeatures,
            icon: const Icon(Icons.cancel),
            label: const Text('Disable All'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.restore),
            label: const Text('Reset'),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureFlagsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildFeatureGroup('Core Features', [
          _buildFeatureFlag('Home', FeatureFlags.enableHome, 'Enable home screen'),
          _buildFeatureFlag('Venues', FeatureFlags.enableVenues, 'Enable venues screen'),
          _buildFeatureFlag('Maps', FeatureFlags.enableMaps, 'Enable maps screen'),
          _buildFeatureFlag('News', FeatureFlags.enableNews, 'Enable news screen'),
          _buildFeatureFlag('Info', FeatureFlags.enableInfo, 'Enable info screen'),
        ]),
        const SizedBox(height: 16),
        _buildFeatureGroup('Festival Features', [
          _buildFeatureFlag('Schedule', FeatureFlags.enableSchedule, 'Enable schedule screen'),
          _buildFeatureFlag('Artists', FeatureFlags.enableArtists, 'Enable artists screen'),
          _buildFeatureFlag('Sponsors', FeatureFlags.enableSponsors, 'Enable sponsors screen'),
          _buildFeatureFlag('Ticketing', FeatureFlags.enableTicketing, 'Enable ticketing screen'),
          _buildFeatureFlag('Streaming', FeatureFlags.enableStreaming, 'Enable streaming screen'),
        ]),
        const SizedBox(height: 16),
        _buildFeatureGroup('Interactive Features', [
          _buildFeatureFlag('QR Scanner', FeatureFlags.enableQRScanner, 'Enable QR scanner'),
          _buildFeatureFlag('AR Experiences', FeatureFlags.enableAR, 'Enable AR experiences'),
          _buildFeatureFlag('Map Gallery', FeatureFlags.enableMapGallery, 'Enable map gallery'),
          _buildFeatureFlag('Social Feed', FeatureFlags.enableSocialFeed, 'Enable social feed'),
        ]),
        const SizedBox(height: 16),
        _buildFeatureGroup('Support Features', [
          _buildFeatureFlag('Feedback', FeatureFlags.enableFeedback, 'Enable feedback screen'),
          _buildFeatureFlag('Help', FeatureFlags.enableHelp, 'Enable help system'),
          _buildFeatureFlag('Settings', FeatureFlags.enableSettings, 'Enable settings screen'),
        ]),
        const SizedBox(height: 16),
        _buildFeatureGroup('Functionality', [
          _buildFeatureFlag('Search', FeatureFlags.enableSearch, 'Enable search functionality'),
          _buildFeatureFlag('Filtering', FeatureFlags.enableFiltering, 'Enable filtering'),
          _buildFeatureFlag('Favorites', FeatureFlags.enableFavorites, 'Enable favorites'),
          _buildFeatureFlag('Notifications', FeatureFlags.enableNotifications, 'Enable notifications'),
          _buildFeatureFlag('Offline Mode', FeatureFlags.enableOfflineMode, 'Enable offline mode'),
          _buildFeatureFlag('Caching', FeatureFlags.enableCaching, 'Enable caching'),
        ]),
        const SizedBox(height: 16),
        _buildFeatureGroup('UI/UX', [
          _buildFeatureFlag('Animations', FeatureFlags.enableAnimations, 'Enable animations'),
          _buildFeatureFlag('Dark Mode', FeatureFlags.enableDarkMode, 'Enable dark mode'),
          _buildFeatureFlag('Accessibility', FeatureFlags.enableAccessibility, 'Enable accessibility features'),
          _buildFeatureFlag('Haptic Feedback', FeatureFlags.enableHapticFeedback, 'Enable haptic feedback'),
        ]),
        const SizedBox(height: 16),
        _buildFeatureGroup('Development', [
          _buildFeatureFlag('Debug Mode', FeatureFlags.enableDebugMode, 'Enable debug mode'),
          _buildFeatureFlag('Debug Logging', FeatureFlags.enableDebugLogging, 'Enable debug logging'),
          _buildFeatureFlag('Performance Monitoring', FeatureFlags.enablePerformanceMonitoring, 'Enable performance monitoring'),
          _buildFeatureFlag('Mock Data', FeatureFlags.enableMockData, 'Enable mock data'),
        ]),
        const SizedBox(height: 16),
        _buildFeatureGroup('Experimental', [
          _buildFeatureFlag('Experimental Features', FeatureFlags.enableExperimentalFeatures, 'Enable experimental features'),
          _buildFeatureFlag('Beta Features', FeatureFlags.enableBetaFeatures, 'Enable beta features'),
        ]),
      ],
    );
  }

  Widget _buildFeatureGroup(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureFlag(String name, bool isEnabled, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              // Note: In a real app, you would update the feature flags here
              // For now, we'll just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$name ${value ? 'enabled' : 'disabled'} (restart required)'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final enabledCount = FeatureFlags.enabledFeatures.length;
    final totalCount = FeatureFlags.featureStatus.length;
    final disabledCount = totalCount - enabledCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$enabledCount/$totalCount enabled',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: enabledCount / totalCount,
            backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              enabledCount > totalCount / 2 
                ? Colors.green 
                : Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Enabled',
                  enabledCount,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  'Disabled',
                  disabledCount,
                  Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _enableAllFeatures() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable All Features'),
        content: const Text('This will enable all features. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All features enabled (restart required)'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Enable All'),
          ),
        ],
      ),
    );
  }

  void _disableAllFeatures() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable All Features'),
        content: const Text('This will disable all features except core navigation. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All features disabled (restart required)'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Disable All'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text('This will reset all feature flags to their default values. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature flags reset to defaults (restart required)'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feature Flags Info'),
        content: const Text(
          'Feature flags allow you to enable or disable specific features in the app.\n\n'
          '• Changes require a restart to take effect\n'
          '• Disabled features will not appear in navigation\n'
          '• This is useful for development and testing\n\n'
          'Note: This screen is only available in debug mode.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 