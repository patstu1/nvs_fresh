import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:video_player/video_player.dart';
import '../widgets/now_user_bubble_widget.dart';
import '../widgets/now_user_overlay_widget.dart';
import '../widgets/ephemeral_chat.dart';
import '../../data/now_mock_users.dart';
import 'package:nvs/domain/models/now_user_model.dart';
import '../../data/now_map_model.dart';
import '../../presentation/widgets/map_filters_panel.dart';
import 'package:nvs/theme/nvs_palette.dart';

enum NowViewState { intro, mapLoading, mapLive, profileOpen }

final nowStateProvider = NotifierProvider<NowController, NowViewState>(() {
  return NowController();
});

class NowController extends Notifier<NowViewState> {
  @override
  NowViewState build() {
    return NowViewState.intro;
  }

  void completeIntro() {
    if (state == NowViewState.intro) {
      state = NowViewState.mapLoading;
      Future.delayed(
        const Duration(seconds: 2),
        () => state = NowViewState.mapLive,
      );
    }
  }

  void closeProfile(WidgetRef ref) {
    state = NowViewState.mapLive;
  }
}

class NowView extends ConsumerStatefulWidget {
  const NowView({super.key});

  @override
  ConsumerState<NowView> createState() => _NowViewState();
}

class _NowViewState extends ConsumerState<NowView> {
  late VideoPlayerController _videoController;
  NowUser? selectedUser;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset(
            'assets/videos/spinning_globe_now_loading.mp4',
          )
          ..initialize().then((_) => setState(() {}))
          ..setLooping(true)
          ..play();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        ref.read(nowStateProvider.notifier).completeIntro();
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _showFiltersPanel(BuildContext context) {
    final initialFilters = MapFilters(
      minAge: 18,
      maxAge: 35,
      roles: [],
      tags: [],
      moods: [],
      maxDistance: 1000.0,
      showOnlineOnly: true,
      showAnonymous: false,
    );

    showBottomSheet(
      context: context,
      backgroundColor: NVSPalette.transparent,
      builder: (context) => MapFiltersPanel(
        filters: initialFilters,
        onFiltersChanged: (newFilters) {
          print('Filters updated: $newFilters');
          // TODO: Apply filters to map
        },
      ),
    );
  }

  void _showEphemeralChat(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const EphemeralChat()));
  }

  void _handleYo(NowUser user) {
    print('YO sent to ${user.username}');
    // TODO: Implement YO functionality
  }

  void _handleMessage(NowUser user) {
    _showEphemeralChat(context);
  }

  void _handleProfile(NowUser user) {
    // Show user profile drawer if UserProfile conversion available
    print('Profile requested for ${user.username}');
    // TODO: Convert NowUser to UserProfile and show UserProfileDrawer
  }

  @override
  Widget build(BuildContext context) {
    final nowState = ref.watch(nowStateProvider);

    return Scaffold(
      backgroundColor: NVSPalette.background,
      body: Stack(
        children: [
          // Main content based on state
          if (nowState == NowViewState.intro) _buildIntroVideo(),
          if (nowState == NowViewState.mapLoading) _buildMapLoading(),
          if (nowState == NowViewState.mapLive) _buildMapView(),

          // User overlay when selected
          if (selectedUser != null && nowState == NowViewState.mapLive)
            NowUserOverlay(
              user: selectedUser!,
              onClose: () => setState(() => selectedUser = null),
            ),
        ],
      ),
    );
  }

  Widget _buildIntroVideo() {
    return Center(
      child: _videoController.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          : Container(
              color: NVSPalette.background,
              child: Center(
                child: Text(
                  "🌍",
                  style: TextStyle(
                    fontSize: 120,
                    shadows: [
                      Shadow(
                        color: NVSPalette.primaryGlow.withValues(alpha: 0.8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildMapLoading() {
    return Container(
      color: NVSPalette.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "🌍",
              style: TextStyle(
                fontSize: 80,
                shadows: [
                  Shadow(
                    color: NVSPalette.primaryGlow.withValues(alpha: 0.8),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Loading live map...",
              style: TextStyle(
                color: NVSPalette.primaryGlow,
                fontSize: 18,
                fontFamily: 'MagdaCleanMono',
                shadows: [
                  Shadow(
                    color: NVSPalette.primaryGlow.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: NVSPalette.primaryGlow,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      color: NVSPalette.background,
      child: Stack(
        children: [
          // Simulated map background with radial gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  NVSPalette.primaryGlow.withValues(alpha: 0.1),
                  NVSPalette.background,
                ],
              ),
            ),
          ),

          // Real user bubbles from mock data
          ...nowMockUsers.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            // Position users more realistically on the map
            final left = 50.0 + (index % 3) * 120.0;
            final top = 150.0 + (index ~/ 3) * 150.0;

            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () => setState(() => selectedUser = user),
                child: NowUserBubble(user: user),
              ),
            );
          }),

          // Live indicator
          Positioned(
            top: 60,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: NVSPalette.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: NVSPalette.primaryGlow.withValues(alpha: 0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: NVSPalette.primaryGlow.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: NVSPalette.secondaryDark,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: NVSPalette.secondaryDark.withValues(
                            alpha: 0.6,
                          ),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "LIVE",
                    style: TextStyle(
                      color: NVSPalette.primaryGlow,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MagdaCleanMono',
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
