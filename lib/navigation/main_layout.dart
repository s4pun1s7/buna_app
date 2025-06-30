import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/buna_nav_bar.dart';
import '../widgets/language_toggle.dart';
import '../providers/theme_provider.dart';
import '../services/analytics_service.dart';
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _getTitle(),
      actions: [
        _buildThemeToggle(),
        _buildLanguageToggle(),
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

  Widget _buildBottomNavigation() {
    return BunaNavBar(
      currentIndex: _getCurrentIndex(),
      onTap: _onNavTap,
    );
  }

  int _getCurrentIndex() {
    final location = GoRouterState.of(context).uri.path;
    return AppRoutes.getRouteIndex(location);
  }

  void _onNavTap(int index) {
    final routes = [
      AppRoutes.home,
      AppRoutes.venues,
      AppRoutes.maps,
      AppRoutes.news,
      AppRoutes.info,
    ];
    
    if (index < routes.length) {
      context.go(routes[index]);
      
      // Track navigation
      final screenNames = ['home', 'venues', 'maps', 'news', 'info'];
      AnalyticsService.logScreenView(screenName: screenNames[index]);
    }
  }

  Widget? _buildFloatingActionButton() {
    final location = GoRouterState.of(context).uri.path;
    
    switch (location) {
      case AppRoutes.venues:
        return FloatingActionButton(
          onPressed: () {
            // Navigate to map with venues
            context.go(AppRoutes.maps);
            AnalyticsService.logEvent(name: 'fab_venues_to_map');
          },
          tooltip: 'View on Map',
          child: const Icon(Icons.map),
        );
      case AppRoutes.maps:
        return FloatingActionButton(
          onPressed: () {
            // Center map on user location
            AnalyticsService.logEvent(name: 'fab_center_location');
          },
          tooltip: 'My Location',
          child: const Icon(Icons.my_location),
        );
      case AppRoutes.news:
        return FloatingActionButton(
          onPressed: () {
            // Refresh news
            AnalyticsService.logEvent(name: 'fab_refresh_news');
          },
          tooltip: 'Refresh News',
          child: const Icon(Icons.refresh),
        );
      default:
        return null;
    }
  }
} 