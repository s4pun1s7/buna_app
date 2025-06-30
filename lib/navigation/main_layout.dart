import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/buna_nav_bar.dart';
import '../widgets/language_toggle.dart';
import '../providers/theme_provider.dart';
import '../services/analytics_service.dart';
import '../features/venues/schedule_screen.dart';
import '../navigation/route_guards.dart';
import 'route_constants.dart';

/// Main layout wrapper for protected routes
class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
      endDrawer: _buildEndDrawer(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _getTitle(),
      actions: [
        _buildThemeToggle(),
        _buildLanguageToggle(),
        _buildMenuButton(),
      ],
    );
  }

  Widget _getTitle() {
    final location = GoRouterState.of(context).uri.path;
    return Text(AppRoutes.getRouteTitle(location));
  }

  Widget _buildThemeToggle() {
    return Consumer(
      builder: (context, ref, child) {
        final themeMode = ref.watch(themeProvider);
        final themeNotifier = ref.watch(themeProvider.notifier);
        
        return IconButton(
          icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            themeNotifier.toggleTheme();
            AnalyticsService.logEvent(
              name: 'theme_toggle',
              parameters: {'new_theme': themeMode == ThemeMode.dark ? 'light' : 'dark'},
            );
          },
          tooltip: 'Toggle theme',
        );
      },
    );
  }

  Widget _buildLanguageToggle() {
    return const LanguageToggle();
  }

  Widget _buildMenuButton() {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      tooltip: 'More options',
    );
  }

  Widget _buildEndDrawer() {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerSection(
                  title: 'Festival Features',
                  items: [
                    _buildDrawerItem(
                      icon: Icons.schedule,
                      title: 'Schedule',
                      subtitle: 'View your festival schedule',
                      onTap: () => _navigateToSchedule(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.favorite,
                      title: 'Favorites',
                      subtitle: 'Manage your favorites',
                      onTap: () => _navigateToFavorites(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.qr_code,
                      title: 'QR Scanner',
                      subtitle: 'Scan festival QR codes',
                      onTap: () => _navigateToQRScanner(context),
                    ),
                  ],
                ),
                _buildDrawerSection(
                  title: 'Settings & Tools',
                  items: [
                    _buildDrawerItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      subtitle: 'App preferences and configuration',
                      onTap: () => _navigateToSettings(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      onTap: () => _navigateToNotifications(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: () => _navigateToHelp(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App information and version',
                      onTap: () => _navigateToAbout(context),
                    ),
                  ],
                ),
                _buildDrawerSection(
                  title: 'Developer Tools',
                  items: [
                    _buildDrawerItem(
                      icon: Icons.bug_report,
                      title: 'Debug Info',
                      subtitle: 'View debug information',
                      onTap: () => _navigateToDebugInfo(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.refresh,
                      title: 'Reset Onboarding',
                      subtitle: 'Reset onboarding status (dev)',
                      onTap: () => _resetOnboarding(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.clear_all,
                      title: 'Clear Cache',
                      subtitle: 'Clear app cache and data',
                      onTap: () => _clearCache(context),
                    ),
                  ],
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Reset App',
                  subtitle: 'Reset all app data',
                  onTap: () => _resetApp(context),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(
              Icons.festival,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Buna Festival',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'More Options',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...items,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = isDestructive ? colorScheme.error : colorScheme.onSurface;
    final textColor = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.7),
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  Widget _buildBottomNavigation() {
    return const BunaNavBar();
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Quick action - could be search, add to schedule, etc.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quick action - coming soon!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  // Navigation methods for drawer items
  void _navigateToSchedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScheduleScreen()),
    );
  }

  void _navigateToFavorites(BuildContext context) {
    // TODO: Implement FavoritesScreen
    _showComingSoon(context, 'Favorites');
  }

  void _navigateToQRScanner(BuildContext context) {
    // TODO: Implement QRScannerScreen
    _showComingSoon(context, 'QR Scanner');
  }

  void _navigateToSettings(BuildContext context) {
    // TODO: Implement SettingsScreen
    _showComingSoon(context, 'Settings');
  }

  void _navigateToNotifications(BuildContext context) {
    // TODO: Implement NotificationsScreen
    _showComingSoon(context, 'Notifications');
  }

  void _navigateToHelp(BuildContext context) {
    // TODO: Implement HelpScreen
    _showComingSoon(context, 'Help & Support');
  }

  void _navigateToAbout(BuildContext context) {
    // TODO: Implement AboutScreen
    _showComingSoon(context, 'About');
  }

  void _navigateToDebugInfo(BuildContext context) {
    // TODO: Implement DebugInfoScreen
    _showComingSoon(context, 'Debug Info');
  }

  void _resetOnboarding(BuildContext context) async {
    await RouteGuards.resetOnboardingStatus();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Onboarding reset! Restart the app to see onboarding again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _clearCache(BuildContext context) {
    // TODO: Implement cache clearing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will reset all app data including favorites, settings, and onboarding status. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // TODO: Implement full app reset
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('App reset! Please restart the app.'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 