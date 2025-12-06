import 'dart:async';
import 'package:nvs/meatup_core.dart';

class FavoritesRepository {
  Future<List<UserProfile>> getFavoriteUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return <UserProfile>[
      UserProfile(
        id: 'fav_01',
        email: 'blaze@nvs.com',
        displayName: 'Blaze',
        photoURL: 'assets/images/avatar_placeholder.png',
        age: 27,
        gender: 'male',
        preferences: const UserPreferences(),
        stats: const UserStats(),
        status: const UserStatus(status: 'online', statusMessage: '🔥 Here now'),
        subscription: const SubscriptionInfo(plan: 'premium'),
        verification: const VerificationInfo(emailVerified: true),
        privacy: const PrivacySettings(),
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
        updatedAt: DateTime.now(),
        lastActiveAt: DateTime.now().subtract(const Duration(minutes: 3)),
        isOnline: true,
      ),
      UserProfile(
        id: 'fav_02',
        email: 'royal@nvs.com',
        displayName: 'Royal',
        photoURL: 'assets/images/avatar_placeholder.png',
        age: 30,
        gender: 'male',
        preferences: const UserPreferences(),
        stats: const UserStats(),
        status: const UserStatus(
          status: 'offline',
          statusMessage: '👑 Private only',
        ),
        subscription: const SubscriptionInfo(plan: 'premium'),
        verification: const VerificationInfo(emailVerified: true),
        privacy: const PrivacySettings(),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
        lastActiveAt: DateTime.now().subtract(const Duration(hours: 1)),
        isOnline: false,
      ),
      UserProfile(
        id: 'fav_03',
        email: 'ghost@nvs.com',
        displayName: '👀',
        photoURL: 'assets/images/avatar_placeholder.png',
        age: 33,
        gender: 'male',
        preferences: const UserPreferences(),
        stats: const UserStats(),
        status: const UserStatus(status: 'online', statusMessage: 'DM only'),
        subscription: const SubscriptionInfo(),
        verification: const VerificationInfo(emailVerified: true),
        privacy: const PrivacySettings(),
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
        lastActiveAt: DateTime.now().subtract(const Duration(minutes: 7)),
        isOnline: true,
      ),
    ];
  }
}
