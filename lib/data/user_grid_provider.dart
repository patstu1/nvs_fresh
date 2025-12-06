import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'user_grid_repository.dart';

// Provide the repository
final userGridRepositoryProvider = Provider<UserGridRepository>((ref) {
  return UserGridRepository();
});

// Provide the user list (async)
final userGridProvider = FutureProvider<List<UserProfile>>((ref) async {
  final repo = ref.watch(userGridRepositoryProvider);
  return await repo.getUsers();
});

// Alias for userGridProvider
final userGridListProvider = userGridProvider;

// Favorites wiring
final favoritesServiceProvider = Provider<FavoritesService>((ref) => FavoritesService());

final favoriteIdsProvider = StreamProvider<Set<String>>((ref) {
  final svc = ref.watch(favoritesServiceProvider);
  return svc.favoriteIdsStream();
});

// UI filter state: favorites only
final StateProvider<bool> favoritesOnlyProvider = StateProvider<bool>((ref) => false);
