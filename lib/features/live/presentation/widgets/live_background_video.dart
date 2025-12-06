import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/meatup_core.dart';
import 'package:video_player/video_player.dart';

class LiveBackgroundVideo extends StatefulWidget {
  const LiveBackgroundVideo({super.key});

  @override
  State<LiveBackgroundVideo> createState() => _LiveBackgroundVideoState();
}

class _LiveBackgroundVideoState extends State<LiveBackgroundVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? controller = _controller;
    final bool ready = controller != null && controller.value.isInitialized;
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: NVSColors.pureBlack),
        child: ready
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              )
            : const SizedBox.shrink(),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 800));
  }

  Future<void> _initController() async {
    // Preferred asset per spec
    final List<String> candidates = <String>[
      'assets/videos/live_main.mov', // spec path
      'assets/videos/Live-main.mov', // existing variant on disk
      'assets/videos/live-background.mov', // existing fallback on disk
    ];

    VideoPlayerController? controller;
    for (final String path in candidates) {
      try {
        final VideoPlayerController attempt = VideoPlayerController.asset(path)
          ..setLooping(true)
          ..setVolume(0.0);
        await attempt.initialize();
        controller = attempt;
        break;
      } catch (_) {
        // try next
      }
    }

    controller ??= VideoPlayerController.asset('assets/videos/Live-main.mov')
      ..setLooping(true)
      ..setVolume(0.0);
    try {
      if (!controller.value.isInitialized) {
        await controller.initialize();
      }
    } catch (_) {}

    _controller = controller;
    if (mounted) setState(() {});
    unawaited(_controller!.play());
  }
}
