import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/mock_forum_threads.dart';

class ForumRoomListView extends StatelessWidget {
  const ForumRoomListView({
    required this.threads,
    super.key,
  });
  final List<MockForumThread> threads;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: threads.length,
      itemBuilder: (BuildContext context, int index) {
        final thread = threads[index];
        return _buildThreadItem(thread, index)
            .animate(delay: Duration(milliseconds: index * 100))
            .fadeIn(duration: const Duration(milliseconds: 400))
            .slideX(begin: 0.3, duration: const Duration(milliseconds: 400));
      },
    );
  }

  Widget _buildThreadItem(MockForumThread thread, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        border: Border.all(
          color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Room name and timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                thread.roomName,
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  foreground: Paint()..color = NVSColors.aquaOutline,
                  letterSpacing: 1,
                ),
              ),
              Text(
                thread.timestamp,
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  foreground: Paint()..color = NVSColors.ultraLightMint.withValues(alpha: 0.6),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Content
          Text(
            thread.content,
            style: TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              foreground: Paint()..color = NVSColors.ultraLightMint.withValues(alpha: 0.9),
              letterSpacing: 0.5,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 8),

          // Response count and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${thread.responseCount} responses',
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  foreground: Paint()..color = NVSColors.ultraLightMint.withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: thread.isActive
                      ? NVSColors.aquaOutline.withValues(alpha: 0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: thread.isActive
                        ? NVSColors.aquaOutline.withValues(alpha: 0.5)
                        : NVSColors.ultraLightMint.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  thread.isActive ? 'ACTIVE' : 'STANDBY',
                  style: TextStyle(
                    fontFamily: 'MagdaClean',
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    foreground: Paint()
                      ..color = thread.isActive
                          ? NVSColors.aquaOutline
                          : NVSColors.ultraLightMint.withValues(alpha: 0.4),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
