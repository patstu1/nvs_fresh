// lib/features/now/presentation/now_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nvs/core/api/unified_graphql_client.dart';
import 'dart:async';
import 'dart:math';

final StreamProvider<List<ProximityUser>> proximityUsersProvider =
    StreamProvider<List<ProximityUser>>((StreamProviderRef<List<ProximityUser>> ref) async* {
  final GraphQLClient client = ref.read(unifiedGraphQLClientProvider);

  final Position position = await _getCurrentPosition();

  const String subscription = r'''
    subscription OnProximityUpdate($lat: Float!, $lng: Float!, $radius: Int!) {
      onProximityUpdate(lat: $lat, lng: $lng, radius: $radius) {
        users {
          id
          walletAddress
          displayName
          age
          profileImages
          lastActive
          isOnline
          isAnonymous
          distance
          location { lat lng }
          mood
          status
        }
        total
        timestamp
      }
    }
  ''';

  yield* client
      .subscribe(
    SubscriptionOptions(
      document: gql(subscription),
      variables: <String, dynamic>{
        'lat': position.latitude,
        'lng': position.longitude,
        'radius': 10000,
      },
    ),
  )
      .map((QueryResult<Object?> result) {
    if (result.hasException) throw result.exception!;

    final data = result.data?['onProximityUpdate'];
    if (data == null) return <ProximityUser>[];

    final List usersData = data['users'] as List;
    return usersData.map((userData) => ProximityUser.fromJson(userData)).toList();
  });
});

Future<Position> _getCurrentPosition() async {
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) throw Exception('Location services disabled');

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions permanently denied');
  }

  return Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

class ProximityUser {
  ProximityUser({
    required this.id,
    required this.displayName,
    required this.age,
    required this.profileImages,
    required this.lastActive,
    required this.isOnline,
    required this.isAnonymous,
    required this.distance,
    required this.location,
    required this.mood,
    required this.status,
    this.walletAddress,
  });

  factory ProximityUser.fromJson(Map<String, dynamic> json) {
    return ProximityUser(
      id: json['id'],
      walletAddress: json['walletAddress'],
      displayName: json['displayName'] ?? 'Anonymous',
      age: json['age'] ?? 0,
      profileImages: List<String>.from(json['profileImages'] ?? <dynamic>[]),
      lastActive: DateTime.parse(json['lastActive']),
      isOnline: json['isOnline'] ?? false,
      isAnonymous: json['isAnonymous'] ?? false,
      distance: (json['distance'] as num).toDouble(),
      location: LatLng.fromJson(json['location']),
      mood: json['mood'] ?? 'neutral',
      status: json['status'] ?? 'available',
    );
  }
  final String id;
  final String? walletAddress;
  final String displayName;
  final int age;
  final List<String> profileImages;
  final DateTime lastActive;
  final bool isOnline;
  final bool isAnonymous;
  final double distance;
  final LatLng location;
  final String mood;
  final String status;
}

class LatLng {
  LatLng({required this.lat, required this.lng});

  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
  final double lat;
  final double lng;
}

class NowView extends ConsumerStatefulWidget {
  const NowView({super.key});

  @override
  ConsumerState<NowView> createState() => _NowViewState();
}

class _NowViewState extends ConsumerState<NowView> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scanController;
  double _zoomLevel = 1.0;
  Offset _mapOffset = Offset.zero;
  ProximityUser? _selectedUser;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scanController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ProximityUser>> proximityUsersAsync = ref.watch(proximityUsersProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          proximityUsersAsync.when(
            data: _buildQuantumMetacity,
            loading: _buildLoadingView,
            error: (Object error, StackTrace stackTrace) => _buildErrorView(error),
          ),
          _buildHeader(),
          if (_selectedUser != null) _buildUserDetailPanel(),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _pulseController,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF04FFF7), width: 2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFF04FFF7).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.radar,
                    color: Color(0xFF04FFF7),
                    size: 40,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'INITIALIZING QUANTUM METACITY...',
            style: TextStyle(
              fontFamily: 'BellGothic',
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, color: Color(0xFFFF073A), size: 64),
          const SizedBox(height: 20),
          const Text(
            'METACITY CONNECTION FAILED',
            style: TextStyle(
              fontFamily: 'BellGothic',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              fontFamily: 'BellGothic',
              color: Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref.refresh(proximityUsersProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF04FFF7),
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'RETRY CONNECTION',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF04FFF7).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.location_on, color: Color(0xFF04FFF7), size: 20),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'QUANTUM METACITY',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00FF9F).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: Color(0xFF00FF9F),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantumMetacity(List<ProximityUser> users) {
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _zoomLevel = (_zoomLevel * details.scale).clamp(0.5, 3.0);
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          _mapOffset += details.delta;
        });
      },
      child: Transform.scale(
        scale: _zoomLevel,
        child: Transform.translate(
          offset: _mapOffset,
          child: AnimatedBuilder(
            animation: Listenable.merge(
              <Listenable?>[_pulseController, _scanController],
            ),
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: QuantumMetacityPainter(
                  users: users,
                  pulseValue: _pulseController.value,
                  scanValue: _scanController.value,
                  selectedUser: _selectedUser,
                  onUserTap: (ProximityUser user) => setState(() => _selectedUser = user),
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailPanel() {
    final ProximityUser user = _selectedUser!;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: const Color(0xFF04FFF7).withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF04FFF7).withOpacity(0.2),
                  child: user.isAnonymous
                      ? const Icon(Icons.person, color: Color(0xFF04FFF7))
                      : user.profileImages.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                user.profileImages.first,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  return const Icon(
                                    Icons.person,
                                    color: Color(0xFF04FFF7),
                                  );
                                },
                              ),
                            )
                          : const Icon(Icons.person, color: Color(0xFF04FFF7)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          fontFamily: 'BellGothic',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${user.age} • ${(user.distance / 1000).toStringAsFixed(1)}km away',
                        style: const TextStyle(
                          fontFamily: 'BellGothic',
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: user.isOnline ? const Color(0xFF00FF9F) : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user.isOnline
                                ? 'Online'
                                : 'Last seen ${_formatLastActive(user.lastActive)}',
                            style: const TextStyle(
                              fontFamily: 'BellGothic',
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedUser = null),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _sendMessage(user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF04FFF7),
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.message),
                    label: const Text(
                      'MESSAGE',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewProfile(user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: const Color(0xFF04FFF7),
                      side: const BorderSide(color: Color(0xFF04FFF7)),
                    ),
                    icon: const Icon(Icons.person),
                    label: const Text(
                      'PROFILE',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastActive(DateTime lastActive) {
    final Duration difference = DateTime.now().difference(lastActive);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _sendMessage(ProximityUser user) {
    debugPrint('Send message to ${user.displayName}');
  }

  void _viewProfile(ProximityUser user) {
    debugPrint('View profile of ${user.displayName}');
  }
}

class QuantumMetacityPainter extends CustomPainter {
  QuantumMetacityPainter({
    required this.users,
    required this.pulseValue,
    required this.scanValue,
    required this.onUserTap,
    this.selectedUser,
  });
  final List<ProximityUser> users;
  final double pulseValue;
  final double scanValue;
  final ProximityUser? selectedUser;
  final Function(ProximityUser) onUserTap;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    _drawQuantumGrid(canvas, size);
    _drawScanningPulse(canvas, center, size);
    _drawUserNodes(canvas, center, size);
    _drawCentralIndicator(canvas, center);
  }

  void _drawQuantumGrid(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF04FFF7).withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const double gridSize = 50.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawScanningPulse(Canvas canvas, Offset center, Size size) {
    final double maxRadius = min(size.width, size.height) / 2 * 0.8;
    final double currentRadius = maxRadius * scanValue;

    final Paint paint = Paint()
      ..color = const Color(0xFF04FFF7).withOpacity(0.3 * (1 - scanValue))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, currentRadius, paint);

    final double scanAngle = scanValue * 2 * pi;
    final Offset scanEnd = Offset(
      center.dx + currentRadius * cos(scanAngle),
      center.dy + currentRadius * sin(scanAngle),
    );

    final Paint scanPaint = Paint()
      ..color = const Color(0xFF04FFF7).withOpacity(0.6)
      ..strokeWidth = 3;

    canvas.drawLine(center, scanEnd, scanPaint);
  }

  void _drawUserNodes(Canvas canvas, Offset center, Size size) {
    final double maxRadius = min(size.width, size.height) / 2 * 0.7;

    for (int i = 0; i < users.length; i++) {
      final ProximityUser user = users[i];
      final bool isSelected = selectedUser?.id == user.id;

      final double normalizedDistance = (user.distance / 10000).clamp(0.0, 1.0);
      final double radius = maxRadius * normalizedDistance;

      final double angle = (i / users.length) * 2 * pi + (pulseValue * 0.1);
      final Offset position = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      _drawUserNode(canvas, position, user, isSelected);
    }
  }

  void _drawUserNode(
    Canvas canvas,
    Offset position,
    ProximityUser user,
    bool isSelected,
  ) {
    final double nodeSize = isSelected ? 12.0 : 8.0;
    final double glowRadius = nodeSize + (pulseValue * 4);

    Color nodeColor = const Color(0xFF04FFF7);
    if (user.isAnonymous) {
      nodeColor = const Color(0xFF8A2BE2);
    } else if (!user.isOnline) {
      nodeColor = Colors.grey;
    }

    final Paint glowPaint = Paint()
      ..color = nodeColor.withOpacity(0.3 * pulseValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(position, glowRadius, glowPaint);

    final Paint nodePaint = Paint()
      ..color = nodeColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, nodeSize, nodePaint);

    if (isSelected) {
      final Paint ringPaint = Paint()
        ..color = const Color(0xFF00FF9F)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(position, nodeSize + 6, ringPaint);
    }

    if (user.distance < 1000) {
      final Paint proximityPaint = Paint()
        ..color = const Color(0xFF00FF9F)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(position, nodeSize + 2, proximityPaint);
    }
  }

  void _drawCentralIndicator(Canvas canvas, Offset center) {
    final Paint centralPaint = Paint()
      ..color = const Color(0xFF00FF9F)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 10, centralPaint);

    final Paint ringPaint = Paint()
      ..color = const Color(0xFF00FF9F).withOpacity(0.5 * (1 - pulseValue))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 10 + (pulseValue * 20), ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
