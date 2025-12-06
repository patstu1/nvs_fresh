// lib/features/now/domain/models/now_user_model_new.dart

class NowUser {
  final String id;
  final String name;
  final String avatarUrl;
  final int age;
  final double latitude;
  final double longitude;
  final String distance;
  final List<String> tags;
  final String status;
  final DateTime lastSeen;
  final bool isOnline;
  final bool isVerified;
  final String? mood;
  final String? activity;
  final int? matchPercentage;

  const NowUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.age,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.tags,
    required this.status,
    required this.lastSeen,
    this.isOnline = false,
    this.isVerified = false,
    this.mood,
    this.activity,
    this.matchPercentage,
  });

  NowUser copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? age,
    double? latitude,
    double? longitude,
    String? distance,
    List<String>? tags,
    String? status,
    DateTime? lastSeen,
    bool? isOnline,
    bool? isVerified,
    String? mood,
    String? activity,
    int? matchPercentage,
  }) {
    return NowUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      mood: mood ?? this.mood,
      activity: activity ?? this.activity,
      matchPercentage: matchPercentage ?? this.matchPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'age': age,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'tags': tags,
      'status': status,
      'lastSeen': lastSeen.toIso8601String(),
      'isOnline': isOnline,
      'isVerified': isVerified,
      'mood': mood,
      'activity': activity,
      'matchPercentage': matchPercentage,
    };
  }

  static NowUser fromJson(Map<String, dynamic> json) {
    return NowUser(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      age: json['age'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: json['distance'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] as String,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      isOnline: json['isOnline'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      mood: json['mood'] as String?,
      activity: json['activity'] as String?,
      matchPercentage: json['matchPercentage'] as int?,
    );
  }

  // Helper getters
  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String get displayTags {
    return tags.take(3).join(' • ');
  }

  String get onlineStatus {
    if (!isOnline) return 'Offline';
    if (activity != null) return activity!;
    return 'Online';
  }

  bool get isNearby {
    final distanceValue = double.tryParse(distance.replaceAll(RegExp(r'[^\d.]'), ''));
    return distanceValue != null && distanceValue <= 1.0; // Within 1km
  }
}