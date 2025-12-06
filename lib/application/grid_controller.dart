import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../data/user_grid_repository.dart';

// Grid Controller Provider
final gridControllerProvider =
    StateNotifierProvider<GridController, GridState>((ref) {
  final repository = ref.watch(userGridRepositoryProvider);
  return GridController(repository);
});

// Repository Provider
final userGridRepositoryProvider = Provider<UserGridRepository>((ref) {
  return UserGridRepository();
});

// Grid State
class GridState {
  final List<UserProfile> users;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final List<String> selectedFilters;

  const GridState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedFilters = const [],
  });

  GridState copyWith({
    List<UserProfile>? users,
    bool? isLoading,
    String? error,
    String? searchQuery,
    List<String>? selectedFilters,
  }) {
    return GridState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }
}

// Grid Controller
class GridController extends StateNotifier<GridState> {
  final UserGridRepository _repository;

  GridController(this._repository) : super(const GridState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _repository.getUsers();
      state = state.copyWith(
        users: users,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  void searchUsers(String query) {
    state = state.copyWith(searchQuery: query);
    _filterUsers();
  }

  void toggleFilter(String filter) {
    final filters = List<String>.from(state.selectedFilters);
    if (filters.contains(filter)) {
      filters.remove(filter);
    } else {
      filters.add(filter);
    }
    state = state.copyWith(selectedFilters: filters);
    _filterUsers();
  }

  void _filterUsers() {
    // Implement filtering logic based on search query and filters
    loadUsers(); // For now, just reload
  }

  void toggleFavorite(String userId) async {
    try {
      await _repository.toggleFavorite(userId);
      // Local state refresh (no favorite field in model yet)
      // TODO: add favorite field support in UserProfile
      state = state.copyWith();
    } catch (error) {
      state = state.copyWith(error: error.toString());
    }
  }

  void refreshUsers() {
    loadUsers();
  }
}
