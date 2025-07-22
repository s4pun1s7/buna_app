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
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) =>
            MainLayout(child: const OptimizedHomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.venues,
        name: AppRoutes.venuesName,
        builder: (context, state) => MainLayout(child: const VenuesMapScreen()),
      ),
      GoRoute(
        path: AppRoutes.maps,
        name: AppRoutes.mapsName,
        builder: (context, state) => MainLayout(child: const VenuesMapScreen()),
      ),
      GoRoute(
        path: AppRoutes.news,
        name: AppRoutes.newsName,
        builder: (context, state) => MainLayout(child: const NewsScreen()),
      ),
      GoRoute(
        path: AppRoutes.info,
        name: AppRoutes.infoName,
        builder: (context, state) => MainLayout(child: const InfoScreen()),
      ),
      GoRoute(
        path: AppRoutes.schedule,
        name: AppRoutes.scheduleName,
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: AppRoutes.artists,
        name: AppRoutes.artistsName,
        builder: (context, state) => MainLayout(child: const ArtistsScreen()),
      ),
      GoRoute(
        path: AppRoutes.qrScanner,
        name: AppRoutes.qrScannerName,
        builder: (context, state) => MainLayout(child: const QRScreen()),
      ),
      GoRoute(
        path: AppRoutes.mapGallery,
        name: AppRoutes.mapGalleryName,
        builder: (context, state) => const MapGalleryScreen(),
      ),
      GoRoute(
        path: AppRoutes.social,
        name: AppRoutes.socialName,
        builder: (context, state) => const SocialScreen(),
      ),
      GoRoute(
        path: AppRoutes.feedback,
        name: AppRoutes.feedbackName,
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: AppRoutes.featureFlags,
        name: AppRoutes.featureFlagsName,
        builder: (context, state) => const FeatureFlagsScreen(),
      ),
    ],
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
