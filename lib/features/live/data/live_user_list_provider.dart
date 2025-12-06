import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';

final FutureProvider<List<UserProfile>> liveUserListProvider =
    FutureProvider<List<UserProfile>>((FutureProviderRef<List<UserProfile>> ref) async {
  // In a real app, this would fetch data from a repository
  // For now, we'll return a delayed mock list
  await Future.delayed(const Duration(seconds: 1));
  return <UserProfile>[
    UserProfile(
      id: '1',
      displayName: 'Ryker',
      age: 28,
      photoURL: 'https://i.pravatar.cc/150?u=ryker',
      email: 'ryker@example.com',
      gender: 'Male',
      sexualRole: 'Top',
      preferences: const UserPreferences(preferredGenders: <String>['Male']),
      stats: const UserStats(profileViews: 100),
      status: const UserStatus(status: 'online'),
      subscription: const SubscriptionInfo(plan: 'premium'),
      verification: const VerificationInfo(emailVerified: true),
      privacy: const PrivacySettings(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    UserProfile(
      id: '2',
      displayName: 'Jax',
      age: 32,
      photoURL: 'https://i.pravatar.cc/150?u=jax',
      email: 'jax@example.com',
      gender: 'Male',
      sexualRole: 'Bottom',
      preferences: const UserPreferences(preferredGenders: <String>['Male']),
      stats: const UserStats(profileViews: 250),
      status: const UserStatus(status: 'online'),
      subscription: const SubscriptionInfo(),
      verification: const VerificationInfo(emailVerified: false),
      privacy: const PrivacySettings(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    UserProfile(
      id: '3',
      displayName: 'Zane',
      age: 25,
      photoURL: 'https://i.pravatar.cc/150?u=zane',
      email: 'zane@example.com',
      gender: 'Male',
      sexualRole: 'Vers',
      preferences: const UserPreferences(preferredGenders: <String>['Male']),
      stats: const UserStats(profileViews: 150),
      status: const UserStatus(status: 'online'),
      subscription: const SubscriptionInfo(plan: 'premium'),
      verification: const VerificationInfo(emailVerified: true),
      privacy: const PrivacySettings(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    UserProfile(
      id: '4',
      displayName: 'Asher',
      age: 29,
      photoURL: 'https://i.pravatar.cc/150?u=asher',
      email: 'asher@example.com',
      gender: 'Male',
      sexualRole: 'Top',
      preferences: const UserPreferences(preferredGenders: <String>['Male']),
      stats: const UserStats(profileViews: 180),
      status: const UserStatus(status: 'online'),
      subscription: const SubscriptionInfo(),
      verification: const VerificationInfo(emailVerified: false),
      privacy: const PrivacySettings(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
});
