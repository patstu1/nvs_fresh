// packages/grid/lib/data/providers/meatup_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../models/vibe_lens_types.dart';

/// Provider for meatup profiles based on VibeLens filter
final meatupProfilesProvider = StateNotifierProvider.family<MeatupProfilesNotifier,
    AsyncValue<List<UserProfile>>, VibeLensType>((ref, lens) => MeatupProfilesNotifier(lens));

/// State notifier for managing meatup profiles
class MeatupProfilesNotifier extends StateNotifier<AsyncValue<List<UserProfile>>> {
  final VibeLensType lens;
  final UserService _userService = UserService();
  int _offset = 0;
  static const int _limit = 20;
  bool _hasMore = true;

  MeatupProfilesNotifier(this.lens) : super(const AsyncValue.loading()) {
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      // Get nearby users from Firestore
      final profiles = await _userService.getNearbyUsers(
        latitude: 0, // TODO: Get actual user location
        longitude: 0, // TODO: Get actual user location
        radiusKm: 50, // 50km radius
        limit: _limit,
      );

      // Filter profiles based on lens type
      final filteredProfiles = _filterProfilesByLens(profiles);

      state = AsyncValue.data(filteredProfiles);
      _offset = _limit;
      _hasMore = profiles.length >= _limit;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final currentProfiles = state.value ?? [];

    try {
      // Get more nearby users from Firestore
      final newProfiles = await _userService.getNearbyUsers(
        latitude: 0, // TODO: Get actual user location
        longitude: 0, // TODO: Get actual user location
        radiusKm: 50, // 50km radius
        limit: _limit,
      );

      if (newProfiles.isEmpty) {
        _hasMore = false;
        return;
      }

      final filteredNewProfiles = _filterProfilesByLens(newProfiles);
      state = AsyncValue.data([...currentProfiles, ...filteredNewProfiles]);
      _offset += _limit;
    } catch (error, stackTrace) {
      // Keep current data on error
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void refresh() {
    _offset = 0;
    _hasMore = true;
    state = const AsyncValue.loading();
    _loadProfiles();
  }

  List<UserProfile> _filterProfilesByLens(List<UserProfile> profiles) {
    switch (lens) {
      case VibeLensType.nearby:
        // Return online profiles sorted by last seen
        return profiles.where((p) => p.status.isOnline).toList()
          ..sort((a, b) => b.lastSeen.compareTo(a.lastSeen));

      case VibeLensType.trending:
        // Return verified profiles with highest stats
        return profiles.where((p) => p.isVerified).toList()
          ..sort((a, b) => b.stats.totalConnections.compareTo(a.stats.totalConnections));

      case VibeLensType.newFaces:
        // Return newest profiles
        return profiles..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      case VibeLensType.nomads:
        // Return profiles with location-based interests
        return profiles
            .where(
              (p) => p.interests.any(
                (interest) =>
                    interest.toLowerCase().contains('travel') ||
                    interest.toLowerCase().contains('adventure'),
              ),
            )
            .toList();

      case VibeLensType.refine:
        // Return all profiles for refine mode
        return profiles;
    }
  }
}
