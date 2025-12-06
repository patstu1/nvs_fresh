// lib/features/live/presentation/pages/live_room_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../widgets/live_user_bubble_widget.dart';
import '../widgets/live_chat_overlay_widget.dart';
import '../widgets/live_private_dm_widget.dart';
import '../room_chat_overlay.dart';
import '../../livekit_controller.dart';
import '../../controllers/live_room_state_provider.dart';

class LiveRoomView extends ConsumerStatefulWidget {
  const LiveRoomView({
    required this.roomTitle,
    required this.userAvatars,
    super.key,
  });
  final String roomTitle;
  final List<String> userAvatars;

  @override
  ConsumerState<LiveRoomView> createState() => _LiveRoomViewState();
}

class _LiveRoomViewState extends ConsumerState<LiveRoomView> {
  late VideoPlayerController _video;

  @override
  void initState() {
    super.initState();
    _video = VideoPlayerController.asset('assets/videos/live-background.mov')
      ..setLooping(true)
      ..setVolume(0.0)
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _video.play();
      });
  }

  @override
  void dispose() {
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> pinnedUsers = ref.watch(pinnedUsersProvider);
    final List<String> messages = ref.watch(roomMessagesProvider);
    final String? dmUser = ref.watch(activeDMUserProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          if (_video.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _video.value.size.width,
                  height: _video.value.size.height,
                  child: VideoPlayer(_video),
                ),
              ),
            ),
          Container(color: Colors.black.withValues(alpha: 0.6)),

          // Top pinned user row
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: pinnedUsers.map((String avatar) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LiveUserBubble(avatarUrl: avatar, isSpeaking: true),
                  );
                }).toList(),
              ),
            ),
          ),

          // Gallery view
          Padding(
            padding: const EdgeInsets.only(top: 160, left: 16, right: 16, bottom: 140),
            child: GridView.builder(
              itemCount: widget.userAvatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (BuildContext context, int index) {
                final String avatar = widget.userAvatars[index];
                return GestureDetector(
                  onTap: () => ref.read(activeDMUserProvider.notifier).state = avatar,
                  onLongPress: () => ref.read(pinnedUsersProvider.notifier).togglePin(avatar),
                  child: LiveUserBubble(avatarUrl: avatar),
                );
              },
            ),
          ),

          // Chat overlay (bottom)
          LiveChatOverlay(
            messages: messages,
            onSend: (String msg) => ref.read(roomMessagesProvider.notifier).send('You: $msg'),
          ),

          // Right-side public chat overlay (AOL-style)
          const Positioned(
            top: 80,
            right: 16,
            bottom: 100,
            width: 320,
            child: RoomChatOverlay(),
          ),

          // Start 1-on-1 LiveKit call
          Positioned(
            right: 20,
            bottom: 180,
            child: FloatingActionButton(
              heroTag: 'start_call',
              backgroundColor: const Color(0xFFB2FFD6),
              onPressed: () async {
                final LiveKitController ctrl = LiveKitController();
                try {
                  await ctrl.connect(
                    roomName: widget.roomTitle,
                    identity: 'me',
                    onParticipantsChanged: () {},
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connected to LiveKit')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Call failed: $e')),
                  );
                }
              },
              child: const Icon(Icons.videocam, color: Colors.black),
            ),
          ),

          // DM overlay
          if (dmUser != null)
            LivePrivateDM(
              username: 'User',
              avatarUrl: dmUser,
              messages: const <String>['Hey 👀', 'You good?'],
              onSend: (String text) => ref.read(roomMessagesProvider.notifier).send('DM: $text'),
              onClose: () => ref.read(activeDMUserProvider.notifier).state = null,
            ),
        ],
      ),
    );
  }
}
