import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/providers/favorites_provider.dart';

void main() {
  test('FavoritesProvider initial state is not null', () {
    final container = ProviderContainer();
    final favorites = container.read(favoritesProvider);
    expect(favorites, isNotNull);
  });
} 