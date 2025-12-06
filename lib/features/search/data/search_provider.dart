import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'search_repository.dart';

final Provider<SearchRepository> searchRepositoryProvider = Provider<SearchRepository>((ProviderRef<SearchRepository> ref) {
  return SearchRepository();
});

final StateProvider<String> searchQueryProvider = StateProvider<String>((StateProviderRef<String> ref) => '');

final FutureProvider<List<UserProfile>> searchResultsProvider = FutureProvider<List<UserProfile>>((FutureProviderRef<List<UserProfile>> ref) async {
  final String query = ref.watch(searchQueryProvider);
  if (query.isEmpty) {
    return <UserProfile>[];
  }
  final SearchRepository repo = ref.watch(searchRepositoryProvider);
  return repo.searchUsers(query);
});
