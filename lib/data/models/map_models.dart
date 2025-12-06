// packages/now/lib/data/models/map_models.dart

import 'package:nvs/meatup_core.dart';

/// Model for user aura data on the map
class AuraData {
  final String userId;
  final double intensity; // 0.0 to 1.0
  final String vibeType; // 'pulse', 'glow', 'flare'
  final Color color;
  final bool isOnline;
  final DateTime lastActivity;

  const AuraData({
    required this.userId,
    required this.intensity,
    required this.vibeType,
    required this.color,
    required this.isOnline,
    required this.lastActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'intensity': intensity,
      'vibeType': vibeType,
      'color': color.value,
      'isOnline': isOnline,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  factory AuraData.fromJson(Map<String, dynamic> json) {
    return AuraData(
      userId: json['userId'],
      intensity: (json['intensity'] as num).toDouble(),
      vibeType: json['vibeType'],
      color: Color(json['color']),
      isOnline: json['isOnline'],
      lastActivity: DateTime.parse(json['lastActivity']),
    );
  }
}

/// Model for map user with location and aura
class MapUser {
  final String id;
  final double lat;
  final double lon;
  final AuraData auraData;
  final UserProfile? profile; // Optional full profile data

  const MapUser({
    required this.id,
    required this.lat,
    required this.lon,
    required this.auraData,
    this.profile,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lon': lon,
      'auraData': auraData.toJson(),
      if (profile != null) 'profile': profile!.toJson(),
    };
  }

  factory MapUser.fromJson(Map<String, dynamic> json) {
    return MapUser(
      id: json['id'],
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      auraData: AuraData.fromJson(json['auraData']),
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
    );
  }
}

/// Model for live feed posts on the map
class LiveFeedPost {
  final String postId;
  final String userId;
  final double lat;
  final double lon;
  final String text;
  final DateTime expiration;
  final DateTime createdAt;

  const LiveFeedPost({
    required this.postId,
    required this.userId,
    required this.lat,
    required this.lon,
    required this.text,
    required this.expiration,
    required this.createdAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiration);

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'lat': lat,
      'lon': lon,
      'text': text,
      'expiration': expiration.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LiveFeedPost.fromJson(Map<String, dynamic> json) {
    return LiveFeedPost(
      postId: json['postId'],
      userId: json['userId'],
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      text: json['text'],
      expiration: DateTime.parse(json['expiration']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// Model for vibe pulse events
class VibePulse {
  final String fromUserId;
  final String toUserId;
  final DateTime timestamp;
  final String pulseType; // 'yo', 'wave', 'spark'

  const VibePulse({
    required this.fromUserId,
    required this.toUserId,
    required this.timestamp,
    required this.pulseType,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'timestamp': timestamp.toIso8601String(),
      'pulseType': pulseType,
    };
  }

  factory VibePulse.fromJson(Map<String, dynamic> json) {
    return VibePulse(
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      timestamp: DateTime.parse(json['timestamp']),
      pulseType: json['pulseType'],
    );
  }
}

/// Base class for WebSocket events
abstract class MapEvent {
  final String type;
  final DateTime timestamp;

  const MapEvent({required this.type, required this.timestamp});

  Map<String, dynamic> toJson();

  static MapEvent fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final timestamp = DateTime.parse(json['timestamp']);

    switch (type) {
      case 'batch_user_update':
        return BatchUserUpdateEvent.fromJson(json);
      case 'user_update':
        return UserUpdateEvent.fromJson(json);
      case 'user_leave':
        return UserLeaveEvent.fromJson(json);
      case 'vibe_pulse':
        return VibePulseEvent.fromJson(json);
      case 'new_feed_post':
        return NewFeedPostEvent.fromJson(json);
      default:
        throw ArgumentError('Unknown event type: $type');
    }
  }
}

/// Event for initial batch of users
class BatchUserUpdateEvent extends MapEvent {
  final List<MapUser> users;

  const BatchUserUpdateEvent({required this.users, required super.timestamp})
    : super(type: 'batch_user_update');

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'users': users.map((u) => u.toJson()).toList(),
    };
  }

  factory BatchUserUpdateEvent.fromJson(Map<String, dynamic> json) {
    return BatchUserUpdateEvent(
      users: (json['users'] as List).map((u) => MapUser.fromJson(u)).toList(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Event for single user update
class UserUpdateEvent extends MapEvent {
  final MapUser user;

  const UserUpdateEvent({required this.user, required super.timestamp})
    : super(type: 'user_update');

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'user': user.toJson(),
    };
  }

  factory UserUpdateEvent.fromJson(Map<String, dynamic> json) {
    return UserUpdateEvent(
      user: MapUser.fromJson(json['user']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Event for user leaving
class UserLeaveEvent extends MapEvent {
  final String userId;

  const UserLeaveEvent({required this.userId, required super.timestamp})
    : super(type: 'user_leave');

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'id': userId,
    };
  }

  factory UserLeaveEvent.fromJson(Map<String, dynamic> json) {
    return UserLeaveEvent(
      userId: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Event for vibe pulse between users
class VibePulseEvent extends MapEvent {
  final VibePulse pulse;

  const VibePulseEvent({required this.pulse, required super.timestamp})
    : super(type: 'vibe_pulse');

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'fromUserId': pulse.fromUserId,
      'toUserId': pulse.toUserId,
      'pulseType': pulse.pulseType,
    };
  }

  factory VibePulseEvent.fromJson(Map<String, dynamic> json) {
    return VibePulseEvent(
      pulse: VibePulse(
        fromUserId: json['fromUserId'],
        toUserId: json['toUserId'],
        timestamp: DateTime.parse(json['timestamp']),
        pulseType: json['pulseType'] ?? 'yo',
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Event for new feed post
class NewFeedPostEvent extends MapEvent {
  final LiveFeedPost post;

  const NewFeedPostEvent({required this.post, required super.timestamp})
    : super(type: 'new_feed_post');

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'post': post.toJson(),
    };
  }

  factory NewFeedPostEvent.fromJson(Map<String, dynamic> json) {
    return NewFeedPostEvent(
      post: LiveFeedPost.fromJson(json['post']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}








