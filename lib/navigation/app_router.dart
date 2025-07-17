import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/venues/venues_screen.dart';
import '../features/news/news_screen.dart';
import '../features/info/info_screen.dart';
import '../features/schedule/schedule_screen.dart';
import '../features/artists/artists_screen.dart';
import '../features/qr/qr_screen.dart';
import '../features/ar/ar_screen.dart';
import '../features/map_gallery/map_gallery_screen.dart';
import '../features/social/social_screen.dart';
import '../features/feedback/feedback_screen.dart';
import '../features/settings/feature_flags_screen.dart';
import '../services/error_handler.dart';
import '../config/feature_flags.dart';
import 'route_constants.dart';
import 'route_guards.dart';
import 'main_layout.dart';
import 'route_observer.dart';
import '../widgets/common/index.dart';
import '../widgets/splash_screen.dart';
// Import the optimized home screen
import '../widgets/home/optimized_home_screen.dart';
import '../features/maps/maps_screen.dart';

/// Main router configuration for the Buna Festival app
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// Global route observer for analytics
  static final _routeObserver = AppRouteObserver();

  /// Main router configuration
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: FeatureFlags.enableDebugMode,

    // Route observers for analytics
    observers: FeatureFlags.enableAnalytics ? [_routeObserver] : [],

    // Routes configuration with lazy loading
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
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
          // Core navigation routes with lazy loading
          if (FeatureFlags.enableHome)
            GoRoute(
              path: AppRoutes.home,
              name: AppRoutes.homeName,
              builder: (context, state) =>
                  const OptimizedHomeScreen(), // Use optimized version
            ),
          if (FeatureFlags.enableVenues)
            GoRoute(
              path: AppRoutes.venues,
              name: AppRoutes.venuesName,
              builder: (context, state) => const VenuesScreen(),
            ),
          if (FeatureFlags.enableNews)
            GoRoute(
              path: AppRoutes.news,
              name: AppRoutes.newsName,
              builder: (context, state) => const NewsScreen(),
            ),
          if (FeatureFlags.enableInfo)
            GoRoute(
              path: AppRoutes.info,
              name: AppRoutes.infoName,
              builder: (context, state) => const InfoScreen(),
            ),

          // Festival feature routes with lazy loading
          if (FeatureFlags.enableSchedule)
            GoRoute(
              path: AppRoutes.schedule,
              name: AppRoutes.scheduleName,
              builder: (context, state) => const ScheduleScreen(),
            ),
          if (FeatureFlags.enableArtists)
            GoRoute(
              path: AppRoutes.artists,
              name: AppRoutes.artistsName,
              builder: (context, state) => const ArtistsScreen(),
            ),

          // Interactive feature routes with lazy loading
          if (FeatureFlags.enableQRScanner)
            GoRoute(
              path: AppRoutes.qrScanner,
              name: AppRoutes.qrScannerName,
              builder: (context, state) {
                // Lazy load QR screen to reduce initial bundle size
                return FutureBuilder(
                  future: _loadQRScreen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? const _LoadingScreen();
                    }
                    return const _LoadingScreen();
                  },
                );
              },
            ),
          if (FeatureFlags.enableAR)
            GoRoute(
              path: AppRoutes.ar,
              name: AppRoutes.arName,
              builder: (context, state) {
                // Lazy load AR screen to reduce initial bundle size
                return FutureBuilder(
                  future: _loadARScreen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? const _LoadingScreen();
                    }
                    return const _LoadingScreen();
                  },
                );
              },
            ),
          if (FeatureFlags.enableMapGallery)
            GoRoute(
              path: AppRoutes.mapGallery,
              name: AppRoutes.mapGalleryName,
              builder: (context, state) {
                // Lazy load map gallery to reduce initial bundle size
                return FutureBuilder(
                  future: _loadMapGalleryScreen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? const _LoadingScreen();
                    }
                    return const _LoadingScreen();
                  },
                );
              },
            ),
          if (FeatureFlags.enableSocialFeed)
            GoRoute(
              path: AppRoutes.social,
              name: AppRoutes.socialName,
              builder: (context, state) {
                // Lazy load social screen to reduce initial bundle size
                return FutureBuilder(
                  future: _loadSocialScreen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? const _LoadingScreen();
                    }
                    return const _LoadingScreen();
                  },
                );
              },
            ),

          // Support feature routes
          if (FeatureFlags.enableFeedback)
            GoRoute(
              path: AppRoutes.feedback,
              name: AppRoutes.feedbackName,
              builder: (context, state) => const FeedbackScreen(),
            ),

          // Development routes (only in debug mode)
          if (FeatureFlags.enableDebugMode)
            GoRoute(
              path: AppRoutes.featureFlags,
              name: AppRoutes.featureFlagsName,
              builder: (context, state) => const FeatureFlagsScreen(),
            ),

          // New feature routes
          if (FeatureFlags.enableMaps)
            GoRoute(
              path: AppRoutes.maps,
              name: AppRoutes.mapsName,
              builder: (context, state) {
                // Lazy load MapsScreen to reduce initial bundle size
                return FutureBuilder(
                  future: Future.value(const MapsScreen()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? const _LoadingScreen();
                    }
                    return const _LoadingScreen();
                  },
                );
              },
            ),
        ],
      ),

      // Detail routes (future implementation)
      GoRoute(
        path: AppRoutes.venueDetails,
        name: AppRoutes.venueDetailsName,
        builder: (context, state) {
          final venueId = state.pathParameters['id'];
          if (venueId == null || venueId.isEmpty) {
            debugPrint(
              '[ROUTE ERROR] VenueDetails: Missing venueId for uri: \'${state.uri}\'',
            );
            return AppErrorWidget(message: 'Venue ID is missing from the route.', onRetry: () => context.go(AppRoutes.venues));
          }
          try {
            debugPrint('[ROUTE] VenueDetails: Loaded venueId=$venueId');
            return Scaffold(
              appBar: AppBar(title: Text('Venue $venueId')),
              body: Center(child: Text('Venue details for $venueId')),
            );
          } catch (e, st) {
            debugPrint('[ROUTE ERROR] VenueDetails: $e\n$st');
            return AppErrorWidget(message: 'Failed to load venue details.', onRetry: () => context.go(AppRoutes.venues));
          }
        },
      ),
      GoRoute(
        path: AppRoutes.eventDetails,
        name: AppRoutes.eventDetailsName,
        builder: (context, state) {
          final eventId = state.pathParameters['id'];
          if (eventId == null || eventId.isEmpty) {
            debugPrint(
              '[ROUTE ERROR] EventDetails: Missing eventId for uri: \'${state.uri}\'',
            );
            return AppErrorWidget(message: 'Event ID is missing from the route.', onRetry: () => context.go(AppRoutes.schedule));
          }
          try {
            debugPrint('[ROUTE] EventDetails: Loaded eventId=$eventId');
            return Scaffold(
              appBar: AppBar(title: Text('Event $eventId')),
              body: Center(child: Text('Event details for $eventId')),
            );
          } catch (e, st) {
            debugPrint('[ROUTE ERROR] EventDetails: $e\n$st');
            return AppErrorWidget(message: 'Failed to load event details.', onRetry: () => context.go(AppRoutes.schedule));
          }
        },
      ),
      GoRoute(
        path: AppRoutes.newsDetails,
        name: AppRoutes.newsDetailsName,
        builder: (context, state) {
          final newsId = state.pathParameters['id'];
          if (newsId == null || newsId.isEmpty) {
            debugPrint(
              '[ROUTE ERROR] NewsDetails: Missing newsId for uri: \'${state.uri}\'',
            );
            return AppErrorWidget(message: 'News ID is missing from the route.', onRetry: () => context.go(AppRoutes.news));
          }
          try {
            debugPrint('[ROUTE] NewsDetails: Loaded newsId=$newsId');
            return Scaffold(
              appBar: AppBar(title: Text('News $newsId')),
              body: Center(child: Text('News details for $newsId')),
            );
          } catch (e, st) {
            debugPrint('[ROUTE ERROR] NewsDetails: $e\n$st');
            return AppErrorWidget(message: 'Failed to load news details.', onRetry: () => context.go(AppRoutes.news));
          }
        },
      ),
    ],

    // Global error handling
    errorBuilder: (context, state) {
      debugPrint('[ROUTE ERROR] Route not found: ${state.uri}');
      return AppErrorWidget(message: 'Route not found: ${state.uri}', onRetry: () => context.go(AppRoutes.home));
    },

    // Route guards and redirects
    redirect: (context, state) => RouteGuards.handleRedirect(context, state),
  );

  // Lazy loading functions for heavy screens
  static Future<Widget> _loadQRScreen() async {
    // Simulate loading time and return the screen
    await Future.delayed(const Duration(milliseconds: 100));
    return const QRScreen();
  }

  static Future<Widget> _loadARScreen() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const ARScreen();
  }

  static Future<Widget> _loadMapGalleryScreen() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const MapGalleryScreen();
  }

  static Future<Widget> _loadSocialScreen() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const SocialScreen();
  }

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
    if (FeatureFlags.enableHome) {
      context.go(AppRoutes.home);
    }
  }

  static void goToVenues(BuildContext context) {
    if (FeatureFlags.enableVenues) {
      context.go(AppRoutes.venues);
    }
  }

  static void goToNews(BuildContext context) {
    if (FeatureFlags.enableNews) {
      context.go(AppRoutes.news);
    }
  }

  static void goToInfo(BuildContext context) {
    if (FeatureFlags.enableInfo) {
      context.go(AppRoutes.info);
    }
  }

  /// Navigate to new feature routes
  static void goToSchedule(BuildContext context) {
    if (FeatureFlags.enableSchedule) {
      context.go('/schedule');
    }
  }

  static void goToArtists(BuildContext context) {
    if (FeatureFlags.enableArtists) {
      context.go('/artists');
    }
  }

  static void goToQR(BuildContext context) {
    if (FeatureFlags.enableQRScanner) {
      context.go('/qr');
    }
  }

  static void goToAR(BuildContext context) {
    if (FeatureFlags.enableAR) {
      context.go('/ar');
    }
  }

  static void goToMapGallery(BuildContext context) {
    if (FeatureFlags.enableMapGallery) {
      context.go('/map-gallery');
    }
  }

  static void goToSocial(BuildContext context) {
    if (FeatureFlags.enableSocialFeed) {
      context.go('/social');
    }
  }

  static void goToFeedback(BuildContext context) {
    if (FeatureFlags.enableFeedback) {
      context.go('/feedback');
    }
  }

  static void goToFeatureFlags(BuildContext context) {
    if (FeatureFlags.enableDebugMode) {
      context.go('/feature-flags');
    }
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

/// Loading screen widget for lazy-loaded routes
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
