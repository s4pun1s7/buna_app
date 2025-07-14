import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/festival_data.dart';
import '../utils/debouncer.dart';
import 'error_handler.dart';
import 'mock_data_service.dart';

// TODO: Move Artist model to its own file (lib/models/artist.dart)
class Artist {
  final String name;
  Artist({required this.name});
}

/// API service for communicating with the Buna Festival website
class ApiService {
  // Flag to temporarily disable API calls
  static const bool _apiDisabled = true; // Set to false to re-enable API

  static const String _baseUrl = 'https://bunavarna.com';
  static const String _apiEndpoint = '/wp-json/wp/v2';
  static const Duration _timeout = Duration(seconds: 30);

  // Cache for API responses
  static final Map<String, dynamic> _cache = {};
  static const Duration _cacheExpiry = Duration(minutes: 15);

  static final ErrorHandler _errorHandler = ErrorHandler();

  // Debouncer for API calls to prevent rate limiting
  static final APIDebouncer _apiDebouncer = APIDebouncer();

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

  /// Fetch artists from Harvard Art Museums API (free API, requires API key)
  static Future<List<Artist>> fetchPublicArtists({
    int page = 1,
    int size = 5,
  }) async {
    // TODO: Replace with real implementation
    return [];
  }

  /// Fetch news articles from the festival website
  static Future<List<NewsArticle>> fetchNews({
    int page = 1,
    int perPage = 10,
  }) async {
    if (_apiDisabled) {
      return MockDataService.getMockNews();
    }

    return await _debouncedApiCall(() async {
      try {
        final cacheKey = 'news_page_$page';
        if (_isCacheValid(cacheKey)) {
          return _cache[cacheKey]['data'];
        }

        final response = await http
            .get(
              Uri.parse(
                '$_baseUrl$_apiEndpoint/posts?page=$page&per_page=$perPage&_embed',
              ),
              headers: {'Accept': 'application/json'},
            )
            .timeout(_timeout);

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final articles = data
              .map((json) => NewsArticle.fromJson(json))
              .toList();

          _cache[cacheKey] = {'data': articles, 'timestamp': DateTime.now()};

          return articles;
        } else {
          throw _errorHandler.handleApiError(
            'Failed to load news',
            '$_apiEndpoint/posts',
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

  /// Fetch events from the festival website
  static Future<List<FestivalEvent>> fetchEvents({
    int page = 1,
    int perPage = 20,
  }) async {
    if (_apiDisabled) {
      return MockDataService.getMockEvents();
    }

    return await _debouncedApiCall(() async {
      try {
        final cacheKey = 'events_page_$page';
        if (_isCacheValid(cacheKey)) {
          return _cache[cacheKey]['data'];
        }

        // Try to fetch from custom endpoint if available
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
          final events = data
              .map((json) => FestivalEvent.fromJson(json))
              .toList();

          _cache[cacheKey] = {'data': events, 'timestamp': DateTime.now()};

          return events;
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
    });
  }

  /// Fetch events from posts with event category
  static Future<List<FestivalEvent>> _fetchEventsFromPosts({
    int page = 1,
    int perPage = 20,
  }) async {
    if (_apiDisabled) {
      return MockDataService.getMockEvents();
    }
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
    if (_apiDisabled) {
      return MockDataService.getMockVenues();
    }

    return await _debouncedApiCall(() async {
      try {
        const cacheKey = 'venues';
        if (_isCacheValid(cacheKey)) {
          return _cache[cacheKey]['data'];
        }

        final response = await http
            .get(
              Uri.parse('$_baseUrl$_apiEndpoint/venues?_embed'),
              headers: {'Accept': 'application/json'},
            )
            .timeout(_timeout);

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final venues = data.map((json) => Venue.fromJson(json)).toList();

          _cache[cacheKey] = {'data': venues, 'timestamp': DateTime.now()};

          return venues;
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
    });
  }

  /// Fetch festival information
  static Future<FestivalInfo> fetchFestivalInfo() async {
    if (_apiDisabled) {
      return MockDataService.getMockFestivalInfo();
    }

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
    if (_apiDisabled) {
      return MockDataService.getMockSearchResults(query);
    }

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
    if (_apiDisabled) {
      return true; // Return true when API is disabled
    }

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
      'api_disabled': _apiDisabled,
    };
  }

  /// Check current API configuration
  static Map<String, dynamic> checkApiConfiguration({bool verbose = true}) {
    final config = {
      'baseUrl': _baseUrl,
      'apiEndpoint': _apiEndpoint,
      'timeout': _timeout.inSeconds,
      'cacheExpiry': _cacheExpiry.inMinutes,
      'apiDisabled': _apiDisabled,
    };
    if (verbose) {
      print('--- API Configuration ---');
      config.forEach((key, value) {
        print('$key: $value');
      });
      print('-------------------------');
    }
    return config;
  }
}
