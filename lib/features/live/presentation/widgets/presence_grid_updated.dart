// features/live/presentation/widgets/presence_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nvs/meatup_core.dart';

// This is a placeholder for your mock user data model.
// Make sure your mock data class has these fields.
class MockUser {
  MockUser({required this.name, required this.avatarUrl, required this.vibe, this.isLive = false});
  final String name;
  final String avatarUrl;
  final String vibe;
  final bool isLive;
}

class PresenceGrid extends StatelessWidget {
  const PresenceGrid({required this.users, super.key});
  final List<MockUser> users;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(16.0),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return PresenceTile(user: users[index], index: index);
      },
    );
  }
}

class PresenceTile extends StatefulWidget {
  const PresenceTile({required this.user, required this.index, super.key});
  final MockUser user;
  final int index;

  @override
  State<PresenceTile> createState() => _PresenceTileState();
}

class _PresenceTileState extends State<PresenceTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Staggered animation entrance
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Each tile animates in with a slight delay
    Future.delayed(Duration(milliseconds: widget.index * 70), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: NVSColors.dividerColor),
          // We can use a shader here later to make this look like brushed metal
          color: NVSColors.pureBlack.withValues(alpha: 0.5),
        ),
        child: Stack(
          children: <Widget>[
            // Placeholder for user avatar - use your moody images
            Image.network(
              widget.user.avatarUrl, fit: BoxFit.cover,
              // Loading builder for a slick, branded loading state
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(
                    color: NVSColors.primaryNeonMint,
                  ),
                );
              },
            ),
            _buildGradientOverlay(),
            _buildUserInfo(),
            if (widget.user.isLive) _buildLiveIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            NVSColors.pureBlack.withValues(alpha: 0.8),
            Colors.transparent,
            NVSColors.pureBlack.withValues(alpha: 0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const <double>[0.0, 0.6, 1.0],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.user.name,
            style: const TextStyle(
              color: NVSColors.primaryNeonMint,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              shadows: <Shadow>[
                Shadow(color: NVSColors.primaryNeonMint, blurRadius: 10),
              ],
            ),
          ),
          Text(
            widget.user.vibe,
            style: const TextStyle(
              color: NVSColors.secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: NVSColors.accentGreenMint,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NVSColors.accentGreenMint.withValues(alpha: 0.8),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          'LIVE',
          style: TextStyle(
            color: NVSColors.pureBlack,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
