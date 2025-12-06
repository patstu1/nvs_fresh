// lib/features/live/presentation/widgets/live_video_call_widget.dart

import 'package:flutter/material.dart';

class LiveVideoCallWidget extends StatelessWidget {
  const LiveVideoCallWidget({
    required this.remoteUid,
    required this.onEndCall,
    super.key,
  });
  final int remoteUid;
  final VoidCallback onEndCall;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          // Video background
          const Positioned.fill(
            child: Center(
              child: Text(
                'Waiting for user to join...',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ),
          ),

          // Local preview (inset)
          Positioned(
            right: 16,
            top: 60,
            child: SizedBox(
              width: 100,
              height: 140,
              child: ColoredBox(
                color: Colors.grey.withValues(alpha: 0.3),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),

          // End call
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onEndCall,
                child: const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 26,
                  child: Icon(Icons.call_end, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
