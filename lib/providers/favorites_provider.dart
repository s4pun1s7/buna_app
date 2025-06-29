import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/favorites_manager.dart';

final favoritesProvider = ChangeNotifierProvider<FavoritesManager>((ref) {
  return FavoritesManager();
});
