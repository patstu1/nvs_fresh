// packages/grid/lib/presentation/views/meatup_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/models/vibe_lens_types.dart';

/// Main container screen for the MEATUP experience
/// Handles primary app layout and houses the core gallery component
class MeatupView extends ConsumerStatefulWidget {
  const MeatupView({super.key, this.onExploreNavigate, this.onSearchNavigate});

  final VoidCallback? onExploreNavigate;
  final void Function(String query)? onSearchNavigate;

  @override
  ConsumerState<MeatupView> createState() => _MeatupViewState();
}

class _MeatupViewState extends ConsumerState<MeatupView> {
  VibeLensType _activeLens = VibeLensType.nearby;
  bool _isVibeLensOpen = false;

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(meatupProfilesProvider(_activeLens));

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        centerTitle: true,
        title: const NvsLogo(size: 44, letterSpacing: 10),
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _NeonRule(),
              _ExploreSearchBar(
                onExplore: () {
                  if (widget.onExploreNavigate != null) {
                    widget.onExploreNavigate!();
                  } else {
                    setState(() => _isVibeLensOpen = true);
                  }
                },
                onSubmitSearch: (String q) {
                  if (widget.onSearchNavigate != null && q.trim().isNotEmpty) {
                    widget.onSearchNavigate!(q.trim());
                  }
                },
              ),
              _NeonRule(),
              // Incorporate a bit of the palette in filters (mint + turquoise)
              _FilterPills(onOpenFilters: () => setState(() => _isVibeLensOpen = true)),
              _NeonRule(),
              Expanded(
                child: profilesAsync.when(
                  data: (profiles) => LivingGallery(
                    data: profiles,
                    activeLens: _activeLens,
                    onEndReached: () => _loadMoreProfiles(),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: NVSColors.primaryNeonMint),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      'Error loading profiles: $error',
                      style: NvsTextStyles.body.copyWith(color: NVSColors.primaryNeonMint),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // VibeLens overlay
          if (_isVibeLensOpen)
            VibeLensUI(
              isOpen: _isVibeLensOpen,
              onSelectLens: (lens) {
                setState(() {
                  _activeLens = lens;
                  _isVibeLensOpen = false;
                });
              },
              onClose: () => setState(() => _isVibeLensOpen = false),
            ),
        ],
      ),
    );
  }

  void _loadMoreProfiles() {
    ref.read(meatupProfilesProvider(_activeLens).notifier).loadMore();
  }
}

class _NeonRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            NVSColors.primaryLightMint,
            NVSColors.turquoiseNeon,
            NVSColors.primaryLimeGreen,
          ],
        ),
        boxShadow: <BoxShadow>[
          const BoxShadow(color: NVSColors.primaryLightMint, blurRadius: 10, spreadRadius: 0.6),
          BoxShadow(
            color: NVSColors.turquoiseNeon.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 0.8,
          ),
        ],
      ),
    );
  }
}

class _ExploreSearchBar extends StatelessWidget {
  const _ExploreSearchBar({required this.onExplore, required this.onSubmitSearch});
  final VoidCallback onExplore;
  final void Function(String query) onSubmitSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          // Explore button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onExplore();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: NVSColors.primaryLightMint.withValues(alpha: 0.5),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.15),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.turquoiseNeon.withValues(alpha: 0.35),
                    blurRadius: 14,
                    spreadRadius: 0.8,
                  ),
                ],
              ),
              child: Row(
                children: const <Widget>[
                  Icon(Icons.map, color: NVSColors.primaryLightMint, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'explore',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: NVSColors.primaryLightMint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Search field (UI only here)
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: NVSColors.primaryLightMint.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.10),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.turquoiseNeon.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 0.6,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.search, size: 16, color: NVSColors.primaryLightMint),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onSubmitted: onSubmitSearch,
                      style: const TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 12,
                        color: NVSColors.primaryLightMint,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'explore cities, venues, users...',
                        hintStyle: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 12,
                          color: NVSColors.primaryLightMint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPills extends StatelessWidget {
  const _FilterPills({required this.onOpenFilters});
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    Widget pill(String label) => Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: NVSColors.primaryLightMint.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(14),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.primaryLightMint.withValues(alpha: 0.18),
                blurRadius: 10,
                spreadRadius: 0.4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // palette dot
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[
                      NVSColors.primaryLightMint,
                      NVSColors.turquoiseNeon,
                      NVSColors.primaryLimeGreen,
                    ],
                  ),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 12,
                  color: NVSColors.primaryLightMint,
                ),
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            pill('popular'),
            pill('new'),
            pill('nearby'),
            pill('favorites'),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onOpenFilters,
              icon: const Icon(Icons.tune, color: NVSColors.primaryLightMint, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
