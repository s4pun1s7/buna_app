import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/route_constants.dart';
import '../config/feature_flags.dart';
import '../branding/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../common/index.dart';
import 'buna_logo.dart';
import 'loading_indicator.dart';
import 'error_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BunaDrawer extends ConsumerWidget {
  const BunaDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context, userAsync),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (FeatureFlags.allCoreFeaturesEnabled &&
                    FeatureFlags.allFestivalFeaturesEnabled)
                  const Divider(),
                if (FeatureFlags.allFestivalFeaturesEnabled)
                  _buildFestivalFeatures(context),
                if (FeatureFlags.allFestivalFeaturesEnabled &&
                    FeatureFlags.allInteractiveFeaturesEnabled)
                  const Divider(),
                if (FeatureFlags.allInteractiveFeaturesEnabled)
                  _buildInteractiveFeatures(context),
                if (FeatureFlags.allInteractiveFeaturesEnabled &&
                    FeatureFlags.allSupportFeaturesEnabled)
                  const Divider(),
                if (FeatureFlags.allSupportFeaturesEnabled)
                  _buildSupportFeatures(context),
              ],
            ),
          ),
          if (userAsync.value != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const AnimatedLoadingDialog(message: 'Signing out...'),
                  );
                  try {
                    await AuthService().signOut();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  } catch (e) {
                    if (context.mounted) Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (_) => AnimatedErrorDialog(
                        title: 'Sign-Out Error',
                        message: 'Sign-out failed. Please try again.',
                        onCancel: () => Navigator.of(context).pop(),
                        onRetry: () {
                          Navigator.of(context).pop();
                          // Retry sign out
                          if (context.mounted) {
                            // Re-run the sign out logic
                            // (recurse, but safe since user can cancel)
                            OutlinedButton.icon(
                              icon: const Icon(Icons.logout),
                              label: const Text('Sign Out'),
                              onPressed: () async {
                                // This will call this block again
                              },
                            ).onPressed!();
                          }
                        },
                      ),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, AsyncValue<User?> userAsync) {
    final user = userAsync.value;
    final isGoogle =
        user != null &&
        user.providerData.any((p) => p.providerId == 'google.com');
    final displayName = isGoogle ? user!.displayName ?? 'Google User' : 'Guest';
    final email = isGoogle ? user!.email : null;
    final avatarUrl = isGoogle ? user!.photoURL : null;
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.surface,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? Icon(Icons.person, size: 32, semanticLabel: 'User avatar')
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName ?? 'Guest',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (email != null)
                  Text(
                    email,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                if (!isGoogle)
                  Builder(
                    builder: (context) {
                      final scale = MediaQuery.textScaleFactorOf(context);
                      return Text(
                        'Guest',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14 * scale,
                        ),
                        semanticsLabel: 'Guest user',
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFestivalFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Festival Features'),
        if (FeatureFlags.enableSchedule)
          _buildDrawerItem(
            context,
            icon: Icons.schedule,
            title: 'Schedule',
            route: AppRoutes.schedule,
          ),
        if (FeatureFlags.enableArtists)
          _buildDrawerItem(
            context,
            icon: Icons.person,
            title: 'Artists',
            route: AppRoutes.artists,
          ),
        if (FeatureFlags.enableSponsors)
          _buildDrawerItem(
            context,
            icon: Icons.business,
            title: 'Sponsors',
            route: AppRoutes.sponsors,
          ),
        if (FeatureFlags.enableTicketing)
          _buildDrawerItem(
            context,
            icon: Icons.confirmation_number,
            title: 'Tickets',
            route: AppRoutes.ticketing,
          ),
        if (FeatureFlags.enableStreaming)
          _buildDrawerItem(
            context,
            icon: Icons.live_tv,
            title: 'Live Streams',
            route: AppRoutes.streaming,
          ),
      ],
    );
  }

  Widget _buildInteractiveFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Interactive Features'),
        if (FeatureFlags.enableQRScanner)
          _buildDrawerItem(
            context,
            icon: Icons.qr_code_scanner,
            title: 'QR Scanner',
            route: AppRoutes.qrScanner,
          ),
        if (FeatureFlags.enableAR)
          _buildDrawerItem(
            context,
            icon: Icons.view_in_ar,
            title: 'AR Experiences',
            route: AppRoutes.ar,
          ),
        if (FeatureFlags.enableMapGallery)
          _buildDrawerItem(
            context,
            icon: Icons.map,
            title: 'Map Gallery',
            route: AppRoutes.maps,
          ),
        if (FeatureFlags.enableSocialFeed)
          _buildDrawerItem(
            context,
            icon: Icons.share,
            title: 'Social Feed',
            route: AppRoutes.social,
          ),
      ],
    );
  }

  Widget _buildSupportFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Support'),
        if (FeatureFlags.enableFeedback)
          _buildDrawerItem(
            context,
            icon: Icons.feedback,
            title: 'Feedback',
            route: AppRoutes.feedback,
          ),
        if (FeatureFlags.enableHelp)
          _buildDrawerItem(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () => _showHelpDialog(context),
          ),
        if (FeatureFlags.enableSettings)
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => _showSettingsDialog(context),
          ),
        if (FeatureFlags.enableDebugMode)
          _buildDrawerItem(
            context,
            icon: Icons.toggle_on,
            title: 'Feature Flags',
            route: AppRoutes.featureFlags,
          ),
        _buildDrawerItem(
          context,
          icon: Icons.info_outline,
          title: 'About',
          onTap: () => _showAboutDialog(context),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Builder(
      builder: (context) {
        final scale = MediaQuery.textScaleFactorOf(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12 * scale,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
  }) {
    final isSelected =
        route != null && GoRouterState.of(context).uri.path == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
        semanticLabel: title,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (route != null) {
          context.go(route);
        } else if (onTap != null) {
          onTap();
        }
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'Need help with the Buna Festival app?\n\n'
          '• Email: support@bunafestival.com\n'
          '• Phone: +359 52 123 456\n'
          '• Visit the Info Desk at the festival\n\n'
          'We\'re here to help you have the best festival experience!',
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

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('App settings coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Buna Festival'),
        content: const Text(
          'Buna Festival 2024\n\n'
          'The premier art and culture festival in Varna, Bulgaria.\n\n'
          'Bringing together artists, musicians, performers, and art enthusiasts '
          'from around the world for three weeks of creative celebration.\n\n'
          'Version 1.0.0',
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
