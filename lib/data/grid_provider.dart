// packages/grid/lib/data/grid_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'grid_mock_users.dart';

/// Provider for grid users data
final gridUsersProvider = FutureProvider<List<UserProfile>>((ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));

  // Return mock data - in production this would fetch from Firestore
  return gridMockUsers;
});

/// Provider for filtered users based on current filters
final filteredGridUsersProvider = Provider.family<List<UserProfile>, Map<String, dynamic>>((
  ref,
  filters,
) {
  final usersAsync = ref.watch(gridUsersProvider);

  return usersAsync.maybeWhen(
    data: (users) {
      var filteredUsers = users;

      // Apply online filter
      if (filters['onlineOnly'] == true) {
        filteredUsers = filteredUsers.where((user) => user.status.isOnline).toList();
      }

      // Apply role filter
      if (filters['role'] != null && filters['role'] != 'All Roles') {
        filteredUsers = filteredUsers
            .where(
              (user) => user.interests.any(
                (interest) =>
                    interest.toLowerCase().contains(filters['role'].toString().toLowerCase()),
              ),
            )
            .toList();
      }

      // Apply location filter
      if (filters['location'] != null && filters['location'] != 'All Cities') {
        filteredUsers = filteredUsers
            .where(
              (user) => user.location.toLowerCase().contains(
                filters['location'].toString().toLowerCase(),
              ),
            )
            .toList();
      }

      // Apply search filter
      if (filters['search'] != null && filters['search'].toString().isNotEmpty) {
        final searchTerm = filters['search'].toString().toLowerCase();
        filteredUsers = filteredUsers
            .where(
              (user) =>
                  user.displayName.toLowerCase().contains(searchTerm) ||
                  user.location.toLowerCase().contains(searchTerm) ||
                  user.interests.any((interest) => interest.toLowerCase().contains(searchTerm)),
            )
            .toList();
      }

      return filteredUsers;
    },
    orElse: () => [],
  );
});

/// Provider for current filter state
final gridFilterProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {'onlineOnly': false, 'role': 'All Roles', 'location': 'All Cities', 'search': ''},
);

/// Provider for loading state
final gridLoadingProvider = StateProvider<bool>((ref) => false);

/// Provider for error state
final gridErrorProvider = StateProvider<String?>((ref) => null);
