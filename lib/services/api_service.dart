import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/festival_data.dart';
import '../utils/debouncer.dart';
import 'error_handler.dart';
import 'mock_data_service.dart';
import 'cache_service.dart';
import 'log_service.dart';
import 'package:flutter/foundation.dart';

/// API service for communicating with the Buna Festival website
class ApiService {
  static Timer? _backgroundSyncTimer;

  /// Starts in-app background sync for news, events, and venues.
  /// Call this once (e.g., in main.dart) to keep cache fresh while app is open.
  static void startBackgroundSync({
    Duration interval = const Duration(minutes: 15),
  }) {
    _backgroundSyncTimer?.cancel();
    _backgroundSyncTimer = Timer.periodic(interval, (_) async {
      try {
        // Refresh news (first page)
        await fetchNews(page: 1);
        // Refresh events (first page)
        await fetchEvents(page: 1);
        // Refresh venues
        await fetchVenues();
        // Add more endpoints as needed
      } catch (e) {
        // Ignore errors, will try again next interval
      }
    });
  }

  /// Stops background sync if needed
  static void stopBackgroundSync() {
    _backgroundSyncTimer?.cancel();
    _backgroundSyncTimer = null;
  }

  /// Generic offline-first cache wrapper for API calls
  static Future<T> fetchWithCache<T>({
    required String cacheKey,
    required Future<T> Function() fetchFunction,
    Duration expiry = const Duration(minutes: 15),
    T Function(dynamic)? fromJson,
  }) async {
    // Try persistent cache first
    final cached = await CacheService.getData(cacheKey);
    if (cached != null && fromJson != null) {
      try {
        return fromJson(cached);
      } catch (_) {}
    } else if (cached != null) {
      return cached as T;
    }
    // If not cached, fetch from network
    final result = await fetchFunction();
    // Save to persistent cache
    await CacheService.setData(cacheKey, result, expiry: expiry);
    return result;
  }
  // API is now enabled. Removed _apiDisabled flag.

  static const String _baseUrl = 'https://bunavarna.com';
  static const String _apiEndpoint = '/wp-json/wp/v2';
  static const Duration _timeout = Duration(seconds: 30);

  // Cache for API responses
  static final Map<String, dynamic> _cache = {};
  static const Duration _cacheExpiry = Duration(minutes: 15);

  static final ErrorHandler _errorHandler = ErrorHandler();

  // Debouncer for API calls to prevent rate limiting
  static final APIDebouncer _apiDebouncer = APIDebouncer();

  /// Helper method to make API requests with proper error handling
  static Future<T> _makeApiRequest<T>(
    String url,
    String endpoint,
    T Function(List<dynamic>) fromJson,
  ) async {
    final response = await http
        .get(
          Uri.parse(url),
          headers: {'Accept': 'application/json'},
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return fromJson(data);
    } else {
      throw _errorHandler.handleApiError(
        'Failed to load data',
        endpoint,
        response.statusCode,
      );
    }
  }

  // --- Free Public API Integrations ---

  static const String _newsApiKey = '';

  /// Fetch news from NewsAPI.org (free API, requires API key)
  static Future<List<NewsArticle>> fetchPublicNews({
    int page = 1,
    int pageSize = 5,
  }) async {
    if (_newsApiKey.isEmpty) {
      // Fallback to mock data if no API key
      return MockDataService.getMockNews();
    }
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://newsapi.org/v2/top-headlines?country=us&pageSize=$pageSize&page=$page&apiKey=$_newsApiKey',
            ),
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'] ?? [];
        return articles
            .map(
              (json) => NewsArticle(
                id: json['publishedAt']?.hashCode ?? 0,
                title: json['title'] ?? '',
                content: json['content'] ?? '',
                excerpt: json['description'] ?? '',
                date:
                    DateTime.tryParse(json['publishedAt'] ?? '') ??
                    DateTime.now(),
                featuredImageUrl: json['urlToImage'],
                author: json['author'] ?? 'Unknown',
                categories: [json['source']?['name'] ?? 'NewsAPI'],
                url: json['url'] ?? '',
              ),
            )
            .toList();
      } else {
        throw _errorHandler.handleApiError(
          'Failed to load public news',
          'newsapi.org',
          response.statusCode,
        );
      }
    } on TimeoutException {
      throw _errorHandler.handleError(
        TimeoutException('Request timed out', const Duration(seconds: 30)),
      );
    } catch (e, stackTrace) {
      throw _errorHandler.handleError(e, stackTrace);
    }
  }

  /// Fetch news articles from the festival website
  static Future<List<NewsArticle>> fetchNews({
    int page = 1,
    int perPage = 10,
  }) async {
    // API is enabled. No mock fallback here.

    final cacheKey = 'news_page_$page';
    return await fetchWithCache<List<NewsArticle>>(
      cacheKey: cacheKey,
      expiry: _cacheExpiry,
      fromJson: (data) =>
          (data as List<dynamic>).map((e) => NewsArticle.fromJson(e)).toList(),
      fetchFunction: () async {
        LogService.info('Fetching news page $page');
        return await _makeApiRequest<List<NewsArticle>>(
          '$_baseUrl$_apiEndpoint/posts?page=$page&per_page=$perPage&_embed',
          '$_apiEndpoint/posts',
          (data) => data.map((json) => NewsArticle.fromJson(json)).toList(),
        ).retryWithBackoff(_errorHandler);
      },
    );
  }

  /// Fetch events from the festival website
  static Future<List<FestivalEvent>> fetchEvents({
    int page = 1,
    int perPage = 20,
  }) async {
    // API is enabled. No mock fallback here.

    final cacheKey = 'events_page_$page';
    return await fetchWithCache<List<FestivalEvent>>(
      cacheKey: cacheKey,
      expiry: _cacheExpiry,
      fromJson: (data) => (data as List<dynamic>)
          .map((e) => FestivalEvent.fromJson(e))
          .toList(),
      fetchFunction: () async {
        try {
          final response = await http
              .get(
                Uri.parse(
                  '$_baseUrl$_apiEndpoint/events?page=$page&per_page=$perPage&_embed',
                ),
                headers: {'Accept': 'application/json'},
              )
              .timeout(_timeout);
          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            return data.map((json) => FestivalEvent.fromJson(json)).toList();
          } else if (response.statusCode == 404) {
            // Fallback to posts with event category
            return await _fetchEventsFromPosts(page: page, perPage: perPage);
          } else {
            throw _errorHandler.handleApiError(
              'Failed to load events',
              '$_apiEndpoint/events',
              response.statusCode,
            );
          }
        } on TimeoutException {
          throw _errorHandler.handleError(
            TimeoutException('Request timed out', const Duration(seconds: 30)),
          );
        } catch (e, stackTrace) {
          throw _errorHandler.handleError(e, stackTrace);
        }
      },
    );
  }

  /// Fetch events from posts with event category
  static Future<List<FestivalEvent>> _fetchEventsFromPosts({
    int page = 1,
    int perPage = 20,
  }) async {
    // API is enabled. No mock fallback here.
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl$_apiEndpoint/posts?categories=event&page=$page&per_page=$perPage&_embed',
            ),
            headers: {'Accept': 'application/json'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => FestivalEvent.fromPostJson(json)).toList();
      } else {
        throw _errorHandler.handleApiError(
          'Failed to load events from posts',
          '$_apiEndpoint/posts?categories=event',
          response.statusCode,
        );
      }
    } on TimeoutException {
      throw _errorHandler.handleError(
        TimeoutException('Request timed out', const Duration(seconds: 30)),
      );
    } catch (e, stackTrace) {
      throw _errorHandler.handleError(e, stackTrace);
    }
  }

  /// Fetch venue information
  static Future<List<Venue>> fetchVenues() async {
    // API is enabled. No mock fallback here.

    const cacheKey = 'venues';
    return await fetchWithCache<List<Venue>>(
      cacheKey: cacheKey,
      expiry: _cacheExpiry,
      fromJson: (data) =>
          (data as List<dynamic>).map((e) => Venue.fromJson(e)).toList(),
      fetchFunction: () async {
        try {
          final response = await http
              .get(
                Uri.parse('$_baseUrl$_apiEndpoint/venues?_embed'),
                headers: {'Accept': 'application/json'},
              )
              .timeout(_timeout);
          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            return data.map((json) => Venue.fromJson(json)).toList();
          } else if (response.statusCode == 404) {
            // Return empty list if venues endpoint doesn't exist
            return [];
          } else {
            throw _errorHandler.handleApiError(
              'Failed to load venues',
              '$_apiEndpoint/venues',
              response.statusCode,
            );
          }
        } on TimeoutException {
          throw _errorHandler.handleError(
            TimeoutException('Request timed out', const Duration(seconds: 30)),
          );
        } catch (e, stackTrace) {
          throw _errorHandler.handleError(e, stackTrace);
        }
      },
    );
  }

  /// Fetch festival information
  static Future<FestivalInfo> fetchFestivalInfo() async {
    // API is enabled. No mock fallback here.

    return await _debouncedApiCall(() async {
      try {
        const cacheKey = 'festival_info';
        if (_isCacheValid(cacheKey)) {
          return _cache[cacheKey]['data'];
        }

        final response = await http
            .get(
              Uri.parse('$_baseUrl$_apiEndpoint/pages?slug=about&_embed'),
              headers: {'Accept': 'application/json'},
            )
            .timeout(_timeout);

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            final info = FestivalInfo.fromJson(data.first);

            _cache[cacheKey] = {'data': info, 'timestamp': DateTime.now()};

            return info;
          } else {
            throw _errorHandler.handleApiError(
              'Festival information not found',
              '$_apiEndpoint/pages?slug=about',
              404,
            );
          }
        } else {
          throw _errorHandler.handleApiError(
            'Failed to load festival information',
            '$_apiEndpoint/pages?slug=about',
            response.statusCode,
          );
        }
      } on TimeoutException {
        throw _errorHandler.handleError(
          TimeoutException('Request timed out', const Duration(seconds: 30)),
        );
      } catch (e, stackTrace) {
        throw _errorHandler.handleError(e, stackTrace);
      }
    });
  }

  /// Search content across the website
  static Future<SearchResults> search(String query, {int page = 1}) async {
    // API is enabled. No mock fallback here.

    return await _debouncedApiCall(() async {
      try {
        if (query.trim().isEmpty) {
          return SearchResults(
            news: [],
            events: [],
            venues: [],
            totalResults: 0,
          );
        }

        final response = await http
            .get(
              Uri.parse(
                '$_baseUrl$_apiEndpoint/search?search=${Uri.encodeComponent(query)}&page=$page&_embed',
              ),
              headers: {'Accept': 'application/json'},
            )
            .timeout(_timeout);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return SearchResults.fromJson(data);
        } else {
          throw _errorHandler.handleApiError(
            'Search failed',
            '$_apiEndpoint/search',
            response.statusCode,
          );
        }
      } on TimeoutException {
        throw _errorHandler.handleError(
          TimeoutException(
            'Search request timed out',
            const Duration(seconds: 30),
          ),
        );
      } catch (e, stackTrace) {
        throw _errorHandler.handleError(e, stackTrace);
      }
    });
  }

  /// Check if cache is valid
  static bool _isCacheValid(String key) {
    if (!_cache.containsKey(key)) return false;
    final cached = _cache[key];
    return DateTime.now().difference(cached['timestamp']) < _cacheExpiry;
  }

  /// Debounced API call wrapper
  static Future<T> _debouncedApiCall<T>(Future<T> Function() apiCall) async {
    Completer<T> completer = Completer<T>();

    _apiDebouncer.call(() async {
      try {
        final result = await apiCall();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });

    return completer.future;
  }

  /// Test API connectivity
  static Future<bool> testConnection() async {
    // API is enabled. No disabled check.

    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl$_apiEndpoint'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Clear cache
  static void clearCache() {
    _cache.clear();
  }

  /// Clear specific cache entry
  static void clearCacheEntry(String key) {
    _cache.remove(key);
  }

  /// Get cache statistics for debugging
  static Map<String, dynamic> getCacheStats() {
    return {
      'total_entries': _cache.length,
      'entries': _cache.keys.toList(),
      'is_debouncer_active': _apiDebouncer.isActive,
      // 'api_disabled': false, // No longer used
    };
  }

  /// Check current API configuration
  static Map<String, dynamic> checkApiConfiguration({bool verbose = true}) {
    final config = {
      'baseUrl': _baseUrl,
      'apiEndpoint': _apiEndpoint,
      'timeout': _timeout.inSeconds,
      'cacheExpiry': _cacheExpiry.inMinutes,
      // 'apiDisabled': false, // No longer used
    };
    if (verbose) {
      debugPrint('--- API Configuration ---');
      config.forEach((key, value) {
        debugPrint('$key: $value');
      });
      debugPrint('-------------------------');
    }
    return config;
  }
}
