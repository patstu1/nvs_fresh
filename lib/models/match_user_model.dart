/// User model for Connect (AI matching) section
class MatchUser {
  // 'instant', 'slow_burn', 'intellectual', etc.

  const MatchUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.age,
    required this.location,
    required this.tags,
    required this.interests,
    required this.traits,
    required this.sun,
    required this.moon,
    required this.rising,
    required this.compatibilityScore,
    this.photoURL,
    this.aiAnalysis = const <String, dynamic>{},
    this.isSuperLike = false,
    this.isMatched = false,
    this.matchedAt,
    this.connectionType,
  });

  factory MatchUser.fromJson(Map<String, dynamic> json) {
    return MatchUser(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      role: json['role'] as String,
      age: json['age'] as int,
      location: json['location'] as String,
      tags: List<String>.from(json['tags'] as List),
      interests: List<String>.from(json['interests'] as List),
      traits: Map<String, int>.from(json['traits'] as Map),
      sun: json['sun'] as String,
      moon: json['moon'] as String,
      rising: json['rising'] as String,
      compatibilityScore: json['compatibilityScore'] as int,
      aiAnalysis: json['aiAnalysis'] as Map<String, dynamic>? ?? <String, dynamic>{},
      isSuperLike: json['isSuperLike'] as bool? ?? false,
      isMatched: json['isMatched'] as bool? ?? false,
      matchedAt: json['matchedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['matchedAt'] as int)
          : null,
      connectionType: json['connectionType'] as String?,
    );
  }
  final String id;
  final String username;
  final String displayName;
  final String? photoURL;
  final String role;
  final int age;
  final String location;
  final List<String> tags;
  final List<String> interests;
  final Map<String, int> traits; // personality traits 0-10
  final String sun; // astrological sun sign
  final String moon; // astrological moon sign
  final String rising; // astrological rising sign
  final int compatibilityScore; // 0-100
  final Map<String, dynamic> aiAnalysis;
  final bool isSuperLike;
  final bool isMatched;
  final DateTime? matchedAt;
  final String? connectionType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'age': age,
      'location': location,
      'tags': tags,
      'interests': interests,
      'traits': traits,
      'sun': sun,
      'moon': moon,
      'rising': rising,
      'compatibilityScore': compatibilityScore,
      'aiAnalysis': aiAnalysis,
      'isSuperLike': isSuperLike,
      'isMatched': isMatched,
      'matchedAt': matchedAt?.millisecondsSinceEpoch,
      'connectionType': connectionType,
    };
  }

  MatchUser copyWith({
    String? id,
    String? username,
    String? displayName,
    String? photoURL,
    String? role,
    int? age,
    String? location,
    List<String>? tags,
    List<String>? interests,
    Map<String, int>? traits,
    String? sun,
    String? moon,
    String? rising,
    int? compatibilityScore,
    Map<String, dynamic>? aiAnalysis,
    bool? isSuperLike,
    bool? isMatched,
    DateTime? matchedAt,
    String? connectionType,
  }) {
    return MatchUser(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      age: age ?? this.age,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      interests: interests ?? this.interests,
      traits: traits ?? this.traits,
      sun: sun ?? this.sun,
      moon: moon ?? this.moon,
      rising: rising ?? this.rising,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
      isSuperLike: isSuperLike ?? this.isSuperLike,
      isMatched: isMatched ?? this.isMatched,
      matchedAt: matchedAt ?? this.matchedAt,
      connectionType: connectionType ?? this.connectionType,
    );
  }

  /// Get compatibility level description
  String get compatibilityLevel {
    if (compatibilityScore >= 90) return 'Soulmate';
    if (compatibilityScore >= 80) return 'Excellent';
    if (compatibilityScore >= 70) return 'Very Good';
    if (compatibilityScore >= 60) return 'Good';
    if (compatibilityScore >= 50) return 'Decent';
    return 'Low';
  }

  /// Get compatibility color
  String get compatibilityColor {
    if (compatibilityScore >= 80) return '#A7FFE0'; // ultraLightMint
    if (compatibilityScore >= 60) return '#B0FF5A'; // avocadoGreen
    if (compatibilityScore >= 40) return '#00F7FF'; // turquoiseNeon
    return '#FF53A1'; // electricPink
  }

  /// Get role emoji
  String get roleEmoji {
    switch (role.toLowerCase()) {
      case 'top dom breeder':
        return '🏋️‍♂️';
      case 'top':
        return '💪';
      case 'vers top':
        return '🔥';
      case 'vers':
        return '🌊';
      case 'vers bottom':
        return '💫';
      case 'bottom':
        return '✨';
      case 'power bottom':
        return '⚡';
      default:
        return '🌟';
    }
  }

  /// Get astrological emoji combination
  String get astroEmoji {
    final String sunEmoji = _getSignEmoji(sun);
    final String moonEmoji = _getSignEmoji(moon);
    final String risingEmoji = _getSignEmoji(rising);
    return '$sunEmoji$moonEmoji$risingEmoji';
  }

  String _getSignEmoji(String sign) {
    switch (sign.toLowerCase()) {
      case 'aries':
        return '♈';
      case 'taurus':
        return '♉';
      case 'gemini':
        return '♊';
      case 'cancer':
        return '♋';
      case 'leo':
        return '♌';
      case 'virgo':
        return '♍';
      case 'libra':
        return '♎';
      case 'scorpio':
        return '♏';
      case 'sagittarius':
        return '♐';
      case 'capricorn':
        return '♑';
      case 'aquarius':
        return '♒';
      case 'pisces':
        return '♓';
      default:
        return '⭐';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
