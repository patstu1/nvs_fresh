import 'dart:convert';

class UserGridModel {
  final String id;
  final String displayName;
  final String username;
  final int? age;
  final double? distanceKm;
  final String avatarUrl;
  final bool isOnline;
  final DateTime? lastActive;
  final double? latitude;
  final double? longitude;
  final bool isFavorite;
  final bool isBlocked;
  final bool isLoading;
  final bool isVerified;
  final double? matchPercent;
  final String? roleEmoji;
  final String? sexualRole;
  final List<String> tags;
  final String bio;

  const UserGridModel({
    required this.id,
    required this.displayName,
    required this.username,
    this.age,
    this.distanceKm,
    this.avatarUrl = '',
    this.isOnline = false,
    this.lastActive,
    this.latitude,
    this.longitude,
    this.isFavorite = false,
    this.isBlocked = false,
    this.isLoading = false,
    this.isVerified = false,
    this.matchPercent,
    this.roleEmoji,
    this.sexualRole,
    this.tags = const <String>[],
    this.bio = '',
  });

  String get name => displayName;

  UserGridModel copyWith({
    String? id,
    String? displayName,
    String? username,
    int? age,
    double? distanceKm,
    String? avatarUrl,
    bool? isOnline,
    DateTime? lastActive,
    double? latitude,
    double? longitude,
    bool? isFavorite,
    bool? isBlocked,
    bool? isLoading,
    bool? isVerified,
    double? matchPercent,
    String? roleEmoji,
    String? sexualRole,
    List<String>? tags,
    String? bio,
  }) {
    return UserGridModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      age: age ?? this.age,
      distanceKm: distanceKm ?? this.distanceKm,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavorite: isFavorite ?? this.isFavorite,
      isBlocked: isBlocked ?? this.isBlocked,
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      matchPercent: matchPercent ?? this.matchPercent,
      roleEmoji: roleEmoji ?? this.roleEmoji,
      sexualRole: sexualRole ?? this.sexualRole,
      tags: tags ?? this.tags,
      bio: bio ?? this.bio,
    );
  }

  factory UserGridModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    bool toBool(dynamic value) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final String lower = value.toLowerCase();
        return lower == 'true' || lower == '1' || lower == 'yes' || lower == 'y';
      }
      return false;
    }

    DateTime? toDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString());
    }

    List<String> toStringList(dynamic value) {
      if (value == null) return const <String>[];
      if (value is List) {
        return value
            .map((dynamic e) => e?.toString() ?? '')
            .where((String e) => e.isNotEmpty)
            .toList();
      }
      if (value is String && value.trim().isNotEmpty) {
        try {
          final dynamic decoded = jsonDecode(value);
          if (decoded is List) {
            return decoded
                .map((dynamic e) => e?.toString() ?? '')
                .where((String e) => e.isNotEmpty)
                .toList();
          }
        } catch (_) {
          // Fall through to comma split.
        }
        return value
            .split(',')
            .map((String e) => e.trim())
            .where((String e) => e.isNotEmpty)
            .toList();
      }
      return const <String>[];
    }

    return UserGridModel(
      id: json['id']?.toString() ?? json['uid']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? json['handle']?.toString() ?? '',
      age: toInt(json['age']),
      distanceKm: toDouble(json['distanceKm'] ?? json['distance_km'] ?? json['distance']),
      avatarUrl: json['avatarUrl']?.toString() ?? json['photoUrl']?.toString() ?? '',
      isOnline: toBool(json['isOnline'] ?? json['online']),
      lastActive: toDate(json['lastActive'] ?? json['last_active'] ?? json['lastSeen']),
      latitude: toDouble(json['latitude'] ?? json['lat']),
      longitude: toDouble(json['longitude'] ?? json['lng'] ?? json['lon']),
      isFavorite: toBool(json['isFavorite'] ?? json['favorite']),
      isBlocked: toBool(json['isBlocked'] ?? json['blocked']),
      isLoading: toBool(json['isLoading']),
      isVerified: toBool(json['verified'] ?? json['isVerified']),
      matchPercent: toDouble(json['matchPercent'] ?? json['match_percent'] ?? json['matchScore']),
      roleEmoji: json['roleEmoji']?.toString(),
      sexualRole: json['sexualRole']?.toString() ?? json['role']?.toString(),
      tags: toStringList(json['tags'] ?? json['interests']),
      bio: json['bio']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'displayName': displayName,
    'username': username,
    'age': age,
    'distanceKm': distanceKm,
    'avatarUrl': avatarUrl,
    'isOnline': isOnline,
    'lastActive': lastActive?.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'isFavorite': isFavorite,
    'isBlocked': isBlocked,
    'isLoading': isLoading,
    'isVerified': isVerified,
    'matchPercent': matchPercent,
    'roleEmoji': roleEmoji,
    'sexualRole': sexualRole,
    'tags': tags,
    'bio': bio,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserGridModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UserGridLocation {
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  const UserGridLocation({this.latitude, this.longitude, this.distanceKm});

  UserGridLocation copyWith({double? latitude, double? longitude, double? distanceKm}) {
    return UserGridLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  factory UserGridLocation.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return UserGridLocation(
      latitude: toDouble(json['latitude'] ?? json['lat']),
      longitude: toDouble(json['longitude'] ?? json['lng'] ?? json['lon']),
      distanceKm: toDouble(json['distanceKm'] ?? json['distance_km'] ?? json['distance']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'latitude': latitude,
    'longitude': longitude,
    'distanceKm': distanceKm,
  };
}
