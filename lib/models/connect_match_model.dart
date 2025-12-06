// lib/models/connect_match_model.dart
class ConnectMatchModel {
  ConnectMatchModel({
    required this.userId,
    required this.compatibilityReportId,
    required this.name,
    required this.avatarImage,
  });
  final String userId;
  final String compatibilityReportId;
  final String name;
  final String avatarImage;
}
