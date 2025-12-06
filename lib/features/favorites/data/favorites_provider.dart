import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_repository.dart';
import 'package:nvs/meatup_core.dart';

// Provide the FavoritesRepository
final Provider<FavoritesRepository> favoritesRepositoryProvider =
    Provider<FavoritesRepository>((ProviderRef<FavoritesRepository> ref) {
  return FavoritesRepository();
});

// Provide the favorite users list using FutureProvider
final FutureProvider<List<UserProfile>> favoritesListProvider =
    FutureProvider<List<UserProfile>>((FutureProviderRef<List<UserProfile>> ref) async {
  final FavoritesRepository repository = ref.watch(favoritesRepositoryProvider);
  return repository.getFavoriteUsers();
});
