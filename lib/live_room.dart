// lib/features/live/presentation/widgets/room_list_item.dart
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'features/live/data/live_room_model.dart';

class RoomListItem extends StatelessWidget {
  const RoomListItem({required this.room, super.key});
  final LiveRoom room;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withValues(alpha: 0.4),
        border: Border.all(color: NVSColors.dividerColor),
      ),
      child: Row(
        children: <Widget>[
          // Room Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  room.title,
                  style: const TextStyle(
                    color: NVSColors.primaryNeonMint,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  room.description,
                  style: const TextStyle(
                    color: NVSColors.secondaryText,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          // Participant Count
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  if (room.isPrivate)
                    const Icon(Icons.lock, color: NVSColors.secondaryText, size: 16),
                  if (room.isPrivate) const SizedBox(width: 8),
                  Text(
                    '${room.participantCount}/${room.maxParticipants}',
                    style: const TextStyle(
                      color: NVSColors.primaryNeonMint,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Text(
                'Online',
                style: TextStyle(color: NVSColors.secondaryText, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
