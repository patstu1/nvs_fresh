class ConnectMatchModel {
  ConnectMatchModel({
    required this.id,
    required this.name,
    required this.age,
    required this.role,
    required this.avatarImage,
    required this.compatibilityScore,
    required this.sharedTags,
    required this.yourSign,
    required this.theirSign,
    required this.astroNotes,
    this.isSaved = false,
  });
  final String id;
  final String name;
  final int age;
  final String role;
  final String avatarImage;
  final double compatibilityScore;
  final List<String> sharedTags;
  final String yourSign;
  final String theirSign;
  final String astroNotes;
  final bool isSaved;
}
