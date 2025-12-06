import 'package:flutter/material.dart';
import '../../data/live_room_model.dart';
import 'room_card.dart';

class RoomGridView extends StatelessWidget {
  const RoomGridView({required this.rooms, required this.onJoin, super.key});
  final List<LiveRoom> rooms;
  final void Function(LiveRoom) onJoin;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const Center(
        child: Text(
          'No LIVE rooms found.',
          style: TextStyle(color: Color(0xFF4BEFE0), fontSize: 18),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemCount: rooms.length,
      itemBuilder: (BuildContext context, int i) => RoomCard(
        room: rooms[i],
        onJoin: () => onJoin(rooms[i]),
      ),
    );
  }
}
