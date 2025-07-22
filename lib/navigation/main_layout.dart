import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation/index.dart';
import '../widgets/common/index.dart';
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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Update current index based on route
    _updateCurrentIndex();

    return Scaffold(
      appBar: _buildAppBar(),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
      endDrawer: _buildEndDrawer(),
    );
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case AppRoutes.home:
        _currentIndex = 0;
        break;
      case AppRoutes.venues:
        _currentIndex = 1;
        break;
      case AppRoutes.news:
        _currentIndex = 2;
        break;
      case AppRoutes.info:
        _currentIndex = 3;
        break;
      default:
        _currentIndex = 0;
    }
  }

  void _onNavBarTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.venues);
        break;
      case 2:
        context.go(AppRoutes.news);
        break;
      case 3:
        context.go(AppRoutes.info);
        break;
    }
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
          icon: Icon(
            themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            themeNotifier.toggleTheme();
            AnalyticsService.logEvent(
              name: 'theme_toggle',
              parameters: {
                'new_theme': themeMode == ThemeMode.dark ? 'light' : 'dark',
              },
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
    return Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        tooltip: 'More options',
      ),
    );
  }

  Widget _buildEndDrawer() {
    return const BunaDrawer();
  }

  Widget _buildBottomNavigation() {
    return BunaNavBar(currentIndex: _currentIndex, onTap: _onNavBarTap);
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
}
