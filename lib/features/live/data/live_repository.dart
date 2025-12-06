import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nvs/meatup_core.dart';
import 'package:geolocator/geolocator.dart';

class LiveRoom {
  // key: userId_pair (e.g. 'u1_u2')

  LiveRoom({
    required this.id,
    required this.name,
    required this.tag,
    required this.host,
    required this.users,
    required this.publicChat,
    required this.privateChats,
  });
  final String id;
  final String name;
  final String tag;
  final UserProfile host;
  final List<UserProfile> users;
  final List<LiveMessage> publicChat;
  final Map<String, List<LiveMessage>> privateChats;
}

class LiveMessage {
  LiveMessage({
    required this.fromUserId,
    required this.message,
    required this.timestamp,
    this.isPrivate = false,
  });
  final String fromUserId;
  final String message;
  final DateTime timestamp;
  final bool isPrivate;
}

class LiveRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LiveRoom>> getLiveRooms() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final UserProfile host = _mockUsers[0];
    final List<UserProfile> roomUsers = _mockUsers;

    return <LiveRoom>[
      LiveRoom(
        id: 'room001',
        name: 'Flirt Zone',
        tag: '💋 trade only',
        host: host,
        users: roomUsers,
        publicChat: <LiveMessage>[
          LiveMessage(
            fromUserId: host.id,
            message: "Who's nearby?",
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
          LiveMessage(
            fromUserId: roomUsers[2].id,
            message: '👀 DM me',
            timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          ),
        ],
        privateChats: <String, List<LiveMessage>>{
          '${host.id}_${roomUsers[2].id}': <LiveMessage>[
            LiveMessage(
              fromUserId: host.id,
              message: 'You host?',
              timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
              isPrivate: true,
            ),
            LiveMessage(
              fromUserId: roomUsers[2].id,
              message: 'Vers here. You?',
              timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
              isPrivate: true,
            ),
          ],
        },
      ),
      LiveRoom(
        id: 'room002',
        name: 'Chill Vibes',
        tag: '🧘 safe space',
        host: _mockUsers[1],
        users: _mockUsers.sublist(2, 6),
        publicChat: <LiveMessage>[],
        privateChats: <String, List<LiveMessage>>{},
      ),
    ];
  }

  Future<List<UserProfile>> getNearbyUsers(Position currentUserPosition) async {
    // This is a simplified implementation. A real implementation would use a
    // geospatial query with a service like GeoFireX.
    final QuerySnapshot<Map<String, dynamic>> usersSnapshot =
        await _firestore.collection('users').limit(200).get();

    final List<UserProfile> users = usersSnapshot.docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              UserProfile.fromFirestore(doc.data()),
        )
        .toList();

    // TODO: Add actual distance calculation and sorting
    return users;
  }

  final List<UserProfile> _mockUsers = List.generate(8, (int i) {
    final bool isAnon = i % 3 == 0;
    return UserProfile(
      id: 'u_live_$i',
      email: isAnon ? 'anon$i@nvs.com' : 'user$i@nvs.com',
      displayName: isAnon ? '👀' : <String>['Zane', 'River', 'Nova', 'Sky', 'Jax'][i % 5],
      name: isAnon ? '👀' : <String>['Zane', 'River', 'Nova', 'Sky', 'Jax'][i % 5],
      photoURL: isAnon
          ? 'https://upload.wikimedia.org/wikipedia/commons/8/84/Anonymous_emblem.svg'
          : 'https://picsum.photos/id/${100 + i}/200',
      avatarUrl: isAnon
          ? 'https://upload.wikimedia.org/wikipedia/commons/8/84/Anonymous_emblem.svg'
          : 'https://picsum.photos/id/${100 + i}/200',
      age: 22 + i,
      location: 'San Francisco, CA',
      interests: <String>['Fitness', 'Travel', 'Music'],
      gender: 'male',
      lastSeen: DateTime.now().subtract(Duration(minutes: i * 2)),
      isVerified: i % 2 == 0,
      preferences: const UserPreferences(),
      stats: const UserStats(),
      status: UserStatus.online(),
      subscription: const SubscriptionInfo(),
      verification: VerificationInfo.unverified(),
      privacy: const PrivacySettings(),
      createdAt: DateTime.now().subtract(Duration(days: i * 10)),
      updatedAt: DateTime.now(),
      lastActiveAt: DateTime.now().subtract(Duration(minutes: i * 3)),
    );
  });
}
