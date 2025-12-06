import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:video_player/video_player.dart';
import 'package:nvs/presentation/widgets/now_user_bubble_widget.dart';
import 'package:nvs/presentation/widgets/now_user_overlay_widget.dart';
import 'package:nvs/presentation/widgets/ephemeral_chat.dart';
import 'package:nvs/data/now_mock_users.dart';
import 'package:nvs/domain/models/now_user_model.dart';
import 'package:nvs/data/now_map_model.dart';
import 'package:nvs/presentation/widgets/map_filters_panel.dart';

enum NowViewState { intro, mapLoading, mapNow, profileOpen }

final StateNotifierProvider<NowController, NowViewState> nowStateProvider =
    StateNotifierProvider<NowController, NowViewState>((
  StateNotifierProviderRef<NowController, NowViewState> ref,
) {
  return NowController();
});

class NowController extends StateNotifier<NowViewState> {
  NowController() : super(NowViewState.intro);

  void completeIntro() {
    if (state == NowViewState.intro) {
      state = NowViewState.mapLoading;
      Future.delayed(
        const Duration(seconds: 2),
        () => state = NowViewState.mapNow,
      );
    }
  }

  void closeProfile(WidgetRef ref) {
    state = NowViewState.mapNow;
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
    _videoController = VideoPlayerController.asset(
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
    const MapFilters initialFilters = MapFilters(
      minAge: 18,
      maxAge: 35,
      maxDistance: 1000.0,
      showOnlineOnly: true,
      showAnonymous: false,
    );

    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => MapFiltersPanel(
        filters: const MapFilters(),
        onFiltersChanged: (MapFilters newFilters) {
          print('Filters updated: $newFilters');
          // TODO: Apply filters to map
        },
      ),
    );
  }

  void _showEphemeralChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const EphemeralChat(),
      ),
    );
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
    final NowViewState nowState = ref.watch(nowStateProvider);

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Stack(
        children: <Widget>[
          // Centered NVS Logo at very top
          const Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(child: NvsLogo(letterSpacing: 10)),
          ),
          // Main content based on state
          if (nowState == NowViewState.intro) _buildIntroVideo(),
          if (nowState == NowViewState.mapLoading) _buildMapLoading(),
          if (nowState == NowViewState.mapNow) _buildMapView(),

          // User overlay when selected
          if (selectedUser != null && nowState == NowViewState.mapNow)
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
          : ColoredBox(
              color: NVSColors.pureBlack,
              child: Center(
                child: Text(
                  '🌍',
                  style: TextStyle(
                    fontSize: 120,
                    shadows: <Shadow>[
                      Shadow(
                        color: NVSColors.primaryGlow.withValues(alpha: 0.8),
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
    return ColoredBox(
      color: NVSColors.pureBlack,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '🌍',
              style: TextStyle(
                fontSize: 80,
                shadows: <Shadow>[
                  Shadow(
                    color: NVSColors.primaryGlow.withValues(alpha: 0.8),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading live map...',
              style: TextStyle(
                color: NVSColors.primaryGlow,
                fontSize: 18,
                fontFamily: 'MagdaCleanMono',
                shadows: <Shadow>[
                  Shadow(
                    color: NVSColors.primaryGlow.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: NVSColors.primaryGlow,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return ColoredBox(
      color: NVSColors.pureBlack,
      child: Stack(
        children: <Widget>[
          // Simulated map background with radial gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.5,
                colors: <Color>[
                  NVSColors.primaryGlow.withValues(alpha: 0.1),
                  NVSColors.pureBlack,
                ],
              ),
            ),
          ),

          // Real user bubbles from mock data
          ...nowMockUsers.asMap().entries.map((MapEntry<int, NowUser> entry) {
            final int index = entry.key;
            final NowUser user = entry.value;
            // Position users more realistically on the map
            final double left = 50.0 + (index % 3) * 120.0;
            final double top = 150.0 + (index ~/ 3) * 150.0;

            return Positioned(
              left: left,
              top: top,
              child: GestureDetector(
                onTap: () => setState(() => selectedUser = user),
                child: NowUserBubble(user: user),
              ),
            );
          }),

          // NOW indicator
          Positioned(
            top: 60,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: NVSColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: NVSColors.primaryGlow.withValues(alpha: 0.6),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.primaryGlow.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: NVSColors.avocadoGreen,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.avocadoGreen.withValues(alpha: 0.6),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'NOW',
                    style: TextStyle(
                      color: NVSColors.primaryGlow,
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
