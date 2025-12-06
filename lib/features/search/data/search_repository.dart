import 'package:nvs/meatup_core.dart';

class SearchRepository {
  Future<List<UserProfile>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock search results based on query
    final List<UserProfile> allUsers = await _getAllUsers();

    if (query.isEmpty) return <UserProfile>[];

    return allUsers.where((UserProfile user) {
      final String searchText = query.toLowerCase();
      return user.displayName.toLowerCase().contains(searchText) ||
          user.bio?.toLowerCase().contains(searchText) ?? false ||
          user.interests
              .any((String interest) => interest.toLowerCase().contains(searchText)) ||
          _matchesEmoji(query);
    }).toList();
  }

  bool _matchesEmoji(String query) {
    // Check for emoji patterns in search
    return query.contains('🐷') ||
        query.contains('🍆') ||
        query.contains('🧠') ||
        query.contains('💦') ||
        query.contains('🔥') ||
        query.contains('👑') ||
        query.contains('✨');
  }

  Future<List<UserProfile>> _getAllUsers() async {
    return <UserProfile>[
      UserProfile(
        id: 'search1',
        email: 'dom@example.com',
        displayName: 'Marcus',
        photoURL: 'https://picsum.photos/203',
        avatarUrl: 'https://picsum.photos/203',
        name: 'Marcus',
        location: 'Los Angeles',
        interests: <String>['fitness', 'music'],
        bio: 'Dominant top looking for submissive connections 🔥',
        age: 32,
        gender: 'male',
        preferences: const UserPreferences(),
        stats: const UserStats(),
        status: UserStatus.online(),
        subscription: const SubscriptionInfo(),
        verification: VerificationInfo.unverified(),
        privacy: const PrivacySettings(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isVerified: false,
        roleEmoji: '👑',
        sexualRole: 'Dom',
        compatibility: 94.0,
      ),
      UserProfile(
        id: 'search2',
        email: 'vers@example.com',
        displayName: 'Jamie',
        photoURL: 'https://picsum.photos/204',
        avatarUrl: 'https://picsum.photos/204',
        name: 'Jamie',
        location: 'San Francisco',
        interests: <String>['travel', 'art'],
        bio: 'Versatile and open-minded 🔄',
        age: 28,
        gender: 'male',
        preferences: const UserPreferences(),
        stats: const UserStats(),
        status: UserStatus.online(),
        subscription: const SubscriptionInfo(),
        verification: VerificationInfo.unverified(),
        privacy: const PrivacySettings(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isVerified: false,
        roleEmoji: '🔄',
        sexualRole: 'Vers',
        compatibility: 87.0,
      ),
      UserProfile(
        id: 'search3',
        email: 'twink@example.com',
        displayName: 'Riley',
        photoURL: 'https://picsum.photos/205',
        avatarUrl: 'https://picsum.photos/205',
        name: 'Riley',
        location: 'New York',
        interests: <String>['dancing', 'fashion'],
        bio: 'Young and energetic ✨',
        age: 22,
        gender: 'male',
        preferences: const UserPreferences(),
        stats: const UserStats(),
        status: UserStatus.online(),
        subscription: const SubscriptionInfo(),
        verification: VerificationInfo.unverified(),
        privacy: const PrivacySettings(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isVerified: false,
        roleEmoji: '✨',
        sexualRole: 'Twink',
        compatibility: 76.0,
      ),
    ];
  }
}
