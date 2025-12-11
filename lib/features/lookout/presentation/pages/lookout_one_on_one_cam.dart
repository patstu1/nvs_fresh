// NVS Lookout 1-on-1 Cam (Prompt 37)
// Private video call between two users
// Full screen UI with mute, cam toggle, flip, end call

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutOneOnOneCam extends StatefulWidget {
  final String? userId;
  final String? userName;

  const LookoutOneOnOneCam({
    super.key,
    this.userId,
    this.userName,
  });

  @override
  State<LookoutOneOnOneCam> createState() => _LookoutOneOnOneCamState();
}

class _LookoutOneOnOneCamState extends State<LookoutOneOnOneCam>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  
  bool _isMuted = false;
  bool _isCameraOn = true;
  bool _isFrontCamera = true;
  bool _showControls = true;
  bool _isConnecting = true;
  bool _isConnected = false;
  
  Timer? _controlsTimer;
  Timer? _callTimer;
  int _callDuration = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Simulate connection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _isConnected = true;
        });
        _startCallTimer();
      }
    });
    
    _startControlsTimer();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controlsTimer?.cancel();
    _callTimer?.cancel();
    super.dispose();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isConnected) {
        setState(() => _showControls = false);
      }
    });
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _callDuration++);
      }
    });
  }

  String get _formattedDuration {
    final minutes = _callDuration ~/ 60;
    final seconds = _callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
          if (_showControls) _startControlsTimer();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Remote video (full screen)
            _buildRemoteVideo(),
            // Local video (small overlay)
            if (_isCameraOn) _buildLocalVideo(),
            // Connecting overlay
            if (_isConnecting) _buildConnectingOverlay(),
            // Controls overlay
            if (_showControls) _buildControlsOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteVideo() {
    return Container(
      color: _black,
      child: _isConnected
          ? Center(
              child: Icon(
                Icons.person,
                color: _mint.withOpacity(0.1),
                size: 150,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildLocalVideo() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      right: 16,
      child: GestureDetector(
        onPanUpdate: (details) {
          // Allow dragging the local video preview
        },
        child: Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            color: _mint.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _aqua, width: 2),
            boxShadow: [
              BoxShadow(
                color: _black.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Local camera preview placeholder
                Center(
                  child: Icon(
                    Icons.person,
                    color: _mint.withOpacity(0.3),
                    size: 40,
                  ),
                ),
                // Muted indicator
                if (_isMuted)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mic_off, color: Colors.white, size: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectingOverlay() {
    return Container(
      color: _black.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _aqua, width: 3),
              ),
              child: ClipOval(
                child: Container(
                  color: _mint.withOpacity(0.1),
                  child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 50),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.userName ?? 'User',
              style: const TextStyle(
                color: _mint,
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 12),
            // Animated connecting text
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Text(
                  'Connecting...',
                  style: TextStyle(
                    color: _aqua.withOpacity(0.5 + 0.5 * _pulseController.value),
                    fontSize: 16,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Cancel button
            GestureDetector(
              onTap: _endCall,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.shade200,
                ),
                child: const Icon(Icons.call_end, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Stack(
        children: [
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 8,
                16,
                16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: _mint),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName ?? 'User',
                          style: const TextStyle(
                            color: _mint,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_isConnected)
                          Text(
                            _formattedDuration,
                            style: TextStyle(color: _aqua, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  // Flip camera button
                  GestureDetector(
                    onTap: _flipCamera,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _mint.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.flip_camera_ios, color: _mint, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).padding.bottom + 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [_black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute button
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    isActive: !_isMuted,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _isMuted = !_isMuted);
                    },
                  ),
                  // Camera toggle
                  _buildControlButton(
                    icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                    label: _isCameraOn ? 'Cam On' : 'Cam Off',
                    isActive: _isCameraOn,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _isCameraOn = !_isCameraOn);
                    },
                  ),
                  // End call
                  _buildControlButton(
                    icon: Icons.call_end,
                    label: 'End',
                    isActive: false,
                    isDestructive: true,
                    isLarge: true,
                    onTap: _endCall,
                  ),
                  // Chat button
                  _buildControlButton(
                    icon: Icons.chat_bubble,
                    label: 'Chat',
                    isActive: true,
                    onTap: _openChat,
                  ),
                  // Effects button
                  _buildControlButton(
                    icon: Icons.auto_awesome,
                    label: 'Effects',
                    isActive: true,
                    onTap: _showEffects,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool isLarge = false,
  }) {
    final color = isDestructive
        ? Colors.redAccent.shade200
        : (isActive ? _mint : _olive);
    final size = isLarge ? 64.0 : 50.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDestructive
                  ? Colors.redAccent.shade200
                  : (isActive ? _mint.withOpacity(0.2) : _olive.withOpacity(0.2)),
              border: Border.all(
                color: isDestructive ? Colors.redAccent.shade200 : color.withOpacity(0.5),
              ),
            ),
            child: Icon(
              icon,
              color: isDestructive ? Colors.white : color,
              size: isLarge ? 28 : 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isDestructive ? Colors.redAccent.shade200 : color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _flipCamera() {
    HapticFeedback.selectionClick();
    setState(() => _isFrontCamera = !_isFrontCamera);
  }

  void _endCall() {
    HapticFeedback.heavyImpact();
    Navigator.pop(context);
  }

  void _openChat() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: _black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ChatSheet(userName: widget.userName ?? 'User'),
    );
  }

  void _showEffects() {
    HapticFeedback.selectionClick();
    // Show effects picker
  }
}

// ============ CHAT SHEET ============
class _ChatSheet extends StatefulWidget {
  final String userName;

  const _ChatSheet({required this.userName});

  @override
  State<_ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<_ChatSheet> {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _messageController = TextEditingController();
  final List<_ChatMessage> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: _black,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: _mint.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Handle and header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _olive.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Chat with ${widget.userName}',
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: _olive),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return _buildMessage(msg);
                    },
                  ),
          ),
          // Input
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: _mint.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _mint.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: _mint),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: _olive),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _aqua,
                    ),
                    child: const Icon(Icons.send, color: _black, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(_ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: msg.isMe ? _aqua.withOpacity(0.2) : _mint.withOpacity(0.1),
          border: Border.all(
            color: msg.isMe ? _aqua.withOpacity(0.4) : _mint.withOpacity(0.2),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isMe ? _aqua : _mint,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(_ChatMessage(_messageController.text, true));
      _messageController.clear();
    });
    HapticFeedback.selectionClick();
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;

  _ChatMessage(this.text, this.isMe);
}


