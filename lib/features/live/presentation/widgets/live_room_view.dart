// lib/features/live/presentation/widgets/live_room_view.dart
import 'package:flutter/material.dart';
import 'package:nvs/features/live/domain/models/live_room_model.dart';
import 'package:nvs/meatup_core.dart';

class LiveRoomView extends StatelessWidget {
  const LiveRoomView({
    required this.room,
    super.key,
    this.onJoin,
  });
  final LiveRoomModel room;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              room.title,
              style: const TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${room.participantCount} participants',
              style: const TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            if (onJoin != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.backgroundColor,
                  ),
                  child: const Text('Join Room'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
