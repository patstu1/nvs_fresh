import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/room_model.dart';
import '../../data/room_provider.dart';

class RoomsPage extends ConsumerWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Room>> roomsAsync = ref.watch(roomListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Rooms',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create room coming soon!')),
              );
            },
          ),
        ],
      ),
      body: roomsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Error: $e')),
        data: (List<Room> rooms) {
          if (rooms.isEmpty) {
            return const Center(child: Text('No rooms available.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: rooms.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              final Room room = rooms[index];
              return _RoomTile(room: room);
            },
          );
        },
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({required this.room});
  final Room room;

  @override
  Widget build(BuildContext context) {
    final RoomMessage? lastMsg = room.lastMessage;
    return ListTile(
      onTap: () => context.go('/rooms/${room.id}'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: AppTheme.surfaceColor,
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
        child: const Icon(Icons.group, color: AppTheme.primaryColor),
      ),
      title: Text(
        room.name,
        style: const TextStyle(
          color: AppTheme.primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${room.members.length} members',
            style: const TextStyle(color: AppTheme.secondaryTextColor, fontSize: 13),
          ),
          if (lastMsg != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              lastMsg.text,
              style: const TextStyle(color: AppTheme.tertiaryTextColor, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.primaryColor),
    );
  }
}
