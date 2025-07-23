import '../features/artists/artist_demo_route.dart';
import 'package:buna_app/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/map_gallery/map_gallery_screen.dart';
import '../features/social/social_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
// import '../features/venues/venues_screen.dart';
import '../features/venues_map/venues_map_screen.dart';
import '../features/news/news_screen.dart';
import '../features/info/info_screen.dart';
import '../features/schedule/schedule_screen.dart';
import '../features/artists/artists_screen.dart';
import '../features/qr/qr_screen.dart';
import '../features/feedback/feedback_screen.dart';
import '../features/settings/feature_flags_screen.dart';
// import '../features/maps/maps_screen.dart';
import '../widgets/splash_screen.dart';
import '../widgets/home/quick_actions.dart';
import '../config/feature_flags.dart';
import '../utils/input_validator.dart';
import 'route_constants.dart';
import 'route_guards.dart';
import 'route_observer.dart';
import 'main_layout.dart';
import '../widgets/common/index.dart';
// Import the optimized home screen

/// Main router configuration for the Buna Festival app
class AppRouter {
  /// Navigate to onboarding
  static void goToOnboarding(BuildContext context) {
    context.go(AppRoutes.onboarding);
  }

  // Private constructor to prevent instantiation
  AppRouter._();

  /// The main GoRouter instance for the app
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.artistDemo,
        name: AppRoutes.artistDemoName,
        builder: (context, state) => const ArtistDemoRoute(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
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
              builder: (context, state) => const VenuesMapScreen(),
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
        ],
      ),

      // Detail routes (future implementation)
      GoRoute(
        path: AppRoutes.venueDetails,
        name: AppRoutes.venueDetailsName,
        builder: (context, state) {
          final venueId = state.pathParameters['id'];

          // Validate input with security checks
          if (!InputValidator.validateRouteParam('venueId', venueId)) {
            debugPrint(
              '[ROUTE ERROR] VenueDetails: Invalid venueId format for uri: \'${state.uri}\'',
            );
            return ErrorScreen(
              error: AppException(
                'Invalid venue ID format. Please check the URL.',
              ),
              onRetry: () => context.go(AppRoutes.venues),
            );
          }

          try {
            // TODO: Implement VenueDetailsScreen with proper venue service
            debugPrint('[ROUTE] VenueDetails: Loaded venueId=$venueId');
            return Scaffold(
              appBar: AppBar(title: Text('Venue $venueId')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.place, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('Venue Details for: $venueId'),
                    const SizedBox(height: 8),
                    const Text(
                      'Implementation in progress',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.venues),
                      child: const Text('Back to Venues'),
                    ),
                  ],
                ),
              ),
            );
          } catch (e, st) {
            debugPrint('[ROUTE ERROR] VenueDetails: $e\n$st');
            return ErrorScreen(
              error: AppException(
                'Failed to load venue details.',
                originalError: e,
                stackTrace: st,
              ),
              onRetry: () => context.go(AppRoutes.venues),
            );
          }
        },
      ),
      GoRoute(
        path: AppRoutes.eventDetails,
        name: AppRoutes.eventDetailsName,
        builder: (context, state) {
          final eventId = state.pathParameters['id'];

          // Validate input with security checks
          if (!InputValidator.validateRouteParam('eventId', eventId)) {
            debugPrint(
              '[ROUTE ERROR] EventDetails: Invalid eventId format for uri: \'${state.uri}\'',
            );
            return ErrorScreen(
              error: AppException(
                'Invalid event ID format. Please check the URL.',
              ),
              onRetry: () => context.go(AppRoutes.schedule),
            );
          }

          try {
            // TODO: Implement EventDetailsScreen with proper event service
            debugPrint('[ROUTE] EventDetails: Loaded eventId=$eventId');
            return Scaffold(
              appBar: AppBar(title: Text('Event $eventId')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.event, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('Event Details for: $eventId'),
                    const SizedBox(height: 8),
                    const Text(
                      'Implementation in progress',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.schedule),
                      child: const Text('Back to Schedule'),
                    ),
                  ],
                ),
              ),
            );
          } catch (e, st) {
            debugPrint('[ROUTE ERROR] EventDetails: $e\n$st');
            return ErrorScreen(
              error: AppException(
                'Failed to load event details.',
                originalError: e,
                stackTrace: st,
              ),
              onRetry: () => context.go(AppRoutes.schedule),
            );
          }
        },
      ),
      GoRoute(
        path: AppRoutes.newsDetails,
        name: AppRoutes.newsDetailsName,
        builder: (context, state) {
          final newsId = state.pathParameters['id'];

          // Validate input with security checks
          if (!InputValidator.validateRouteParam('newsId', newsId)) {
            debugPrint(
              '[ROUTE ERROR] NewsDetails: Invalid newsId format for uri: \'${state.uri}\'',
            );
            return ErrorScreen(
              error: AppException(
                'Invalid news ID format. Please check the URL.',
              ),
              onRetry: () => context.go(AppRoutes.news),
            );
          }

          try {
            // TODO: Implement NewsDetailsScreen with proper news service
            debugPrint('[ROUTE] NewsDetails: Loaded newsId=$newsId');
            return Scaffold(
              appBar: AppBar(title: Text('News $newsId')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.article, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('News Details for: $newsId'),
                    const SizedBox(height: 8),
                    const Text(
                      'Implementation in progress',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.news),
                      child: const Text('Back to News'),
                    ),
                  ],
                ),
              ),
            );
          } catch (e, st) {
            debugPrint('[ROUTE ERROR] NewsDetails: $e\n$st');
            return ErrorScreen(
              error: AppException(
                'Failed to load news details.',
                originalError: e,
                stackTrace: st,
              ),
              onRetry: () => context.go(AppRoutes.news),
            );
          }
        },
      ),
    ],

    // Global error handling
    errorBuilder: (context, state) {
      LogService.error('[ROUTE ERROR] Route not found', state.uri);
      return AppErrorWidget(
        message: 'Route not found: ${state.uri}',
        onRetry: () => context.go(AppRoutes.home),
      );
    },
    redirect: (context, state) => RouteGuards.handleRedirect(context, state),
    observers: [AppRouteObserver()],
  );

  /// Global route observer for analytics
  // Removed unused private declaration

  // Removed unused private declaration

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
// Removed unused private declaration
