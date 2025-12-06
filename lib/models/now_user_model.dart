class NowUserModel {
  NowUserModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.avatarUrl,
  });
  final String id;
  final double latitude;
  final double longitude;
  // A minimal profile snapshot for the map
  final String avatarUrl;
}
