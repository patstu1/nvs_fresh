import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'nvs_live_constants.dart';

class NvsVideoTile extends StatefulWidget {
  const NvsVideoTile({required this.participant, required this.onPin, super.key});
  final Participant participant;
  final void Function(Participant p) onPin;

  @override
  State<NvsVideoTile> createState() => _NvsVideoTileState();
}

class _NvsVideoTileState extends State<NvsVideoTile> with SingleTickerProviderStateMixin {
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(vsync: this, duration: nvsBreathDuration)..repeat();
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<TrackPublication<Track>> pubs = widget.participant.trackPublications.values;
    VideoTrack? videoTrack;
    for (final TrackPublication<Track> pub in pubs) {
      if (pub.kind == TrackType.VIDEO && pub.track is VideoTrack) {
        videoTrack = pub.track as VideoTrack;
        break;
      }
    }

    return AnimatedBuilder(
      animation: _breath,
      builder: (BuildContext context, Widget? _) {
        final double phase = (math.sin(_breath.value * math.pi * 2) + 1) / 2; // 0..1
        final double glow = 6.0 + phase * 12.0;
        final double borderOpacity = 0.45 + phase * 0.35;

        return GestureDetector(
          onTap: () => widget.onPin(widget.participant),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: nvsMint.withOpacity(borderOpacity), width: 2),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: nvsMint.withOpacity(0.28 + phase * 0.32),
                  blurRadius: glow * 2,
                  spreadRadius: glow / 3,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.black.withOpacity(0.35 + phase * 0.1),
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: videoTrack != null
                  ? VideoTrackRenderer(videoTrack)
                  : Container(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
