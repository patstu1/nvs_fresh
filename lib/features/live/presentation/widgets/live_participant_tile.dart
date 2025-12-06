import 'package:flutter/material.dart';
import 'package:nvs/features/live/data/models/participant.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({required this.participant, super.key});
  final Participant participant;

  @override
  Widget build(BuildContext context) {
    // Keep it simple for now. This is my canvas.
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.white24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(backgroundImage: NetworkImage(participant.avatarUrl)),
          const SizedBox(height: 8),
          Text(participant.name, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
