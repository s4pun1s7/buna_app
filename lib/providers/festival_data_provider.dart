import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/error_handler.dart';
import '../models/festival_data.dart';

/// Provider for news articles
final newsProvider = FutureProvider.family<List<NewsArticle>, int>((ref, page) async {
  return await ApiService.fetchNews(page: page);
});

/// Provider for festival events
final eventsProvider = FutureProvider.family<List<FestivalEvent>, int>((ref, page) async {
  return await ApiService.fetchEvents(page: page);
});

/// Provider for venues
final venuesProvider = FutureProvider<List<Venue>>((ref) async {
  return await ApiService.fetchVenues();
});

/// Provider for festival information
final festivalInfoProvider = FutureProvider<FestivalInfo>((ref) async {
  return await ApiService.fetchFestivalInfo();
});

/// Provider for search results
final searchProvider = FutureProvider.family<SearchResults, String>((ref, query) async {
  return await ApiService.search(query);
});

/// Provider for refreshing data
final refreshProvider = StateProvider<bool>((ref) => false);

/// Provider for managing news state
final newsStateProvider = StateNotifierProvider<NewsStateNotifier, AsyncValue<List<NewsArticle>>>((ref) {
  return NewsStateNotifier();
});

class NewsStateNotifier extends StateNotifier<AsyncValue<List<NewsArticle>>> {
  final ErrorHandler _errorHandler = ErrorHandler();
  
  NewsStateNotifier() : super(const AsyncValue.loading()) {
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      state = const AsyncValue.loading();
      final news = await ApiService.fetchNews();
      state = AsyncValue.data(news);
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  Future<void> refresh() async {
    try {
      ApiService.clearCache();
      await _loadNews();
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  Future<void> loadMore(int page) async {
    try {
      final currentData = state.value ?? [];
      final moreNews = await ApiService.fetchNews(page: page);
      state = AsyncValue.data([...currentData, ...moreNews]);
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }
}

/// Provider for managing events state
final eventsStateProvider = StateNotifierProvider<EventsStateNotifier, AsyncValue<List<FestivalEvent>>>((ref) {
  return EventsStateNotifier();
});

class EventsStateNotifier extends StateNotifier<AsyncValue<List<FestivalEvent>>> {
  final ErrorHandler _errorHandler = ErrorHandler();
  
  EventsStateNotifier() : super(const AsyncValue.loading()) {
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      state = const AsyncValue.loading();
      final events = await ApiService.fetchEvents();
      state = AsyncValue.data(events);
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  Future<void> refresh() async {
    try {
      ApiService.clearCache();
      await _loadEvents();
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  Future<void> loadMore(int page) async {
    try {
      final currentData = state.value ?? [];
      final moreEvents = await ApiService.fetchEvents(page: page);
      state = AsyncValue.data([...currentData, ...moreEvents]);
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  List<FestivalEvent> getUpcomingEvents() {
    final events = state.value ?? [];
    final now = DateTime.now();
    return events.where((event) {
      if (event.startDate == null) return false;
      return event.startDate!.isAfter(now);
    }).toList()
      ..sort((a, b) => (a.startDate ?? now).compareTo(b.startDate ?? now));
  }

  List<FestivalEvent> getPastEvents() {
    final events = state.value ?? [];
    final now = DateTime.now();
    return events.where((event) {
      if (event.endDate == null) return false;
      return event.endDate!.isBefore(now);
    }).toList()
      ..sort((a, b) => (b.endDate ?? now).compareTo(a.endDate ?? now));
  }

  List<FestivalEvent> getCurrentEvents() {
    final events = state.value ?? [];
    final now = DateTime.now();
    return events.where((event) {
      if (event.startDate == null || event.endDate == null) return false;
      return event.startDate!.isBefore(now) && event.endDate!.isAfter(now);
    }).toList();
  }
}

/// Provider for managing venues state
final venuesStateProvider = StateNotifierProvider<VenuesStateNotifier, AsyncValue<List<Venue>>>((ref) {
  return VenuesStateNotifier();
});

class VenuesStateNotifier extends StateNotifier<AsyncValue<List<Venue>>> {
  final ErrorHandler _errorHandler = ErrorHandler();
  
  VenuesStateNotifier() : super(const AsyncValue.loading()) {
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    try {
      state = const AsyncValue.loading();
      final venues = await ApiService.fetchVenues();
      state = AsyncValue.data(venues);
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  Future<void> refresh() async {
    try {
      ApiService.clearCache();
      await _loadVenues();
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  List<Venue> getVenuesWithEvents() {
    final venues = state.value ?? [];
    return venues.where((venue) => venue.events.isNotEmpty).toList();
  }

  List<Venue> getVenuesByLocation(double latitude, double longitude, double radiusKm) {
    final venues = state.value ?? [];
    return venues.where((venue) {
      if (venue.latitude == null || venue.longitude == null) return false;
      
      final distance = _calculateDistance(
        latitude, longitude,
        venue.latitude!, venue.longitude!
      );
      
      return distance <= radiusKm;
    }).toList();
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(_degreesToRadians(lat1)) * sin(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

/// Provider for search state
final searchStateProvider = StateNotifierProvider<SearchStateNotifier, AsyncValue<SearchResults?>>((ref) {
  return SearchStateNotifier();
});

class SearchStateNotifier extends StateNotifier<AsyncValue<SearchResults?>> {
  final ErrorHandler _errorHandler = ErrorHandler();
  
  SearchStateNotifier() : super(const AsyncValue.data(null));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    try {
      state = const AsyncValue.loading();
      final results = await ApiService.search(query);
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }

  void clearSearch() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for API connection status
final apiConnectionProvider = FutureProvider<bool>((ref) async {
  return await ApiService.testConnection();
});

/// Provider for cache statistics
final cacheStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return ApiService.getCacheStats();
}); 