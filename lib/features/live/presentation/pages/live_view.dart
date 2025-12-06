// lib/features/live/presentation/pages/live_view.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../data/live_mock_rooms.dart';
import 'live_room_view.dart';

class LiveView extends StatefulWidget {
  const LiveView({super.key});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/Live-main.mov')
      ..setLooping(true)
      ..setVolume(0.0)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          Container(color: Colors.black.withValues(alpha: 0.6)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: GridView.builder(
              itemCount: liveMockRooms.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (BuildContext context, int index) {
                final LiveMockRoom room = liveMockRooms[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder<void>(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => LiveRoomView(
                          roomTitle: room.title,
                          userAvatars: room.userAvatars,
                        ),
                        transitionsBuilder: (
                          BuildContext context,
                          Animation<double> a,
                          Animation<double> b,
                          Widget child,
                        ) {
                          final Animation<double> curve = CurvedAnimation(
                            parent: a,
                            curve: Curves.easeInOutCubic,
                          );
                          return FadeTransition(opacity: curve, child: child);
                        },
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.black.withValues(alpha: 0.6),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: const Color(0xFFB2FFD6),
                        width: 1.2,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFB2FFD6).withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(room.emoji, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 8),
                        Text(
                          room.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${room.activeUsers} online',
                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 6,
                          children: room.tags.map((String tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white12),
                                color: Colors.white10,
                              ),
                              child: Text(
                                tag.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
