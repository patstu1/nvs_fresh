import 'package:nvs/meatup_core.dart';

class UserGridRepository {
  Future<List<UserProfile>> getUsers() async {
    final UserService userService = UserService();
    // Fetch real online users from Firestore (no mocks). Geospatial can be added later.
    final List<UserProfile> users = await userService.getNearbyUsers(
      latitude: 0,
      longitude: 0,
      radiusKm: 50,
      limit: 60,
    );
    return users;
  }

  Future<List<UserProfile>> getUserProfiles() => getUsers();

  Future<void> toggleFavorite(String userId) async {
    // No-op for now; wire to backend when available.
  }
}
