import 'package:flutter/material.dart';
import '../../data/live_room_model.dart';

class RoomCard extends StatefulWidget {
  const RoomCard({required this.room, required this.onJoin, super.key});
  final LiveRoom room;
  final VoidCallback onJoin;

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LiveRoom room = widget.room;
    final List<String> avatars = room.participants.take(3).toList();
    final bool isLive = room.state == RoomState.active;
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: widget.onJoin,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: <Color>[
                  const Color(0xFF4BEFE0).withValues(alpha: _glowAnim.value),
                  const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                  Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF4BEFE0).withValues(alpha: _glowAnim.value * 0.5),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Icon(
                        Icons.group,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${room.participants.length}/${room.maxParticipants}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    room.title,
                    style: const TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: Color(0xFF4BEFE0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: avatars
                        .map(
                          (String id) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black,
                              backgroundImage: const AssetImage(
                                'assets/images/splash_logo.png',
                              ), // TODO: Replace with user image
                              child: Text(
                                id[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF4BEFE0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: room.tags
                        .map(
                          (String tag) => Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                            backgroundColor: Colors.black.withValues(alpha: 0.7),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: const Color(0xFF4BEFE0).withValues(alpha: 0.5),
                              ),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4BEFE0),
                        foregroundColor: Colors.black,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: const Color(0xFF4BEFE0).withValues(alpha: 0.7),
                      ),
                      onPressed: widget.onJoin,
                      child: const Text(
                        'JOIN ROOM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
