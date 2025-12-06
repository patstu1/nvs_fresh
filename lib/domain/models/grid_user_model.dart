class GridUser {
  final String name;
  final String role;
  final String image;
  final List<String> tags;
  final String distance;
  final bool isOnline;

  GridUser({
    required this.name,
    required this.role,
    required this.image,
    required this.tags,
    required this.distance,
    required this.isOnline,
  });
}