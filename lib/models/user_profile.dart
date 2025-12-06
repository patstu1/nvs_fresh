// packages/core/lib/models/user_profile.dart
import 'package:nvs/models/user_preferences.dart';
import 'package:nvs/models/user_stats.dart';
import 'package:nvs/models/user_status.dart';
import 'package:nvs/models/subscription_info.dart';
import 'package:nvs/models/verification_info.dart';
import 'package:nvs/models/privacy_settings.dart';

class UserProfile {
  final String id;
  final String displayName;
  final String? photoURL; // Made nullable for consistency
  final String avatarUrl; // Add required avatarUrl property
  final int age;
  final String email;
  final String name;
  final String location;
  final List<String> interests;
  final UserPreferences preferences;
  final UserStats stats;
  final UserStatus status;
  final SubscriptionInfo subscription;
  final VerificationInfo verification;
  final PrivacySettings privacy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;
  final DateTime lastSeen;
  final bool isVerified;
  final String? bio;
  final String? gender;
  final String? roleEmoji;
  final String? sexualRole;
  final double? compatibility;

  // Computed getters for compatibility
  UserStatusType get statusType => status.status;

  // Copy with method for updating profile
  UserProfile copyWith({
    String? id,
    String? displayName,
    String? photoURL,
    String? avatarUrl,
    int? age,
    String? email,
    String? name,
    String? location,
    List<String>? interests,
    UserPreferences? preferences,
    UserStats? stats,
    UserStatus? status,
    SubscriptionInfo? subscription,
    VerificationInfo? verification,
    PrivacySettings? privacy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActiveAt,
    DateTime? lastSeen,
    bool? isVerified,
    String? bio,
    String? gender,
    String? roleEmoji,
    String? sexualRole,
    double? compatibility,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      email: email ?? this.email,
      name: name ?? this.name,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      verification: verification ?? this.verification,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isVerified: isVerified ?? this.isVerified,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      roleEmoji: roleEmoji ?? this.roleEmoji,
      sexualRole: sexualRole ?? this.sexualRole,
      compatibility: compatibility ?? this.compatibility,
    );
  }

  UserProfile({
    required this.id,
    required this.displayName,
    this.photoURL,
    required this.avatarUrl,
    required this.age,
    required this.email,
    required this.name,
    required this.location,
    required this.interests,
    required this.preferences,
    required this.stats,
    required this.status,
    required this.subscription,
    required this.verification,
    required this.privacy,
    required this.createdAt,
    required this.updatedAt,
    this.lastActiveAt,
    required this.lastSeen,
    required this.isVerified,
    this.bio,
    this.gender,
    this.roleEmoji,
    this.sexualRole,
    this.compatibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoURL': photoURL,
      'avatarUrl': avatarUrl,
      'age': age,
      'email': email,
      'name': name,
      'location': location,
      'interests': interests,
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
      'status': status.toJson(),
      'subscription': subscription.toJson(),
      'verification': verification.toJson(),
      'privacy': privacy.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'lastSeen': lastSeen.toIso8601String(),
      'isVerified': isVerified,
      'bio': bio,
      'gender': gender,
      'roleEmoji': roleEmoji,
      'sexualRole': sexualRole,
      'compatibility': compatibility,
    };
  }

  factory UserProfile.fromFirestore(Map<String, dynamic> doc) {
    return UserProfile(
      id: doc['id'] ?? '',
      displayName: doc['displayName'] ?? '',
      photoURL: doc['photoURL'],
      avatarUrl: doc['avatarUrl'] ?? doc['photoURL'] ?? '',
      age: doc['age'] ?? 0,
      email: doc['email'] ?? '',
      name: doc['name'] ?? '',
      location: doc['location'] ?? '',
      interests: List<String>.from(doc['interests'] ?? []),
      preferences: const UserPreferences(),
      stats: const UserStats(),
      status: UserStatus.online(),
      subscription: const SubscriptionInfo(),
      verification: VerificationInfo.unverified(),
      privacy: const PrivacySettings(),
      createdAt: DateTime.parse(
        doc['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        doc['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      lastActiveAt: doc['lastActiveAt'] != null
          ? DateTime.parse(doc['lastActiveAt'])
          : null,
      lastSeen: DateTime.parse(
        doc['lastSeen'] ?? DateTime.now().toIso8601String(),
      ),
      isVerified: doc['isVerified'] ?? false,
      bio: doc['bio'],
      gender: doc['gender'],
      roleEmoji: doc['roleEmoji'],
      sexualRole: doc['sexualRole'],
      compatibility: doc['compatibility']?.toDouble(),
    );
  }
}
