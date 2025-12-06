import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class MockUser {
  final String id;
  final String displayName;
  final int age;
  final String? photoURL;
  final String? roleEmoji;
  final String? sexualRole;
  final String? compatibility;
  final bool isOnline;

  // New NVS properties
  final int matchPercent;
  final bool isFavorite;
  final int distance;
  final bool isLoading;
  final bool isBlocked;

  MockUser({
    required this.id,
    required this.displayName,
    required this.age,
    this.photoURL,
    this.roleEmoji,
    this.sexualRole,
    this.compatibility,
    this.isOnline = false,
    // NVS properties with defaults
    int? matchPercent,
    this.isFavorite = false,
    int? distance,
    this.isLoading = false,
    this.isBlocked = false,
  })  : matchPercent = matchPercent ?? Random().nextInt(90) + 10,
        distance = distance ?? Random().nextInt(50) + 1;

  // Convenience getters for compatibility with NVS components
  String get name => displayName;
  String? get photoUrl => photoURL;

  // Copy with method for state updates
  MockUser copyWith({
    String? id,
    String? displayName,
    int? age,
    String? photoURL,
    String? roleEmoji,
    String? sexualRole,
    String? compatibility,
    bool? isOnline,
    int? matchPercent,
    bool? isFavorite,
    int? distance,
    bool? isLoading,
    bool? isBlocked,
  }) {
    return MockUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      photoURL: photoURL ?? this.photoURL,
      roleEmoji: roleEmoji ?? this.roleEmoji,
      sexualRole: sexualRole ?? this.sexualRole,
      compatibility: compatibility ?? this.compatibility,
      isOnline: isOnline ?? this.isOnline,
      matchPercent: matchPercent ?? this.matchPercent,
      isFavorite: isFavorite ?? this.isFavorite,
      distance: distance ?? this.distance,
      isLoading: isLoading ?? this.isLoading,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}

class MockUserGridRepository {
  List<MockUser> getUserProfiles() {
    return [
      MockUser(
        id: '1',
        displayName: 'Alex',
        age: 24,
        roleEmoji: '🔥',
        sexualRole: 'Vers',
        compatibility: '92%',
        isOnline: true,
        matchPercent: 92,
        distance: 2,
      ),
      MockUser(
        id: '2',
        displayName: 'Jordan',
        age: 28,
        roleEmoji: '💎',
        sexualRole: 'Top',
        compatibility: '87%',
        isOnline: false,
        matchPercent: 87,
        distance: 5,
      ),
      MockUser(
        id: '3',
        displayName: 'Ryan',
        age: 26,
        roleEmoji: '⚡',
        sexualRole: 'Bottom',
        compatibility: '94%',
        isOnline: true,
        matchPercent: 94,
        distance: 1,
        isFavorite: true,
      ),
      MockUser(
        id: '4',
        displayName: 'Tyler',
        age: 22,
        roleEmoji: '💪',
        sexualRole: 'Vers',
        compatibility: '78%',
        isOnline: true,
        matchPercent: 78,
        distance: 8,
      ),
      MockUser(
        id: '5',
        displayName: 'Blake',
        age: 30,
        roleEmoji: '🏊',
        sexualRole: 'Top',
        compatibility: '89%',
        isOnline: false,
        matchPercent: 89,
        distance: 12,
      ),
      MockUser(
        id: '6',
        displayName: 'Chase',
        age: 25,
        roleEmoji: '🎯',
        sexualRole: 'Vers',
        compatibility: '91%',
        isOnline: true,
        matchPercent: 91,
        distance: 3,
      ),
      MockUser(
        id: '7',
        displayName: 'Loading User',
        age: 25,
        isLoading: true,
        matchPercent: 0,
        distance: 0,
      ),
      MockUser(
        id: '8',
        displayName: 'Blocked User',
        age: 27,
        isBlocked: true,
        matchPercent: 0,
        distance: 0,
      ),
    ];
  }
}

final mockUserGridRepositoryProvider = Provider<MockUserGridRepository>((ref) {
  return MockUserGridRepository();
});

final mockUserGridListProvider = Provider<List<MockUser>>((ref) {
  final repository = ref.watch(mockUserGridRepositoryProvider);
  return repository.getUserProfiles();
});
