import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// // part '.*.g.dart';

class GeoPointConverter {
  const GeoPointConverter();

  GeoPoint fromJson(Map<String, dynamic> json) {
    return GeoPoint(json['latitude'] as double, json['longitude'] as double);
  }

  Map<String, dynamic> toJson(GeoPoint object) {
    return {'latitude': object.latitude, 'longitude': object.longitude};
  }
}

enum UserMood {
  happy,
  excited,
  calm,
  mysterious,
  playful,
  serious,
}

enum UserRole {
  top,
  bottom,
  vers,
  dom,
  sub,
  switch_,
}

class NowMapUser {
  final String id;
  final String displayName;
  final String? profileImage;
  @GeoPointConverter()
  final GeoPoint location;
  final DateTime lastActive;
  final bool isOnline;
  final bool isAnonymous;
  final List<String> tags;
  final UserMood mood;
  final UserRole? role;
  final Map<String, dynamic> preferences;
  final bool isVerified;
  final double distance; // Calculated distance from current user
  final int age;

  const NowMapUser({
    required this.id,
    required this.displayName,
    this.profileImage,
    required this.location,
    required this.lastActive,
    required this.isOnline,
    required this.isAnonymous,
    required this.tags,
    required this.mood,
    this.role,
    required this.preferences,
    required this.isVerified,
    required this.distance,
    required this.age,
  });

  factory NowMapUser.fromFirestore(
      DocumentSnapshot doc, GeoPoint currentLocation) {
    final data = doc.data() as Map<String, dynamic>;
    final userLocation = data['location'] as GeoPoint;

    return NowMapUser(
      id: doc.id,
      displayName: data['displayName'] ?? 'Anonymous',
      profileImage: data['profileImage'],
      location: userLocation,
      lastActive: (data['lastActive'] as Timestamp).toDate(),
      isOnline: data['isOnline'] ?? false,
      isAnonymous: data['isAnonymous'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      mood: UserMood.values.firstWhere(
        (mood) => mood.name == data['mood'],
        orElse: () => UserMood.calm,
      ),
      role: data['role'] != null
          ? UserRole.values.firstWhere(
              (role) => role.name == data['role'],
              orElse: () => UserRole.vers,
            )
          : null,
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
      isVerified: data['isVerified'] ?? false,
      distance: _calculateDistance(currentLocation, userLocation),
      age: data['age'] ?? 18,
    );
  }

  static double _calculateDistance(GeoPoint point1, GeoPoint point2) {
    const double earthRadius = 6371000; // meters

    final lat1 = point1.latitude * pi / 180;
    final lat2 = point2.latitude * pi / 180;
    final deltaLat = (point2.latitude - point1.latitude) * pi / 180;
    final deltaLng = (point2.longitude - point1.longitude) * pi / 180;

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'profileImage': profileImage,
      'location': location,
      'lastActive': Timestamp.fromDate(lastActive),
      'isOnline': isOnline,
      'isAnonymous': isAnonymous,
      'tags': tags,
      'mood': mood.name,
      'role': role?.name,
      'preferences': preferences,
      'isVerified': isVerified,
      'distance': distance,
      'age': age,
    };
  }

  NowMapUser copyWith({
    String? id,
    String? displayName,
    String? profileImage,
    GeoPoint? location,
    DateTime? lastActive,
    bool? isOnline,
    bool? isAnonymous,
    List<String>? tags,
    UserMood? mood,
    UserRole? role,
    Map<String, dynamic>? preferences,
    bool? isVerified,
    double? distance,
    int? age,
  }) {
    return NowMapUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
      lastActive: lastActive ?? this.lastActive,
      isOnline: isOnline ?? this.isOnline,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
      role: role ?? this.role,
      preferences: preferences ?? this.preferences,
      isVerified: isVerified ?? this.isVerified,
      distance: distance ?? this.distance,
      age: age ?? this.age,
    );
  }
}

class UserCluster {
  final String id;
  @GeoPointConverter()
  final GeoPoint center;
  final List<NowMapUser> users;
  final double radius;
  final Color clusterColor;

  const UserCluster({
    required this.id,
    required this.center,
    required this.users,
    required this.radius,
    required this.clusterColor,
  });

  int get userCount => users.length;
  bool get isSingleUser => users.length == 1;
  NowMapUser? get singleUser => isSingleUser ? users.first : null;

  Color get glowColor {
    if (users.isEmpty) return Colors.transparent;

    // Calculate average mood and activity
    final onlineCount = users.where((u) => u.isOnline).length;
    final verifiedCount = users.where((u) => u.isVerified).length;

    if (onlineCount > 0) {
      return const Color(0xFF4BEFE0); // Mint glow for online users
    } else if (verifiedCount > 0) {
      return Colors.blue; // Blue for verified users
    } else {
      return Colors.grey; // Grey for offline users
    }
  }

  double get pulseIntensity {
    final onlineCount = users.where((u) => u.isOnline).length;
    return onlineCount > 0 ? 0.8 : 0.3;
  }
}

class MapFilters {
  final List<String> tags;
  final double maxDistance;
  final List<UserMood> moods;
  final List<UserRole> roles;
  final bool showOnlineOnly;
  final bool showVerifiedOnly;
  final bool showAnonymous;
  final int? minAge;
  final int? maxAge;
  final bool showProfilesWithImagesOnly;
  final Duration? lastActive;
  final String? searchQuery;

  const MapFilters({
    this.tags = const [],
    this.maxDistance = 50000, // 50km default
    this.moods = const [],
    this.roles = const [],
    this.showOnlineOnly = false,
    this.showVerifiedOnly = false,
    this.showAnonymous = true,
    this.minAge,
    this.maxAge,
    this.showProfilesWithImagesOnly = false,
    this.lastActive,
    this.searchQuery,
  });

  MapFilters copyWith({
    List<String>? tags,
    double? maxDistance,
    List<UserMood>? moods,
    List<UserRole>? roles,
    bool? showOnlineOnly,
    bool? showVerifiedOnly,
    bool? showAnonymous,
    int? minAge,
    int? maxAge,
    bool? showProfilesWithImagesOnly,
    Duration? lastActive,
    String? searchQuery,
  }) {
    return MapFilters(
      tags: tags ?? this.tags,
      maxDistance: maxDistance ?? this.maxDistance,
      moods: moods ?? this.moods,
      roles: roles ?? this.roles,
      showOnlineOnly: showOnlineOnly ?? this.showOnlineOnly,
      showVerifiedOnly: showVerifiedOnly ?? this.showVerifiedOnly,
      showAnonymous: showAnonymous ?? this.showAnonymous,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      showProfilesWithImagesOnly:
          showProfilesWithImagesOnly ?? this.showProfilesWithImagesOnly,
      lastActive: lastActive ?? this.lastActive,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool matchesUser(NowMapUser user) {
    // Distance filter
    if (user.distance > maxDistance) return false;

    // Online only
    if (showOnlineOnly && !user.isOnline) return false;

    // Verified only
    if (showVerifiedOnly && !user.isVerified) return false;

    // Anonymous filter
    if (!showAnonymous && user.isAnonymous) return false;

    // Age filter
    if (minAge != null && user.age < minAge!) return false;
    if (maxAge != null && user.age > maxAge!) return false;

    // Last active filter
    if (lastActive != null &&
        DateTime.now().difference(user.lastActive) > lastActive!) {
      return false;
    }

    // Profiles with images only
    if (showProfilesWithImagesOnly &&
        (user.profileImage == null || user.profileImage!.isEmpty)) {
      return false;
    }

    // Tag filter
    if (tags.isNotEmpty && !tags.any((tag) => user.tags.contains(tag))) {
      return false;
    }

    // Mood filter
    if (moods.isNotEmpty && !moods.contains(user.mood)) return false;

    // Role filter
    if (roles.isNotEmpty && (user.role == null || !roles.contains(user.role))) {
      return false;
    }

    // Search query filter
    if (searchQuery != null &&
        searchQuery!.isNotEmpty &&
        !user.displayName.toLowerCase().contains(searchQuery!.toLowerCase())) {
      return false;
    }

    return true;
  }
}

class MapViewState {
  final GeoPoint? currentLocation;
  final List<NowMapUser> nearbyUsers;
  final List<UserCluster> clusters;
  final MapFilters filters;
  final bool isAnonymous;
  final bool isLoading;
  final String? error;

  const MapViewState({
    this.currentLocation,
    this.nearbyUsers = const [],
    this.clusters = const [],
    this.filters = const MapFilters(),
    this.isAnonymous = false,
    this.isLoading = false,
    this.error,
  });

  MapViewState copyWith({
    GeoPoint? currentLocation,
    List<NowMapUser>? nearbyUsers,
    List<UserCluster>? clusters,
    MapFilters? filters,
    bool? isAnonymous,
    bool? isLoading,
    String? error,
  }) {
    return MapViewState(
      currentLocation: currentLocation ?? this.currentLocation,
      nearbyUsers: nearbyUsers ?? this.nearbyUsers,
      clusters: clusters ?? this.clusters,
      filters: filters ?? this.filters,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
