import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/mock_personal_room_users.dart';

class DMOverlay extends StatefulWidget {
  const DMOverlay({
    required this.user,
    required this.onClose,
    super.key,
  });
  final MockPersonalRoomUser user;
  final VoidCallback onClose;

  @override
  State<DMOverlay> createState() => _DMOverlayState();
}

class _DMOverlayState extends State<DMOverlay> {
  final TextEditingController _messageController = TextEditingController();
  bool _isInputFocused = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.9),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // Header
            _buildHeader(),

            // User info
            _buildUserInfo(),

            // Actions
            _buildActions(),

            const Spacer(),

            // Message input
            _buildMessageInput(),
          ],
        ),
      ),
    ).animate().slideY(begin: 1, duration: const Duration(milliseconds: 400));
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.close,
              color: NVSColors.ultraLightMint,
              size: 24,
            ),
            onPressed: widget.onClose,
          ),
          const Spacer(),
          Text(
            'ENCRYPTED CHANNEL',
            style: TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              foreground: Paint()..color = NVSColors.aquaOutline,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
              border: Border.all(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.user.username.substring(0, 2),
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  foreground: Paint()..color = NVSColors.ultraLightMint,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Username
          Text(
            widget.user.username,
            style: TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              foreground: Paint()..color = NVSColors.ultraLightMint,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 8),

          // Match percentage
          Text(
            '${widget.user.matchPercentage.toInt()}% MATCH',
            style: TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              foreground: Paint()..color = NVSColors.aquaOutline,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 4),

          // Proximity
          Text(
            widget.user.proximity,
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
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildActionButton(
            'SEND MESSAGE',
            Icons.message,
            () {
              // TODO: Send message
            },
          ),
          _buildActionButton(
            'YO',
            Icons.flash_on,
            () {
              // TODO: Send YO ping
            },
          ),
          _buildActionButton(
            'UNLOCK',
            Icons.lock_open,
            () {
              // TODO: Unlock album
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: NVSColors.nvsBlack.withValues(alpha: 0.8),
          border: Border.all(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: NVSColors.ultraLightMint,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'MagdaClean',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                foreground: Paint()..color = NVSColors.ultraLightMint,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: NVSColors.nvsBlack.withValues(alpha: 0.8),
                border: Border.all(
                  color: _isInputFocused
                      ? NVSColors.ultraLightMint.withValues(alpha: 0.8)
                      : NVSColors.ultraLightMint.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: _isInputFocused
                    ? <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 14,
                  foreground: Paint()..color = NVSColors.ultraLightMint,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  hintText: 'ENCRYPTED MESSAGE...',
                  hintStyle: TextStyle(
                    fontFamily: 'MagdaClean',
                    fontSize: 14,
                    foreground: Paint()..color = NVSColors.ultraLightMint.withValues(alpha: 0.4),
                    letterSpacing: 0.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onTap: () => setState(() => _isInputFocused = true),
                onSubmitted: (String value) {
                  // TODO: Send message
                  _messageController.clear();
                  setState(() => _isInputFocused = false);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
              border: Border.all(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.send,
              color: NVSColors.ultraLightMint,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
