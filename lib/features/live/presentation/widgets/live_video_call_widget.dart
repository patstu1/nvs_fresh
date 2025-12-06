// lib/features/live/presentation/widgets/live_video_call_widget.dart

import 'package:flutter/material.dart';

class LiveVideoCallWidget extends StatelessWidget {
  const LiveVideoCallWidget({
    required this.username,
    required this.avatarUrl,
    required this.onEndCall,
    super.key,
    this.isMuted = false,
    this.isVideoOn = true,
  });
  final String username;
  final String avatarUrl;
  final VoidCallback onEndCall;
  final bool isMuted;
  final bool isVideoOn;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.95),
      child: Stack(
        children: <Widget>[
          // Background Video Feed Placeholder
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: const Color(0xFFB2FFD6), width: 1.5),
              ),
              child: Center(
                child: isVideoOn
                    ? Image.asset(avatarUrl, fit: BoxFit.contain)
                    : const Icon(Icons.videocam_off, color: Colors.white24, size: 80),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: Row(
              children: <Widget>[
                CircleAvatar(backgroundImage: AssetImage(avatarUrl), radius: 24),
                const SizedBox(width: 12),
                Text(
                  username,
                  style: const TextStyle(
                    color: Color(0xFFB2FFD6),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _controlButton(Icons.videocam, isVideoOn ? Colors.greenAccent : Colors.grey),
                const SizedBox(width: 24),
                _controlButton(Icons.mic, isMuted ? Colors.grey : Colors.greenAccent),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: onEndCall,
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 24,
                    child: Icon(Icons.call_end, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon, Color color) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white10,
      child: Icon(icon, size: 20, color: color),
    );
  }
}
