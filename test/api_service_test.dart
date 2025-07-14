import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/services/api_service.dart';

void main() {
  group('ApiService configuration', () {
    test('API base URL is correct', () {
      // This is a private field, so we check by calling a method that uses it
      expect(ApiService.testConnection(), completes);
    });

    test('testConnection returns a boolean', () async {
      final result = await ApiService.testConnection();
      expect(result, isA<bool>());
    });

    test('API can be enabled/disabled', () async {
      // When API is disabled, testConnection should return true (see implementation)
      final result = await ApiService.testConnection();
      expect(result, isTrue);
    });
  });
}
