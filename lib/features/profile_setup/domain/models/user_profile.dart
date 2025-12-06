// lib/features/profile_setup/domain/models/user_profile.dart

class UserProfile {
  const UserProfile({
    required this.userId,
    required this.displayName,
    this.age,
    this.pronouns,
    this.gender,
    this.position,
    this.aboutMe,
    this.bodyType,
    this.heightCm,
    this.weightKg,
    this.roleTags = const <String>[],
    this.moodTags = const <String>[],
    this.traits = const <String>[],
    this.profilePhotoUrl,
    this.privateAlbumUrls = const <String>[],
    this.showAge,
    this.isIncognito,
    this.showDistance,
    this.hasVerifiedStatus,
    this.instagram,
    this.twitter,
    this.spotify,
    this.enableNSFW,
    this.offerSessions,
    this.allowTripPlanner,
  });
  final String userId;
  final String displayName;
  final int? age;
  final String? pronouns;
  final String? gender;
  final String? position;
  final String? aboutMe;
  final String? bodyType;
  final double? heightCm;
  final double? weightKg;
  final List<String> roleTags;
  final List<String> moodTags;
  final List<String> traits;
  final String? profilePhotoUrl;
  final List<String> privateAlbumUrls;
  final bool? showAge;
  final bool? isIncognito;
  final bool? showDistance;
  final bool? hasVerifiedStatus;
  final String? instagram;
  final String? twitter;
  final String? spotify;
  final bool? enableNSFW;
  final bool? offerSessions;
  final bool? allowTripPlanner;

  UserProfile copyWith({
    String? userId,
    String? displayName,
    int? age,
    String? pronouns,
    String? gender,
    String? position,
    String? aboutMe,
    String? bodyType,
    double? heightCm,
    double? weightKg,
    List<String>? roleTags,
    List<String>? moodTags,
    List<String>? traits,
    String? profilePhotoUrl,
    List<String>? privateAlbumUrls,
    bool? showAge,
    bool? isIncognito,
    bool? showDistance,
    bool? hasVerifiedStatus,
    String? instagram,
    String? twitter,
    String? spotify,
    bool? enableNSFW,
    bool? offerSessions,
    bool? allowTripPlanner,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      pronouns: pronouns ?? this.pronouns,
      gender: gender ?? this.gender,
      position: position ?? this.position,
      aboutMe: aboutMe ?? this.aboutMe,
      bodyType: bodyType ?? this.bodyType,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      roleTags: roleTags ?? this.roleTags,
      moodTags: moodTags ?? this.moodTags,
      traits: traits ?? this.traits,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      privateAlbumUrls: privateAlbumUrls ?? this.privateAlbumUrls,
      showAge: showAge ?? this.showAge,
      isIncognito: isIncognito ?? this.isIncognito,
      showDistance: showDistance ?? this.showDistance,
      hasVerifiedStatus: hasVerifiedStatus ?? this.hasVerifiedStatus,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      spotify: spotify ?? this.spotify,
      enableNSFW: enableNSFW ?? this.enableNSFW,
      offerSessions: offerSessions ?? this.offerSessions,
      allowTripPlanner: allowTripPlanner ?? this.allowTripPlanner,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'displayName': displayName,
      'age': age,
      'pronouns': pronouns,
      'gender': gender,
      'position': position,
      'aboutMe': aboutMe,
      'bodyType': bodyType,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'roleTags': roleTags,
      'moodTags': moodTags,
      'traits': traits,
      'profilePhotoUrl': profilePhotoUrl,
      'privateAlbumUrls': privateAlbumUrls,
      'showAge': showAge,
      'isIncognito': isIncognito,
      'showDistance': showDistance,
      'hasVerifiedStatus': hasVerifiedStatus,
      'instagram': instagram,
      'twitter': twitter,
      'spotify': spotify,
      'enableNSFW': enableNSFW,
      'offerSessions': offerSessions,
      'allowTripPlanner': allowTripPlanner,
    };
  }

  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      displayName: json['displayName'] ?? '',
      age: json['age'],
      pronouns: json['pronouns'],
      gender: json['gender'],
      position: json['position'],
      aboutMe: json['aboutMe'],
      bodyType: json['bodyType'],
      heightCm: json['heightCm']?.toDouble(),
      weightKg: json['weightKg']?.toDouble(),
      roleTags: List<String>.from(json['roleTags'] ?? <dynamic>[]),
      moodTags: List<String>.from(json['moodTags'] ?? <dynamic>[]),
      traits: List<String>.from(json['traits'] ?? <dynamic>[]),
      profilePhotoUrl: json['profilePhotoUrl'],
      privateAlbumUrls: List<String>.from(json['privateAlbumUrls'] ?? <dynamic>[]),
      showAge: json['showAge'],
      isIncognito: json['isIncognito'],
      showDistance: json['showDistance'],
      hasVerifiedStatus: json['hasVerifiedStatus'],
      instagram: json['instagram'],
      twitter: json['twitter'],
      spotify: json['spotify'],
      enableNSFW: json['enableNSFW'],
      offerSessions: json['offerSessions'],
      allowTripPlanner: json['allowTripPlanner'],
    );
  }
}
