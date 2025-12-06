import 'dart:math' as math;

import 'package:nvs/features/now/data/models/now_user.dart';

class NowUserMockFactory {
  NowUserMockFactory({math.Random? random}) : _random = random ?? math.Random();

  final math.Random _random;

  static const List<String> _names = <String>[
    'Alex',
    'Jordan',
    'Sam',
    'Casey',
    'Taylor',
    'Drew',
    'Morgan',
    'Riley',
    'Jamie',
    'Sky',
  ];

  static const List<List<String>> _interestSets = <List<String>>[
    <String>['Coffee', 'Hiking', 'Photography'],
    <String>['Music', 'Art', 'Gaming'],
    <String>['Sports', 'Travel', 'Food'],
    <String>['Books', 'Movies', 'Yoga'],
    <String>['Dancing', 'Cooking', 'Tech'],
    <String>['Outdoors', 'Design', 'Fashion'],
    <String>['Networking', 'Wellness', 'Crypto'],
    <String>['Festivals', 'Drag', 'Fitness'],
  ];

  static const List<String> _statuses = <String>[
    'Looking for friends',
    'Exploring the city',
    'Ready to chat',
    'New in town',
    'Seeking adventure',
    'Hosting tonight',
    'Down to meet',
    'Feeling social',
  ];

  List<NowUser> buildBatch({
    int count = 12,
    double baseLatitude = 37.7749,
    double baseLongitude = -122.4194,
  }) {
    return List<NowUser>.generate(count, (int index) {
      final double latOffset = (_random.nextDouble() - 0.5) * 0.02;
      final double lngOffset = (_random.nextDouble() - 0.5) * 0.02;
      final double userLat = baseLatitude + latOffset;
      final double userLng = baseLongitude + lngOffset;

      final List<String> interests =
          _interestSets[index % _interestSets.length];
      final String displayName = _names[index % _names.length];

      final double distanceMeters = _calculateDistanceMeters(
        baseLatitude,
        baseLongitude,
        userLat,
        userLng,
      );

      return NowUser(
        id: 'mock_user_$index',
        displayName: displayName,
        username: displayName,
        age: 21 + _random.nextInt(20),
        latitude: userLat,
        longitude: userLng,
        distance: distanceMeters,
        lastActive: DateTime.now().subtract(
          Duration(minutes: _random.nextInt(90)),
        ),
        profileImage: 'https://via.placeholder.com/150x150?text=$displayName',
        isOnline: _random.nextBool(),
        isAnonymous: index % 5 == 0,
        isVerified: index % 4 == 0,
        hasPhotos: index % 3 == 0,
        hasVideos: index % 6 == 0,
        status: _statuses[index % _statuses.length],
        role: index % 3 == 0 ? 'Top' : (index % 3 == 1 ? 'Vers' : 'Bottom'),
        tags: interests,
        badges: index % 4 == 0 ? <String>['Verified'] : const <String>[],
        matchPercentage: 60 + _random.nextInt(35),
        isViewingYou: index % 7 == 0,
        activity: index % 2 == 0 ? 'Online now' : null,
      );
    });
  }

  double _calculateDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // meters
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double value) => value * (math.pi / 180);
}

final NowUserMockFactory nowUserMockFactory = NowUserMockFactory();

final List<NowUser> nowMockUsers = nowUserMockFactory.buildBatch();
