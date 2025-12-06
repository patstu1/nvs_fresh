import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'user_cluster_bubble.dart';
import 'dart:math' as math;

class NowUser {
  NowUser({
    required this.id,
    required this.lat,
    required this.lng,
    required this.lastSeen,
    this.name,
    this.imageUrl,
    this.isOnline = false,
    this.isHosting = false,
    this.isAnonymous = true,
    this.lastMessage,
    this.filters = const <String, dynamic>{},
    this.isViewed = false,
    this.isViewing = false,
  });
  final String id;
  final String? name;
  final String? imageUrl;
  final double lat;
  final double lng;
  final bool isOnline;
  final bool isHosting;
  final bool isAnonymous;
  final String? lastMessage;
  final DateTime lastSeen;
  final Map<String, dynamic> filters;
  bool isViewed;
  bool isViewing;

  double distanceFrom(double userLat, double userLng) {
    const double earthRadius = 6371; // km
    final double dLat = (lat - userLat) * math.pi / 180;
    final double dLng = (lng - userLng) * math.pi / 180;
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(userLat * math.pi / 180) *
            math.cos(lat * math.pi / 180) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }
}

class UserClusterManager extends StatefulWidget {
  const UserClusterManager({
    required this.users,
    required this.userLat,
    required this.userLng,
    required this.onUserTapped,
    super.key,
    this.maxDistance = 5.0,
  });
  final List<NowUser> users;
  final double userLat;
  final double userLng;
  final Function(NowUser) onUserTapped;
  final double maxDistance;

  @override
  State<UserClusterManager> createState() => _UserClusterManagerState();
}

class _UserClusterManagerState extends State<UserClusterManager> {
  String? _currentlyViewingUserId;
  final Set<String> _recentlyViewedUsers = <String>{};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Render user clusters
        ...widget.users.map((NowUser user) {
          final double distance = user.distanceFrom(widget.userLat, widget.userLng);

          // Only show users within max distance
          if (distance > widget.maxDistance) return const SizedBox.shrink();

          // Calculate position based on distance and bearing
          final Offset position = _calculateScreenPosition(user, distance);

          return Positioned(
            left: position.dx,
            top: position.dy,
            child: UserClusterBubble(
              userId: user.id,
              profileImageUrl: user.imageUrl,
              isOnline: user.isOnline,
              isViewed: _recentlyViewedUsers.contains(user.id),
              isViewing: _currentlyViewingUserId == user.id,
              distance: distance,
              size: _calculateBubbleSize(distance),
              onTap: () => _handleUserTap(user),
            ),
          );
        }),

        // Central user indicator
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 30,
          top: MediaQuery.of(context).size.height / 2 - 30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  NVSColors.primaryNeonMint,
                  NVSColors.turquoiseNeon,
                  NVSColors.primaryNeonMint.withOpacity(0.8),
                ],
              ),
              border: Border.all(
                color: NVSColors.primaryNeonMint,
                width: 3,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NVSColors.primaryNeonMint.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.my_location,
              color: NVSColors.pureBlack,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Offset _calculateScreenPosition(NowUser user, double distance) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate bearing from user position to target
    final double dLng = (user.lng - widget.userLng) * math.pi / 180;
    final double lat1 = widget.userLat * math.pi / 180;
    final double lat2 = user.lat * math.pi / 180;

    final double y = math.sin(dLng) * math.cos(lat2);
    final double x =
        math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    final double bearing = math.atan2(y, x);

    // Convert to screen coordinates
    final double radius =
        math.min(screenWidth, screenHeight) * 0.3 * (distance / widget.maxDistance);
    final double centerX = screenWidth / 2;
    final double centerY = screenHeight / 2;

    final double posX = centerX + (radius * math.cos(bearing - math.pi / 2));
    final double posY = centerY + (radius * math.sin(bearing - math.pi / 2));

    return Offset(
      posX.clamp(30.0, screenWidth - 90.0),
      posY.clamp(30.0, screenHeight - 150.0),
    );
  }

  double _calculateBubbleSize(double distance) {
    // Closer users have larger bubbles
    final double normalizedDistance = (distance / widget.maxDistance).clamp(0.0, 1.0);
    return 40 + (20 * (1.0 - normalizedDistance));
  }

  void _handleUserTap(NowUser user) {
    // Call the parent's handler first
    widget.onUserTapped(user);

    // Use post-frame callback to avoid provider modification during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentlyViewingUserId = user.id;
          _recentlyViewedUsers.add(user.id);
        });
      }
    });

    // Simulate viewing time
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _currentlyViewingUserId == user.id) {
        setState(() {
          _currentlyViewingUserId = null;
        });
      }
    });

    // Remove from recently viewed after some time
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _recentlyViewedUsers.remove(user.id);
        });
      }
    });

    // Simulate other users viewing this profile (random)
    _simulateOtherViewers(user);
  }

  void _simulateOtherViewers(NowUser viewedUser) {
    // Randomly select other users to "react" to this profile being viewed
    final math.Random random = math.Random();
    final List<NowUser> otherUsers =
        widget.users.where((NowUser u) => u.id != viewedUser.id).toList();

    for (int i = 0; i < math.min(3, otherUsers.length); i++) {
      if (random.nextBool()) {
        final NowUser reactingUser = otherUsers[random.nextInt(otherUsers.length)];

        Future.delayed(Duration(milliseconds: 500 + (i * 300)), () {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _recentlyViewedUsers.add(reactingUser.id);
                });

                // Remove reaction after a brief moment
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _recentlyViewedUsers.remove(reactingUser.id);
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      }
    }
  }
}
