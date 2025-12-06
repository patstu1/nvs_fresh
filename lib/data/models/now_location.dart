import 'package:google_maps_flutter/google_maps_flutter.dart';

class NowLocation {
  final String id;
  final double latitude;
  final double longitude;
  final String? customName;
  final LocationType type;
  final PrivacyLevel privacyLevel;
  final AnonymitySettings anonymitySettings;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final String? encryptedUserId;
  final String? sessionToken;

  const NowLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.customName,
    required this.type,
    required this.privacyLevel,
    required this.anonymitySettings,
    this.metadata = const {},
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
    this.encryptedUserId,
    this.sessionToken,
  });

  // Create a completely anonymous location
  factory NowLocation.createAnonymous({
    required double latitude,
    required double longitude,
    LocationType type = LocationType.private,
    Duration? duration,
  }) {
    return NowLocation(
      id: _generateAnonymousId(),
      latitude: latitude,
      longitude: longitude,
      type: type,
      privacyLevel: PrivacyLevel.maximum,
      anonymitySettings: AnonymitySettings.maximum(),
      createdAt: DateTime.now(),
      expiresAt: duration != null ? DateTime.now().add(duration) : null,
      encryptedUserId: _generateEncryptedId(),
      sessionToken: _generateSessionToken(),
    );
  }

  // Create a private location with custom settings
  factory NowLocation.createPrivate({
    required double latitude,
    required double longitude,
    String? customName,
    PrivacyLevel privacyLevel = PrivacyLevel.high,
    AnonymitySettings? anonymitySettings,
    Map<String, dynamic>? metadata,
    Duration? duration,
  }) {
    return NowLocation(
      id: _generateAnonymousId(),
      latitude: latitude,
      longitude: longitude,
      customName: customName,
      type: LocationType.private,
      privacyLevel: privacyLevel,
      anonymitySettings: anonymitySettings ?? AnonymitySettings.high(),
      metadata: metadata ?? {},
      createdAt: DateTime.now(),
      expiresAt: duration != null ? DateTime.now().add(duration) : null,
      encryptedUserId: _generateEncryptedId(),
      sessionToken: _generateSessionToken(),
    );
  }

  // Generate anonymous ID
  static String _generateAnonymousId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'now_${random}_${DateTime.now().microsecondsSinceEpoch}';
  }

  // Generate encrypted user ID
  static String _generateEncryptedId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'enc_${random}_${DateTime.now().microsecondsSinceEpoch}';
  }

  // Generate session token
  static String _generateSessionToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'sess_${random}_${DateTime.now().microsecondsSinceEpoch}';
  }

  // Convert to Google Maps LatLng
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  // Check if location is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  // Get display name (respects anonymity)
  String get displayName {
    if (anonymitySettings.hideName) {
      return 'Anonymous';
    }
    return customName ?? 'Private Location';
  }

  // Get privacy description
  String get privacyDescription {
    switch (privacyLevel) {
      case PrivacyLevel.maximum:
        return 'Maximum Privacy - Completely Anonymous';
      case PrivacyLevel.high:
        return 'High Privacy - Limited Visibility';
      case PrivacyLevel.medium:
        return 'Medium Privacy - Selective Visibility';
      case PrivacyLevel.low:
        return 'Low Privacy - Public Visibility';
    }
  }

  // Copy with updates
  NowLocation copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? customName,
    LocationType? type,
    PrivacyLevel? privacyLevel,
    AnonymitySettings? anonymitySettings,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
    String? encryptedUserId,
    String? sessionToken,
  }) {
    return NowLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      customName: customName ?? this.customName,
      type: type ?? this.type,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      anonymitySettings: anonymitySettings ?? this.anonymitySettings,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      encryptedUserId: encryptedUserId ?? this.encryptedUserId,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  // Convert to JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'customName': customName,
      'type': type.name,
      'privacyLevel': privacyLevel.name,
      'anonymitySettings': anonymitySettings.toJson(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'encryptedUserId': encryptedUserId,
      'sessionToken': sessionToken,
    };
  }

  // Create from JSON
  factory NowLocation.fromJson(Map<String, dynamic> json) {
    return NowLocation(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      customName: json['customName'],
      type: LocationType.values.firstWhere((e) => e.name == json['type']),
      privacyLevel:
          PrivacyLevel.values.firstWhere((e) => e.name == json['privacyLevel']),
      anonymitySettings: AnonymitySettings.fromJson(json['anonymitySettings']),
      metadata: json['metadata'] ?? {},
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt:
          json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      isActive: json['isActive'] ?? true,
      encryptedUserId: json['encryptedUserId'],
      sessionToken: json['sessionToken'],
    );
  }
}

enum LocationType {
  private,
  public,
  temporary,
  secret,
  exclusive,
}

enum PrivacyLevel {
  maximum,
  high,
  medium,
  low,
}

class AnonymitySettings {
  final bool hideName;
  final bool hideProfile;
  final bool hideLocation;
  final bool hideTimestamp;
  final bool useProxy;
  final bool encryptData;
  final bool maskMetadata;
  final bool randomizeId;

  const AnonymitySettings({
    this.hideName = true,
    this.hideProfile = true,
    this.hideLocation = false,
    this.hideTimestamp = false,
    this.useProxy = true,
    this.encryptData = true,
    this.maskMetadata = true,
    this.randomizeId = true,
  });

  // Maximum anonymity
  factory AnonymitySettings.maximum() {
    return const AnonymitySettings(
      hideName: true,
      hideProfile: true,
      hideLocation: false,
      hideTimestamp: true,
      useProxy: true,
      encryptData: true,
      maskMetadata: true,
      randomizeId: true,
    );
  }

  // High anonymity
  factory AnonymitySettings.high() {
    return const AnonymitySettings(
      hideName: true,
      hideProfile: true,
      hideLocation: false,
      hideTimestamp: false,
      useProxy: true,
      encryptData: true,
      maskMetadata: true,
      randomizeId: true,
    );
  }

  // Medium anonymity
  factory AnonymitySettings.medium() {
    return const AnonymitySettings(
      hideName: false,
      hideProfile: false,
      hideLocation: false,
      hideTimestamp: false,
      useProxy: true,
      encryptData: true,
      maskMetadata: false,
      randomizeId: false,
    );
  }

  // Low anonymity
  factory AnonymitySettings.low() {
    return const AnonymitySettings(
      hideName: false,
      hideProfile: false,
      hideLocation: false,
      hideTimestamp: false,
      useProxy: false,
      encryptData: false,
      maskMetadata: false,
      randomizeId: false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'hideName': hideName,
      'hideProfile': hideProfile,
      'hideLocation': hideLocation,
      'hideTimestamp': hideTimestamp,
      'useProxy': useProxy,
      'encryptData': encryptData,
      'maskMetadata': maskMetadata,
      'randomizeId': randomizeId,
    };
  }

  // Create from JSON
  factory AnonymitySettings.fromJson(Map<String, dynamic> json) {
    return AnonymitySettings(
      hideName: json['hideName'] ?? true,
      hideProfile: json['hideProfile'] ?? true,
      hideLocation: json['hideLocation'] ?? false,
      hideTimestamp: json['hideTimestamp'] ?? false,
      useProxy: json['useProxy'] ?? true,
      encryptData: json['encryptData'] ?? true,
      maskMetadata: json['maskMetadata'] ?? true,
      randomizeId: json['randomizeId'] ?? true,
    );
  }

  // Copy with updates
  AnonymitySettings copyWith({
    bool? hideName,
    bool? hideProfile,
    bool? hideLocation,
    bool? hideTimestamp,
    bool? useProxy,
    bool? encryptData,
    bool? maskMetadata,
    bool? randomizeId,
  }) {
    return AnonymitySettings(
      hideName: hideName ?? this.hideName,
      hideProfile: hideProfile ?? this.hideProfile,
      hideLocation: hideLocation ?? this.hideLocation,
      hideTimestamp: hideTimestamp ?? this.hideTimestamp,
      useProxy: useProxy ?? this.useProxy,
      encryptData: encryptData ?? this.encryptData,
      maskMetadata: maskMetadata ?? this.maskMetadata,
      randomizeId: randomizeId ?? this.randomizeId,
    );
  }
}
