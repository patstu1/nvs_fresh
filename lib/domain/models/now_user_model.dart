// lib/features/now/domain/models/now_user_model.dart

class NowUser {
  final String id;
  final String username;
  final String avatarUrl;
  final bool isAnonymous;
  final bool isViewingYou;
  final double latitude;
  final double longitude;
  final List<String> tags;
  final bool isOnline;
  final String name; // Alias for username for backward compatibility
  final String role;
  final double distanceMeters;

  const NowUser({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.isAnonymous,
    required this.isViewingYou,
    required this.latitude,
    required this.longitude,
    required this.tags,
    this.isOnline = true,
    this.role = 'Vers',
    this.distanceMeters = 0.0,
  }) : name = username;
}
