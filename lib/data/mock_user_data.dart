class MockUser {
  const MockUser({
    required this.image,
    this.isAnonymous = false,
  });

  final String image;
  final bool isAnonymous;
}
