// packages/grid/lib/presentation/components/living_gallery.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../../data/models/vibe_lens_types.dart';
import 'premium_tile.dart';

/// The heart of MEATUP - renders the asymmetrical masonry grid
/// Efficiently renders profile tiles using StaggeredGridView for performance
class LivingGallery extends StatefulWidget {
  final List<UserProfile> data;
  final VibeLensType activeLens;
  final VoidCallback onEndReached;

  const LivingGallery({
    super.key,
    required this.data,
    required this.activeLens,
    required this.onEndReached,
  });

  @override
  State<LivingGallery> createState() => _LivingGalleryState();
}

class _LivingGalleryState extends State<LivingGallery> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      widget.onEndReached();
      // allow UI to show the footer; reset shortly after provider returns
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        } else {
          _isLoadingMore = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78, // slightly smaller tiles per spec
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final profile = widget.data[index];
              final isEcho = _shouldRenderAsEcho(profile, index);

              // Insert premium tile at a curated cadence if profile indicates premium
              if ((index % 17 == 6) && (profile.subscription.plan == 'premium')) {
                return PremiumTile(
                  onTap: () {},
                  child: DigitalCanvasTile(
                    profile: profile,
                    isEcho: isEcho,
                    aspectRatio: 0.75,
                  ),
                );
              }

              return DigitalCanvasTile(
                profile: profile,
                isEcho: isEcho,
                aspectRatio: 0.75, // Fixed aspect ratio for consistent sizing
              );
            }, childCount: widget.data.length),
          ),
        ),
        SliverToBoxAdapter(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _isLoadingMore ? 48 : 0,
            alignment: Alignment.center,
            child: _isLoadingMore ? const _MintLoadingIndicator() : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  /// Determine if profile should render in Echo state
  bool _shouldRenderAsEcho(UserProfile profile, int index) {
    // Render offline users as echo with some randomness for visual variety
    if (!profile.status.isOnline) return true;

    // Add some echo profiles randomly for visual interest
    return (index + 3) % 7 == 0;
  }
}

class _MintLoadingIndicator extends StatelessWidget {
  const _MintLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: NVSColors.primaryLightMint),
        ),
        SizedBox(width: 12),
        Text(
          'Loading more',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 12,
            color: NVSColors.primaryLightMint,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
