// lib/features/live/presentation/nexus_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
// Agora removed
import 'package:nvs/features/live/presentation/holographic_globe_view.dart';
import 'package:nvs/features/live/presentation/room_chat_overlay.dart';
import 'package:nvs/features/live/presentation/nexus_video_grid.dart';
// import 'package:nvs/features/live/presentation/video_tile.dart';
import 'package:nvs/features/live/application/nexus_provider.dart';

enum NexusViewMode { gallery, list, pinned }

class NexusView extends ConsumerStatefulWidget {
  const NexusView({super.key});

  @override
  ConsumerState<NexusView> createState() => _NexusViewState();
}

class _NexusViewState extends ConsumerState<NexusView> with TickerProviderStateMixin {
  // Ambient audio player
  late AudioPlayer _audioPlayer;

  // Animation controllers
  late AnimationController _globeController;
  late AnimationController _chatController;

  // UI State
  NexusViewMode _viewMode = NexusViewMode.gallery;
  bool _isGlobeVisible = false;
  bool _isChatExpanded = true;
  String? _currentRoomId;
  final List<String> _pinnedUsers = <String>[];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _globeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _chatController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    // Initialize audio player
    _audioPlayer = AudioPlayer();

    // Video engine is disabled on simulator builds
  }

  // Video engine init omitted on simulator

  @override
  Widget build(BuildContext context) {
    final AsyncValue<NexusRoomState> nexusState = ref.watch(nexusRoomProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // --- Main Content Area ---
          Column(
            children: <Widget>[
              // Header with room info and controls
              _buildNexusHeader(),

              // Main video/content area
              Expanded(child: _buildMainContent()),
            ],
          ),

          // --- Holographic Globe Overlay ---
          if (_isGlobeVisible)
            AnimatedBuilder(
              animation: _globeController,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _globeController.value,
                  child: const HolographicGlobeView(),
                );
              },
            ),

          // --- Room Chat Overlay ---
          Positioned(
            right: 0,
            top: 100,
            bottom: 100,
            child: AnimatedBuilder(
              animation: _chatController,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(_isChatExpanded ? 0 : 250, 0),
                  child: const RoomChatOverlay(),
                );
              },
            ),
          ),

          // --- Floating Action Button for Globe ---
          Positioned(
            top: 120,
            left: 20,
            child: FloatingActionButton(
              onPressed: _toggleGlobe,
              backgroundColor: Colors.cyan.withOpacity(0.8),
              child: const Icon(Icons.public, color: Colors.black),
            ),
          ),

          // --- View Mode Selector ---
          Positioned(bottom: 120, left: 20, child: _buildViewModeSelector()),
        ],
      ),
    );
  }

  Widget _buildNexusHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Colors.black, Colors.cyan.withOpacity(0.1)]),
        border: Border(bottom: BorderSide(color: Colors.cyan.withOpacity(0.3))),
      ),
      child: Row(
        children: <Widget>[
          // Room info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Berlin Underground', // Dynamic room name
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '47 participants • Live techno stream',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),

          // Audio controls (hidden unless enabled)
          if (const bool.fromEnvironment('NVS_ENABLE_AMBIENT'))
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.cyan),
              onPressed: _toggleAmbientAudio,
            ),

          // Chat toggle
          IconButton(
            icon: Icon(
              _isChatExpanded ? Icons.chat : Icons.chat_bubble_outline,
              color: Colors.white,
            ),
            onPressed: _toggleChat,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_viewMode) {
      case NexusViewMode.gallery:
        return const NexusVideoGrid(mode: VideoGridMode.gallery);
      case NexusViewMode.list:
        return const NexusVideoGrid(mode: VideoGridMode.list);
      case NexusViewMode.pinned:
        return NexusVideoGrid(mode: VideoGridMode.pinned, pinnedUsers: _pinnedUsers);
    }
  }

  Widget _buildViewModeSelector() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildModeButton(Icons.grid_view, NexusViewMode.gallery),
          const SizedBox(width: 8),
          _buildModeButton(Icons.list, NexusViewMode.list),
          const SizedBox(width: 8),
          _buildModeButton(Icons.push_pin, NexusViewMode.pinned),
        ],
      ),
    );
  }

  Widget _buildModeButton(IconData icon, NexusViewMode mode) {
    final bool isSelected = _viewMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = mode),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 20),
      ),
    );
  }

  void _toggleGlobe() {
    setState(() {
      _isGlobeVisible = !_isGlobeVisible;
    });

    if (_isGlobeVisible) {
      _globeController.forward();
    } else {
      _globeController.reverse();
    }
  }

  void _toggleChat() {
    setState(() {
      _isChatExpanded = !_isChatExpanded;
    });

    if (_isChatExpanded) {
      _chatController.forward();
    } else {
      _chatController.reverse();
    }
  }

  Future<void> _toggleAmbientAudio() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      // Play the current room's ambient stream
      await _audioPlayer.play(UrlSource('https://stream.berlinbeachhouse.com/techno'));
    }
  }

  @override
  void dispose() {
    _globeController.dispose();
    _chatController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
