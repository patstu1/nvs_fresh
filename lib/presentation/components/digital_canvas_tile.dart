// packages/grid/lib/presentation/components/digital_canvas_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
// import 'package:unity_widget/unity_widget.dart'; // Unity integration package
import 'profile_info.dart';

/// Individual profile tile in the gallery - the "art piece"
/// Contains Unity background for living portrait effect with UI overlay
class DigitalCanvasTile extends StatefulWidget {
  final UserProfile profile;
  final bool isEcho;
  final double aspectRatio;

  const DigitalCanvasTile({
    super.key,
    required this.profile,
    required this.isEcho,
    required this.aspectRatio,
  });

  @override
  State<DigitalCanvasTile> createState() => _DigitalCanvasTileState();
}

class _DigitalCanvasTileState extends State<DigitalCanvasTile> with TickerProviderStateMixin {
  late AnimationController _borderController;
  late Animation<double> _borderAnimation;
  late AnimationController _breathController;
  late Animation<double> _breath;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _borderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _borderController, curve: Curves.easeInOut));

    _breathController = AnimationController(
      duration: const Duration(milliseconds: 4200),
      vsync: this,
    )..repeat(reverse: true);
    _breath = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _breathController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _borderController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapUp(),
      onLongPress: () => _triggerMintGlow(),
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[_borderAnimation, _breathController]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              // Square corners per spec
              borderRadius: BorderRadius.zero,
              border: Border.all(color: _getBorderColor(), width: _getBorderWidth()),
              boxShadow: _getBoxShadow(),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Unity background for living portrait effect
                    _buildUnityBackground(),

                    // Echo overlay if needed
                    if (widget.isEcho) _buildEchoOverlay(),

                    // Overlays: match % (lime) and favorite heart (top corners)
                    Positioned(top: 6, left: 6, child: _buildMatchBadge()),
                    Positioned(top: 6, right: 6, child: _FavoriteHeart(userId: widget.profile.id)),

                    // Profile info overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ProfileInfo(
                        name: widget.profile.displayName,
                        status: _getStatusText(),
                        distance: _calculateDistance(),
                        isEcho: widget.isEcho,
                      ),
                    ),

                    // Verification badge
                    if (widget.profile.verification.isVerified)
                      Positioned(top: 8, right: 8, child: _buildVerificationBadge()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchBadge() {
    final double? compat = widget.profile.compatibility;
    if (compat == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: NVSColors.avocadoGreen.withOpacity(0.9),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: NVSColors.avocadoGreen.withOpacity(0.45),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        '${compat.toStringAsFixed(0)}%',
        style: const TextStyle(
          fontFamily: 'MagdaCleanMono',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildUnityBackground() {
    // TODO: Implement Unity widget integration
    // For now, use a placeholder with the user's avatar
    return Container(
      color: NVSColors.cardBackground,
      child: widget.profile.avatarUrl.isNotEmpty
          ? Image.network(
              widget.profile.avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackBackground(),
            )
          : _buildFallbackBackground(),
    );

    // Unity implementation would be:
    // return UnityWidget(
    //   onUnityCreated: (controller) {
    //     controller.postMessage(
    //       'ProfileRenderer',
    //       'SetLivePhotoUrl',
    //       widget.profile.profileMedia?.livePhotoUrl ?? '',
    //     );
    //   },
    // );
  }

  Widget _buildFallbackBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [NVSColors.cardBackground, NVSColors.cardBackground.withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Text(
          widget.profile.displayName.isNotEmpty ? widget.profile.displayName[0].toUpperCase() : '?',
          style: NvsTextStyles.display.copyWith(fontSize: 48, color: NVSColors.primaryNeonMint),
        ),
      ),
    );
  }

  Widget _buildEchoOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.visibility_off, color: NVSColors.secondaryText, size: 24),
      ),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NVSColors.turquoiseNeon,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: NVSColors.turquoiseNeon.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(Icons.check, color: Colors.black, size: 12),
    );
  }

  Color _getBorderColor() {
    // Stronger breathing on border
    final double breathT = _breath.value; // 0..1
    const Color mint = NVSColors.primaryLightMint;
    const Color cyan = NVSColors.turquoiseNeon;
    final double mix = 0.25 + (breathT * 0.35); // 0.25..0.60
    return Color.lerp(mint, cyan, mix) ?? mint;
  }

  double _getBorderWidth() {
    // Thicker border + breathing amplitude
    final double breathT = _breath.value;
    final double base = 4.2 + (breathT * 0.6); // 4.2..4.8
    return _isPressed || _borderAnimation.value > 0.5 ? base + 0.6 : base;
  }

  List<BoxShadow> _getBoxShadow() {
    // Amplified neon breathing: layered mint + turquoise glows
    final double t = _breath.value; // 0..1
    final double blur1 = 12 + (8 * t);
    final double blur2 = 18 + (10 * t);
    final double spread1 = 1.2 + (1.0 * t);
    final double spread2 = 0.6 + (0.8 * t);
    return [
      BoxShadow(
        color: NVSColors.primaryLightMint.withOpacity(0.30 + 0.20 * t),
        blurRadius: blur1,
        spreadRadius: spread1,
      ),
      BoxShadow(
        color: NVSColors.turquoiseNeon.withOpacity(0.18 + 0.18 * t),
        blurRadius: blur2,
        spreadRadius: spread2,
      ),
    ];
  }

  String _getStatusText() {
    if (widget.isEcho) return 'Echo';

    return widget.profile.status.isOnline ? 'Online' : 'Offline';
  }

  int _calculateDistance() {
    // Mock distance calculation - in real implementation,
    // this would use GPS coordinates
    return (widget.profile.displayName.hashCode % 1000).abs();
  }

  void _onTapDown() {
    setState(() => _isPressed = true);
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
  }

  void _triggerMintGlow() {
    _borderController.forward().then((_) {
      _borderController.reverse();
    });
  }
}

// Favorites providers (local to grid components)
final Provider<FavoritesService> _favoritesServiceProvider = Provider<FavoritesService>(
  (ref) => FavoritesService(),
);
final StreamProvider<Set<String>> _favoriteIdsProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(_favoritesServiceProvider).favoriteIdsStream(),
);

class _FavoriteHeart extends ConsumerWidget {
  const _FavoriteHeart({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Set<String> favIds = ref.watch(_favoriteIdsProvider).valueOrNull ?? <String>{};
    final bool isFav = favIds.contains(userId);
    final FavoritesService svc = ref.watch(_favoritesServiceProvider);
    return GestureDetector(
      onTap: () => svc.toggleFavorite(userId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isFav ? NVSColors.avocadoGreen : NVSColors.primaryLightMint).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFav ? NVSColors.avocadoGreen : NVSColors.primaryLightMint,
        ),
      ),
    );
  }
}
