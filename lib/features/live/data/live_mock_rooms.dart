// lib/features/live/data/live_mock_rooms.dart

class LiveMockRoom {
  LiveMockRoom({
    required this.id,
    required this.emoji,
    required this.title,
    required this.activeUsers,
    required this.tags,
    required this.userAvatars,
  });
  final String id;
  final String emoji;
  final String title;
  final int activeUsers;
  final List<String> tags;
  final List<String> userAvatars;
}

final List<LiveMockRoom> liveMockRooms = <LiveMockRoom>[
  LiveMockRoom(
    id: 'cyber_rave',
    emoji: '💠',
    title: 'Cyber Rave',
    activeUsers: 128,
    tags: <String>['techno', 'berlin', 'afterhours'],
    userAvatars: List<String>.generate(60, (int i) => 'assets/images/avatar_${(i % 6) + 1}.png'),
  ),
  LiveMockRoom(
    id: 'leather_lounge',
    emoji: '🧬',
    title: 'Leather Lounge',
    activeUsers: 92,
    tags: <String>['gear', 'bunker', 'late night'],
    userAvatars: List<String>.generate(48, (int i) => 'assets/images/avatar_${(i % 6) + 1}.png'),
  ),
  LiveMockRoom(
    id: 'skyline_studio',
    emoji: '🏙️',
    title: 'Skyline Studio',
    activeUsers: 176,
    tags: <String>['rooftop', 'deep house', 'sunset'],
    userAvatars: List<String>.generate(72, (int i) => 'assets/images/avatar_${(i % 6) + 1}.png'),
  ),
  LiveMockRoom(
    id: 'neon_bathhouse',
    emoji: '🛁',
    title: 'Neon Bathhouse',
    activeUsers: 64,
    tags: <String>['steam', 'ambient', 'low light'],
    userAvatars: List<String>.generate(40, (int i) => 'assets/images/avatar_${(i % 6) + 1}.png'),
  ),
];
