class MapUserModel {
  final String id;
  final String role;
  final double lat;
  final double lng;
  final bool online;
  final bool blurred;

  MapUserModel({
    required this.id,
    required this.role,
    required this.lat,
    required this.lng,
    required this.online,
    required this.blurred,
  });
}
