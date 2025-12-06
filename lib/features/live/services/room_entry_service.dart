// Room Entry Management Service
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/live_room_model.dart';
import '../guards/live_room_entry_guard.dart';

/// Service for managing room entry flow and validation
class RoomEntryService {
  /// Show entry guard and handle the complete entry flow
  static Future<bool> attemptRoomEntry({
    required BuildContext context,
    required LiveRoom room,
    bool enableDebugMode = false,
  }) async {
    try {
      bool accessGranted = false;
      String? errorMessage;

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: LiveRoomEntryGuard(
            requiredPin: '',
            onAccessGranted: () {
              accessGranted = true;
              Navigator.pop(context);
            },
          ),
        ),
      );

      if (!accessGranted && errorMessage != null) {
        _showErrorSnackBar(context, errorMessage);
      }

      return accessGranted;
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to enter room: $e');
      return false;
    }
  }

  /// Show a quick entry confirmation for public rooms
  static Future<bool> showQuickEntryDialog({
    required BuildContext context,
    required LiveRoom room,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: Colors.black.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Join Room',
              style: TextStyle(
                color: Color(0xFFB2FFD6),
                fontFamily: 'MagdaClean',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  room.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MagdaClean',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  room.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'MagdaClean',
                  ),
                ),
                const SizedBox(height: 16),
                _buildRoomInfo(room),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF33),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Join',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MagdaClean',
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Build room information widget for dialogs
  static Widget _buildRoomInfo(LiveRoom room) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(Icons.people, color: Color(0xFFB2FFD6), size: 16),
            const SizedBox(width: 8),
            Text(
              '${room.participantCount}/${room.maxParticipants} participants',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'MagdaClean',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            Icon(
              room.isPrivate ? Icons.lock : Icons.public,
              color: room.isPrivate ? const Color(0xFFFF6699) : const Color(0xFFB2FFD6),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              room.isPrivate ? 'Private Room' : 'Public Room',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'MagdaClean',
              ),
            ),
          ],
        ),
        if (room.isPremium) ...<Widget>[
          const SizedBox(height: 4),
          const Row(
            children: <Widget>[
              Icon(Icons.star, color: Color(0xFFCCFF33), size: 16),
              SizedBox(width: 8),
              Text(
                'Premium Room',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'MagdaClean',
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Show error message as snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontFamily: 'MagdaClean'),
        ),
        backgroundColor: const Color(0xFFFF6699),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Check if user can join room quickly (for UI optimization)
  static bool canQuickJoin(LiveRoom room) {
    return !room.isPrivate && !room.isPremium && !room.isFull && room.canJoin;
  }

  /// Get room entry difficulty level for UI indication
  static String getRoomEntryDifficulty(LiveRoom room) {
    if (room.isFull) return 'full';
    if (room.isPremium && room.isPrivate) return 'restricted';
    if (room.isPremium) return 'premium';
    if (room.isPrivate) return 'private';
    return 'open';
  }

  /// Get appropriate icon for room entry status
  static IconData getRoomEntryIcon(LiveRoom room) {
    switch (getRoomEntryDifficulty(room)) {
      case 'full':
        return Icons.no_meeting_room;
      case 'restricted':
        return Icons.security;
      case 'premium':
        return Icons.star;
      case 'private':
        return Icons.lock;
      default:
        return Icons.meeting_room;
    }
  }

  /// Get appropriate color for room entry status
  static Color getRoomEntryColor(LiveRoom room) {
    switch (getRoomEntryDifficulty(room)) {
      case 'full':
        return Colors.red;
      case 'restricted':
        return const Color(0xFFFF6699);
      case 'premium':
        return const Color(0xFFCCFF33);
      case 'private':
        return const Color(0xFFFF6699);
      default:
        return const Color(0xFFB2FFD6);
    }
  }
}

/// Riverpod provider for room entry service
final Provider<RoomEntryService> roomEntryServiceProvider =
    Provider<RoomEntryService>((ProviderRef<RoomEntryService> ref) {
  return RoomEntryService();
});
