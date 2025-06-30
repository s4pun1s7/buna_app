import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _cachePrefix = 'buna_cache_';
  static const Duration _defaultExpiry = Duration(hours: 1);
  
  /// Cache data with expiration
  static Future<void> setData(String key, dynamic data, {Duration? expiry}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': (expiry ?? _defaultExpiry).inMilliseconds,
    };
    
    await prefs.setString('$_cachePrefix$key', jsonEncode(cacheData));
  }
  
  /// Get cached data if not expired
  static Future<dynamic> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('$_cachePrefix$key');
    
    if (cached == null) return null;
    
    try {
      final cacheData = jsonDecode(cached) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      final expiry = cacheData['expiry'] as int;
      
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - timestamp > expiry) {
        await prefs.remove('$_cachePrefix$key');
        return null;
      }
      
      return cacheData['data'];
    } catch (e) {
      await prefs.remove('$_cachePrefix$key');
      return null;
    }
  }
  
  /// Clear specific cache entry
  static Future<void> clearData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_cachePrefix$key');
  }
  
  /// Clear all cache
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
  
  /// Get cache size
  static Future<int> getCacheSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().where((key) => key.startsWith(_cachePrefix)).length;
  }
} 