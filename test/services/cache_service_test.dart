import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buna_app/services/cache_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('CacheService', () {
    const testKey = 'test_key';
    const testValue = 'test_value';

    setUp(() async {
      await CacheService.clearData(testKey);
    });

    test('should store and retrieve a value', () async {
      await CacheService.setData(testKey, testValue);
      final result = await CacheService.getData(testKey);
      expect(result, testValue);
    });

    test('should return null for missing or expired key', () async {
      final result = await CacheService.getData('missing_key');
      expect(result, isNull);
    });

    test('should clear a value', () async {
      await CacheService.setData(testKey, testValue);
      await CacheService.clearData(testKey);
      final result = await CacheService.getData(testKey);
      expect(result, isNull);
    });
  });
} 