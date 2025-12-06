// packages/core/lib/models/user_profile_quantum.dart

import 'package:meta/meta.dart';
import 'user_status.dart';

// Represents the off-chain data stored on IPFS.
// This is the JSON file the on-chain URI points to.
@immutable
class UserProfileIpfsData {
  final String displayName;
  final String? bio;
  final String photoURL; // CID for the main profile image on IPFS
  final List<String> interestTags;
  final String gender;
  final String sexualRole;
  // ... other mutable, less critical data

  const UserProfileIpfsData({
    required this.displayName,
    this.bio,
    required this.photoURL,
    required this.interestTags,
    required this.gender,
    required this.sexualRole,
  });

  // Factory for deserializing from JSON fetched from IPFS
  factory UserProfileIpfsData.fromJson(Map<String, dynamic> json) {
    return UserProfileIpfsData(
      displayName: json['displayName'],
      bio: json['bio'],
      photoURL: json['photoURL'],
      interestTags: List<String>.from(json['interestTags'] ?? []),
      gender: json['gender'],
      sexualRole: json['sexualRole'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'bio': bio,
      'photoURL': photoURL,
      'interestTags': interestTags,
      'gender': gender,
      'sexualRole': sexualRole,
    };
  }
}

// The main UserProfile model, representing the complete, resolved identity.
@immutable
class UserProfileQuantum {
  // --- ON-CHAIN DATA ---
  // The user's Solana wallet address. This is the primary key.
  final String walletAddress;
  // The address of the NVS Profile account (PDA).
  final String profileNftAddress;
  // URI to the IPFS data. e.g., "ipfs://bafy...".
  final String ipfsDataUri;
  // 0: Unverified, 1: Verified, 2: Premium
  final int verificationStatus;
  final DateTime lastActive;

  // --- OFF-CHAIN DATA (from IPFS) ---
  final UserProfileIpfsData? offChainData;

  // --- REAL-TIME & COMPUTED DATA ---
  final UserStatusType statusType;
  final double? compatibilityScore; // Computed by the AI service

  const UserProfileQuantum({
    required this.walletAddress,
    required this.profileNftAddress,
    required this.ipfsDataUri,
    required this.verificationStatus,
    required this.lastActive,
    this.offChainData,
    this.statusType = UserStatusType.offline,
    this.compatibilityScore,
  });

  // This copyWith is for updating with real-time or computed data,
  // as the core identity is immutable.
  UserProfileQuantum copyWith({
    UserStatusType? statusType,
    double? compatibilityScore,
    UserProfileIpfsData? offChainData,
  }) {
    return UserProfileQuantum(
      walletAddress: walletAddress,
      profileNftAddress: profileNftAddress,
      ipfsDataUri: ipfsDataUri,
      verificationStatus: verificationStatus,
      lastActive: lastActive,
      offChainData: offChainData ?? this.offChainData,
      statusType: statusType ?? this.statusType,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
    );
  }

  // Factory for creating from on-chain data
  factory UserProfileQuantum.fromOnChainData({
    required String walletAddress,
    required String profileNftAddress,
    required String ipfsDataUri,
    required int verificationStatus,
    required DateTime lastActive,
  }) {
    return UserProfileQuantum(
      walletAddress: walletAddress,
      profileNftAddress: profileNftAddress,
      ipfsDataUri: ipfsDataUri,
      verificationStatus: verificationStatus,
      lastActive: lastActive,
    );
  }

  // Computed getters
  bool get isVerified => verificationStatus >= 1;
  bool get isPremium => verificationStatus >= 2;
  String get displayName => offChainData?.displayName ?? 'Anonymous';
  String? get bio => offChainData?.bio;
  String get avatarUrl => offChainData?.photoURL ?? '';

  // Legacy compatibility getters for migration
  String get id => walletAddress;
  String get name => displayName;
  int get age => 25; // Will be computed from birth data in IPFS
  String get email => ''; // Not stored in decentralized system
  String get location => ''; // Will be computed from real-time data
  List<String> get interests => offChainData?.interestTags ?? [];
}

// UserStatusType enum moved to user_status.dart to avoid conflicts
