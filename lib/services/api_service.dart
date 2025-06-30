import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/festival_data.dart';
import 'error_handler.dart';

class ApiService {
  static const String _baseUrl = 'https://bunavarna.com';
  static const String _apiEndpoint = '/wp-json/wp/v2';
  static const Duration _timeout = Duration(seconds: 30);
  
  // Cache for API responses
  static final Map<String, dynamic> _cache = {};
  static const Duration _cacheExpiry = Duration(minutes: 15);

  static final ErrorHandler _errorHandler = ErrorHandler();

  /// Fetch news articles from the festival website
  static Future<List<NewsArticle>> fetchNews({int page = 1, int perPage = 10}) async {
    try {
      final cacheKey = 'news_page_$page';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey]['data'];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint/posts?page=$page&per_page=$perPage&_embed'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final articles = data.map((json) => NewsArticle.fromJson(json)).toList();
        
        _cache[cacheKey] = {
          'data': articles,
          'timestamp': DateTime.now(),
        };
        
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
  }

  /// Fetch events from the festival website
  static Future<List<FestivalEvent>> fetchEvents({int page = 1, int perPage = 20}) async {
    try {
      final cacheKey = 'events_page_$page';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey]['data'];
      }

      // Try to fetch from custom endpoint if available
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint/events?page=$page&per_page=$perPage&_embed'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final events = data.map((json) => FestivalEvent.fromJson(json)).toList();
        
        _cache[cacheKey] = {
          'data': events,
          'timestamp': DateTime.now(),
        };
        
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
  }

  /// Fetch events from posts with event category
  static Future<List<FestivalEvent>> _fetchEventsFromPosts({int page = 1, int perPage = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint/posts?categories=event&page=$page&per_page=$perPage&_embed'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

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
    try {
      const cacheKey = 'venues';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey]['data'];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint/venues?_embed'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final venues = data.map((json) => Venue.fromJson(json)).toList();
        
        _cache[cacheKey] = {
          'data': venues,
          'timestamp': DateTime.now(),
        };
        
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
  }

  /// Fetch festival information
  static Future<FestivalInfo> fetchFestivalInfo() async {
    try {
      const cacheKey = 'festival_info';
      if (_isCacheValid(cacheKey)) {
        return _cache[cacheKey]['data'];
      }

      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint/pages?slug=about&_embed'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final info = FestivalInfo.fromJson(data.first);
          
          _cache[cacheKey] = {
            'data': info,
            'timestamp': DateTime.now(),
          };
          
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
  }

  /// Search content across the website
  static Future<SearchResults> search(String query, {int page = 1}) async {
    try {
      if (query.trim().isEmpty) {
        return SearchResults(
          news: [],
          events: [],
          venues: [],
          totalResults: 0,
        );
      }

      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint/search?search=${Uri.encodeComponent(query)}&page=$page&_embed'),
        headers: {'Accept': 'application/json'},
      ).timeout(_timeout);

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
        TimeoutException('Search request timed out', const Duration(seconds: 30)),
      );
    } catch (e, stackTrace) {
      throw _errorHandler.handleError(e, stackTrace);
    }
  }

  /// Test API connectivity
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiEndpoint'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

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

  /// Check if cache is still valid
  static bool _isCacheValid(String key) {
    if (!_cache.containsKey(key)) return false;
    
    final timestamp = _cache[key]['timestamp'] as DateTime;
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  /// Get cache statistics for debugging
  static Map<String, dynamic> getCacheStats() {
    return {
      'entries': _cache.length,
      'keys': _cache.keys.toList(),
      'expiry': _cacheExpiry.inMinutes,
    };
  }
} 