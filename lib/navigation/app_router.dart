import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/venues/venues_screen.dart';
import '../features/maps/maps_screen.dart';
import '../features/news/news_screen.dart';
import '../features/info/info_screen.dart';
import '../widgets/error_screen.dart';
import '../services/error_handler.dart';
import 'route_constants.dart';
import 'route_guards.dart';
import 'main_layout.dart';
import 'route_observer.dart';
import '../widgets/splash_screen.dart';

/// Simple home screen placeholder
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64),
            SizedBox(height: 16),
            Text(
              'Welcome to Buna Festival',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Use the navigation below to explore the festival'),
          ],
        ),
      ),
    );
  }
}

/// Main router configuration for the Buna Festival app
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// Global route observer for analytics
  static final _routeObserver = AppRouteObserver();

  /// Main router configuration
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    
    // Route observers for analytics
    observers: [_routeObserver],
    
    // Routes configuration
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Public routes (no authentication required)
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Protected routes with shell layout
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.homeName,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.venues,
            name: AppRoutes.venuesName,
            builder: (context, state) => const VenuesScreen(),
          ),
          GoRoute(
            path: AppRoutes.maps,
            name: AppRoutes.mapsName,
            builder: (context, state) => const MapsScreen(),
          ),
          GoRoute(
            path: AppRoutes.news,
            name: AppRoutes.newsName,
            builder: (context, state) => const NewsScreen(),
          ),
          GoRoute(
            path: AppRoutes.info,
            name: AppRoutes.infoName,
            builder: (context, state) => const InfoScreen(),
          ),
        ],
      ),
      
      // Detail routes (future implementation)
      GoRoute(
        path: AppRoutes.venueDetails,
        name: AppRoutes.venueDetailsName,
        builder: (context, state) {
          final venueId = state.pathParameters['id']!;
          // TODO: Implement VenueDetailsScreen
          return Scaffold(
            appBar: AppBar(title: Text('Venue $venueId')),
            body: Center(child: Text('Venue details for $venueId')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.eventDetails,
        name: AppRoutes.eventDetailsName,
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          // TODO: Implement EventDetailsScreen
          return Scaffold(
            appBar: AppBar(title: Text('Event $eventId')),
            body: Center(child: Text('Event details for $eventId')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.newsDetails,
        name: AppRoutes.newsDetailsName,
        builder: (context, state) {
          final newsId = state.pathParameters['id']!;
          // TODO: Implement NewsDetailsScreen
          return Scaffold(
            appBar: AppBar(title: Text('News $newsId')),
            body: Center(child: Text('News details for $newsId')),
          );
        },
      ),
    ],
    
    // Global error handling
    errorBuilder: (context, state) => ErrorScreen(
      error: AppException('Route not found: ${state.uri}'),
      onRetry: () => context.go(AppRoutes.home),
    ),
    
    // Route guards and redirects
    redirect: (context, state) => RouteGuards.handleRedirect(context, state),
  );

  /// Navigate to a route with parameters
  static void goToVenueDetails(BuildContext context, String venueId) {
    context.go(AppRoutes.venueDetailsPath(venueId));
  }

  static void goToEventDetails(BuildContext context, String eventId) {
    context.go(AppRoutes.eventDetailsPath(eventId));
  }

  static void goToNewsDetails(BuildContext context, String newsId) {
    context.go(AppRoutes.newsDetailsPath(newsId));
  }

  /// Navigate to main routes
  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  static void goToVenues(BuildContext context) {
    context.go(AppRoutes.venues);
  }

  static void goToMaps(BuildContext context) {
    context.go(AppRoutes.maps);
  }

  static void goToNews(BuildContext context) {
    context.go(AppRoutes.news);
  }

  static void goToInfo(BuildContext context) {
    context.go(AppRoutes.info);
  }

  /// Navigate to onboarding
  static void goToOnboarding(BuildContext context) {
    context.go(AppRoutes.onboarding);
  }

  /// Get current route name
  static String getCurrentRouteName(BuildContext context) {
    final state = GoRouterState.of(context);
    return state.name ?? 'unknown';
  }

  /// Get current route path
  static String getCurrentRoutePath(BuildContext context) {
    final state = GoRouterState.of(context);
    return state.uri.path;
  }

  /// Check if current route is a main navigation route
  static bool isMainRoute(BuildContext context) {
    final path = getCurrentRoutePath(context);
    return AppRoutes.isMainRoute(path);
  }
} 