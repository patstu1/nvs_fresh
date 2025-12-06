// lib/core/models/album_models.dart

/// Photo model for secure media management
class PhotoModel {
  const PhotoModel({
    required this.id,
    required this.filename,
    required this.uploadedAt,
    required this.type,
    this.ipfsHash,
    this.encryptionKey,
    this.isVerified = false,
    this.metadata,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String,
      filename: json['filename'] as String,
      ipfsHash: json['ipfsHash'] as String?,
      encryptionKey: json['encryptionKey'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      type: PhotoType.values.byName(json['type'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
  final String id;
  final String filename;
  final String? ipfsHash;
  final String? encryptionKey;
  final DateTime uploadedAt;
  final PhotoType type;
  final bool isVerified;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'filename': filename,
      'ipfsHash': ipfsHash,
      'encryptionKey': encryptionKey,
      'uploadedAt': uploadedAt.toIso8601String(),
      'type': type.name,
      'isVerified': isVerified,
      'metadata': metadata,
    };
  }

  PhotoModel copyWith({
    String? id,
    String? filename,
    String? ipfsHash,
    String? encryptionKey,
    DateTime? uploadedAt,
    PhotoType? type,
    bool? isVerified,
    Map<String, dynamic>? metadata,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      ipfsHash: ipfsHash ?? this.ipfsHash,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      type: type ?? this.type,
      isVerified: isVerified ?? this.isVerified,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Photo album model for organizing media
class AlbumModel {
  const AlbumModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.privacy,
    required this.photoIds,
    required this.createdAt,
    required this.updatedAt,
    this.isLocked = false,
    this.coverPhotoId,
    this.settings,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: AlbumType.values.byName(json['type'] as String),
      privacy: AlbumPrivacy.values.byName(json['privacy'] as String),
      photoIds: List<String>.from(json['photoIds'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isLocked: json['isLocked'] as bool? ?? false,
      coverPhotoId: json['coverPhotoId'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }
  final String id;
  final String name;
  final String description;
  final AlbumType type;
  final AlbumPrivacy privacy;
  final List<String> photoIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLocked;
  final String? coverPhotoId;
  final Map<String, dynamic>? settings;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'privacy': privacy.name,
      'photoIds': photoIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isLocked': isLocked,
      'coverPhotoId': coverPhotoId,
      'settings': settings,
    };
  }

  AlbumModel copyWith({
    String? id,
    String? name,
    String? description,
    AlbumType? type,
    AlbumPrivacy? privacy,
    List<String>? photoIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLocked,
    String? coverPhotoId,
    Map<String, dynamic>? settings,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      privacy: privacy ?? this.privacy,
      photoIds: photoIds ?? this.photoIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLocked: isLocked ?? this.isLocked,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      settings: settings ?? this.settings,
    );
  }

  int get photoCount => photoIds.length;
}

/// Anonymous reveal request model
class RevealRequest {
  const RevealRequest({
    required this.id,
    required this.requesterId,
    required this.targetUserId,
    required this.albumId,
    required this.status,
    required this.requestedAt,
    this.respondedAt,
    this.expiresAt,
    this.message,
    this.metadata,
  });

  factory RevealRequest.fromJson(Map<String, dynamic> json) {
    return RevealRequest(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      targetUserId: json['targetUserId'] as String,
      albumId: json['albumId'] as String,
      status: RevealRequestStatus.values.byName(json['status'] as String),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      respondedAt:
          json['respondedAt'] != null ? DateTime.parse(json['respondedAt'] as String) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      message: json['message'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
  final String id;
  final String requesterId;
  final String targetUserId;
  final String albumId;
  final RevealRequestStatus status;
  final DateTime requestedAt;
  final DateTime? respondedAt;
  final DateTime? expiresAt;
  final String? message;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'requesterId': requesterId,
      'targetUserId': targetUserId,
      'albumId': albumId,
      'status': status.name,
      'requestedAt': requestedAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'message': message,
      'metadata': metadata,
    };
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool get isPending => status == RevealRequestStatus.pending && !isExpired;
}

/// Enums for album system
enum PhotoType {
  public,
  private,
  mask,
  verified,
  nsfw,
}

enum AlbumType {
  standard,
  mask,
  verified,
  premium,
  system,
}

enum AlbumPrivacy {
  public,
  private,
  friends,
  premium,
  anonymous,
}

enum RevealRequestStatus {
  pending,
  approved,
  denied,
  expired,
  revoked,
}

/// Vault service for managing photo albums
class VaultService {
  static const String maskAlbumId = 'mask_album';

  /// Create the special Mask album for anonymous profile photos
  static AlbumModel createMaskAlbum() {
    return AlbumModel(
      id: maskAlbumId,
      name: 'THE MASK',
      description: 'Photos for your Anonymous Profile in NOW section',
      type: AlbumType.mask,
      privacy: AlbumPrivacy.anonymous,
      photoIds: <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      settings: <String, dynamic>{
        'encryption': 'aes256',
        'zeroKnowledge': true,
        'consentRequired': true,
        'autoExpire': true,
        'maxRevealTime': 3600, // 1 hour
      },
    );
  }

  /// Create default user albums
  static List<AlbumModel> createDefaultAlbums() {
    final DateTime now = DateTime.now();

    return <AlbumModel>[
      createMaskAlbum(), // The special Mask album
      AlbumModel(
        id: 'public_gallery',
        name: 'PUBLIC GALLERY',
        description: 'Photos visible to all users',
        type: AlbumType.standard,
        privacy: AlbumPrivacy.public,
        photoIds: <String>[],
        createdAt: now,
        updatedAt: now,
      ),
      AlbumModel(
        id: 'private_collection',
        name: 'PRIVATE COLLECTION',
        description: 'Personal photos for close connections',
        type: AlbumType.standard,
        privacy: AlbumPrivacy.private,
        photoIds: <String>[],
        createdAt: now,
        updatedAt: now,
        isLocked: true,
      ),
      AlbumModel(
        id: 'verified_shots',
        name: 'VERIFIED SHOTS',
        description: 'Verified photos with authenticity badges',
        type: AlbumType.verified,
        privacy: AlbumPrivacy.public,
        photoIds: <String>[],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Generate reveal token for anonymous photo access
  static String generateRevealToken({
    required String requesterId,
    required String albumId,
    required Duration validFor,
  }) {
    // In production, this would generate a secure, encrypted token
    // with zero-knowledge proof capabilities
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final int expiry = DateTime.now().add(validFor).millisecondsSinceEpoch;

    return 'reveal_${requesterId}_${albumId}_${timestamp}_$expiry';
  }

  /// Check if a reveal token is valid
  static bool isRevealTokenValid(String token) {
    try {
      final List<String> parts = token.split('_');
      if (parts.length != 5) return false;

      final int expiry = int.parse(parts[4]);
      return DateTime.now().millisecondsSinceEpoch < expiry;
    } catch (e) {
      return false;
    }
  }
}
