import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../../messages/domain/models/message_thread.dart' as domain;

class MessageThreadTile extends StatelessWidget {
  const MessageThreadTile({
    required this.thread,
    required this.onTap,
    this.onWave,
    this.onHeart,
    super.key,
  });

  final domain.MessageThread thread;
  final VoidCallback onTap;
  final VoidCallback? onWave;
  final VoidCallback? onHeart;

  @override
  Widget build(BuildContext context) {
    final bool isBlocked = (thread.metadata['blocked'] as bool?) ?? false;
    final bool pinLocked = (thread.metadata['pinLocked'] as bool?) ?? false;
    final String time = _relativeTime(thread.timestamp);

    return Stack(
      children: <Widget>[
        InkWell(
          onTap: isBlocked ? null : onTap,
          splashColor: NVSColors.primaryNeonMint.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NVSColors.cardBackground.withValues(alpha: 0.5),
              border: Border.all(color: NVSColors.primaryNeonMint.withValues(alpha: 0.24)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: <Widget>[
                _AvatarGlow(initial: thread.displayName.isNotEmpty ? thread.displayName[0] : '?'),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    thread.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'BellGothic',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: NVSColors.ultraLightMint,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                if (pinLocked) ...<Widget>[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.lock, size: 14, color: NVSColors.secondaryText),
                                ],
                              ],
                            ),
                          ),
                          if (thread.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: NVSColors.primaryNeonMint,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${thread.unreadCount}',
                                style: const TextStyle(
                                  fontFamily: 'MagdaCleanMono',
                                  fontSize: 10,
                                  color: NVSColors.pureBlack,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        thread.lastMessage?.content ?? '—',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 12,
                          color: NVSColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 10,
                        color: NVSColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _EmojiActions(onWave: onWave ?? () {}, onHeart: onHeart ?? () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isBlocked)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text(
                'This user has been blocked',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: NVSColors.secondaryText,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _relativeTime(DateTime dt) {
    final Duration d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'now';
    if (d.inHours < 1) return '${d.inMinutes}m';
    if (d.inDays < 1) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${(d.inDays / 7).floor()}w';
  }
}

class _AvatarGlow extends StatefulWidget {
  const _AvatarGlow({required this.initial});
  final String initial;

  @override
  State<_AvatarGlow> createState() => _AvatarGlowState();
}

class _AvatarGlowState extends State<_AvatarGlow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(from: 0),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 1.06).animate(_animation),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.primaryNeonMint.withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
            gradient: RadialGradient(
              colors: <Color>[
                NVSColors.primaryNeonMint.withValues(alpha: 0.18),
                NVSColors.primaryNeonMint.withValues(alpha: 0.04),
              ],
            ),
          ),
          child: Center(
            child: Text(
              widget.initial.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'BellGothic',
                color: NVSColors.ultraLightMint,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmojiActions extends StatelessWidget {
  const _EmojiActions({required this.onWave, required this.onHeart});
  final VoidCallback onWave;
  final VoidCallback onHeart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: onWave,
          child: const Text('🫱', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onHeart,
          child: const Text('💚', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
