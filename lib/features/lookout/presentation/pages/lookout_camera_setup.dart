// NVS Lookout Camera Setup - Full Implementation
// Based on Prompts 34-45: Video rooms with camera requirement, pins, DMs, 1-on-1 cam
// Colors: #000000 matte black, #E4FFF0 mint ONLY - no fills, outline glows only

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/nvs_colors.dart';

class LookoutCameraSetup extends StatefulWidget {
  const LookoutCameraSetup({super.key});

  @override
  State<LookoutCameraSetup> createState() => _LookoutCameraSetupState();
}

class _LookoutCameraSetupState extends State<LookoutCameraSetup>
    with TickerProviderStateMixin {
  // Use global NVS colors - mint and black only
  static const Color _mint = NVSColors.mint;
  static const Color _olive = NVSColors.mint; // Map olive to mint
  static const Color _aqua = NVSColors.mint;  // Map aqua to mint
  static const Color _black = NVSColors.black;

  late AnimationController _glowController;
  late AnimationController _pulseController;
  late AnimationController _eyeController;

  bool _cameraReady = false;
  bool _isFrontCamera = true;
  bool _isInRoom = false;
  int _onlineCount = 200;

  // Mock users in room
  final List<_RoomUser> _roomUsers = List.generate(200, (i) => _RoomUser.generate(i));
  final List<_RoomUser> _pinnedUsers = [];
  int _gridSize = 20; // 5x4 default

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _eyeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    // Simulate camera ready after delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _cameraReady = true);
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _eyeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: _isInRoom ? _buildRoomView() : _buildCameraSetup(),
      ),
    );
  }

  // ============ CAMERA SETUP SCREEN ============
  Widget _buildCameraSetup() {
    return Column(
      children: [
        _buildSetupHeader(),
        Expanded(child: _buildCameraPreview()),
        _buildSetupControls(),
        _buildJoinButton(),
        _buildExploreLink(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSetupHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: _mint),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LOOKOUT',
                style: TextStyle(
                  color: _mint,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'Camera Setup',
                style: TextStyle(color: _olive, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _cameraReady ? _aqua : _olive.withOpacity(0.3),
          width: _cameraReady ? 2 : 1,
        ),
        boxShadow: _cameraReady
            ? [BoxShadow(color: _aqua.withOpacity(0.2), blurRadius: 20)]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera placeholder with eye animation
            Container(
              color: const Color(0xFF0A0A0A),
              child: Center(
                child: _buildEyeAnimation(),
              ),
            ),
            // Overlay controls
            if (_cameraReady)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCameraControl(
                      Icons.flip_camera_ios,
                      'Flip',
                      () => setState(() => _isFrontCamera = !_isFrontCamera),
                    ),
                    const SizedBox(width: 24),
                    _buildCameraControl(
                      Icons.flash_off,
                      'Flash',
                      () {},
                    ),
                  ],
                ),
              ),
            // Loading indicator
            if (!_cameraReady)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: _aqua,
                      strokeWidth: 2,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Initializing camera...',
                      style: TextStyle(color: _olive, fontSize: 13),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEyeAnimation() {
    return AnimatedBuilder(
      animation: _eyeController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(150, 150),
          painter: _EyePainter(
            animation: _eyeController.value,
            glowAnimation: _glowController.value,
            isReady: _cameraReady,
          ),
        );
      },
    );
  }

  Widget _buildCameraControl(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _mint.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _mint, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: _mint, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Camera access required to enter Lookout rooms',
            style: TextStyle(color: _olive, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam, color: _aqua, size: 16),
              const SizedBox(width: 8),
              Text(
                _cameraReady ? 'Camera ready' : 'Waiting for camera...',
                style: TextStyle(
                  color: _cameraReady ? _aqua : _olive,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: _cameraReady
            ? () {
                HapticFeedback.heavyImpact();
                setState(() => _isInRoom = true);
              }
            : null,
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: _cameraReady ? _aqua : _olive.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _cameraReady
                    ? [
                        BoxShadow(
                          color: _aqua.withOpacity(0.3 * _glowController.value),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'JOIN MAIN ROOM',
                    style: TextStyle(
                      color: _cameraReady ? _black : _olive,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _cameraReady ? _black.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '($_onlineCount)',
                      style: TextStyle(
                        color: _cameraReady ? _black.withOpacity(0.7) : _olive,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExploreLink() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _showRoomExplorer();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Explore Other Rooms',
            style: TextStyle(color: _olive, fontSize: 14),
          ),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward, color: _olive, size: 16),
        ],
      ),
    );
  }

  // ============ ROOM VIEW ============
  Widget _buildRoomView() {
    return Column(
      children: [
        _buildRoomHeader(),
        if (_pinnedUsers.isNotEmpty) _buildPinnedSection(),
        Expanded(child: _buildGalleryGrid()),
        _buildChatBar(),
        // Your camera PIP
        _buildYourCameraPIP(),
      ],
    );
  }

  Widget _buildRoomHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: _black,
        border: Border(bottom: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isInRoom = false),
            child: Icon(Icons.arrow_back, color: _mint),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Main Room',
                style: TextStyle(
                  color: _mint,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _aqua,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_onlineCount online',
                    style: TextStyle(color: _aqua, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Grid size toggle
          GestureDetector(
            onTap: _showGridOptions,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.grid_view, color: _mint, size: 18),
            ),
          ),
          const SizedBox(width: 10),
          // Search
          GestureDetector(
            onTap: _showUserSearch,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.search, color: _mint, size: 18),
            ),
          ),
          const SizedBox(width: 10),
          // Filter
          GestureDetector(
            onTap: _showPositionFilter,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.tune, color: _mint, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedSection() {
    return Column(
      children: [
        // Gallery strip when pins exist
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: _roomUsers.take(20).length,
            itemBuilder: (context, index) {
              final user = _roomUsers[index];
              return _buildGalleryStripTile(user);
            },
          ),
        ),
        // Pinned users grid
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(8),
          child: _buildPinnedGrid(),
        ),
      ],
    );
  }

  Widget _buildGalleryStripTile(_RoomUser user) {
    return GestureDetector(
      onTap: () => _showUserHoverMenu(user),
      child: Container(
        width: 60,
        height: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: user.isOnline ? _aqua : _mint.withOpacity(0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: _mint.withOpacity(0.08),
                child: Icon(Icons.person, color: _mint.withOpacity(0.3), size: 24),
              ),
              if (user.isSpeaking)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinnedGrid() {
    if (_pinnedUsers.isEmpty) return const SizedBox.shrink();
    
    final count = _pinnedUsers.length;
    int crossAxisCount;
    double childAspectRatio;
    
    if (count == 1) {
      crossAxisCount = 1;
      childAspectRatio = 1.2;
    } else if (count == 2) {
      crossAxisCount = 2;
      childAspectRatio = 0.8;
    } else if (count <= 4) {
      crossAxisCount = 2;
      childAspectRatio = 1.0;
    } else {
      crossAxisCount = 3;
      childAspectRatio = 0.9;
    }
    
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: _pinnedUsers.length,
      itemBuilder: (context, index) {
        final user = _pinnedUsers[index];
        return _buildPinnedUserTile(user);
      },
    );
  }

  Widget _buildPinnedUserTile(_RoomUser user) {
    return GestureDetector(
      onTap: () => _showUserHoverMenu(user),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _aqua, width: 2),
          boxShadow: [
            BoxShadow(color: _aqua.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: _mint.withOpacity(0.1),
                child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 48),
              ),
              // Unpin button
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _pinnedUsers.remove(user));
                    HapticFeedback.selectionClick();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: _mint, size: 14),
                  ),
                ),
              ),
              // User info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, _black.withOpacity(0.9)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.name}, ${user.age}',
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${user.distance} mi · ${user.position}',
                        style: TextStyle(color: _olive, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryGrid() {
    if (_pinnedUsers.isNotEmpty) {
      return const SizedBox.shrink();
    }
    
    final displayUsers = _roomUsers.take(_gridSize).toList();
    int columns;
    
    if (_gridSize == 20) {
      columns = 5;
    } else if (_gridSize == 12) {
      columns = 4;
    } else {
      columns = 3;
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.75,
      ),
      itemCount: displayUsers.length,
      itemBuilder: (context, index) {
        final user = displayUsers[index];
        return _buildUserTile(user);
      },
    );
  }

  Widget _buildUserTile(_RoomUser user) {
    return GestureDetector(
      onTap: () => _showUserHoverMenu(user),
      onLongPress: () => _openUserProfile(user),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: user.isSpeaking
                    ? Colors.red
                    : user.isOnline
                        ? _aqua.withOpacity(0.5)
                        : _mint.withOpacity(0.15),
                width: user.isSpeaking ? 2 : 1,
              ),
              boxShadow: user.isSpeaking
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3 * _pulseController.value),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Video placeholder
                  Container(
                    color: _mint.withOpacity(0.06),
                    child: Icon(
                      Icons.person,
                      color: _mint.withOpacity(0.2),
                      size: 32,
                    ),
                  ),
                  // Position badge
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: _aqua.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.positionShort,
                        style: const TextStyle(
                          color: _black,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  // Online dot
                  if (user.isOnline)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _aqua,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  // Speaking indicator
                  if (user.isSpeaking)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic, color: Colors.white, size: 10),
                      ),
                    ),
                  // Name overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, _black.withOpacity(0.8)],
                        ),
                      ),
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _black,
        border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: GestureDetector(
        onTap: _showRoomChat,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: _olive, size: 18),
              const SizedBox(width: 12),
              Text(
                'Room Chat',
                style: TextStyle(color: _olive, fontSize: 14),
              ),
              const Spacer(),
              Icon(Icons.keyboard_arrow_up, color: _olive, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYourCameraPIP() {
    return Positioned(
      bottom: 80,
      right: 16,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _aqua, width: 2),
            boxShadow: [
              BoxShadow(color: _aqua.withOpacity(0.3), blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: _aqua.withOpacity(0.1),
                  child: const Icon(Icons.person, color: _aqua, size: 32),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  left: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isFrontCamera = !_isFrontCamera),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flip_camera_ios, color: _mint, size: 12),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic, color: _mint, size: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ MODALS & OVERLAYS ============
  void _showUserHoverMenu(_RoomUser user) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _black,
          border: Border.all(color: _mint.withOpacity(0.2)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // User info
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _aqua, width: 2),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: _mint.withOpacity(0.1),
                      child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name}, ${user.age}',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${user.distance} mi · ${user.position}',
                      style: TextStyle(color: _olive, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHoverAction(
                  Icons.push_pin,
                  _pinnedUsers.contains(user) ? 'UNPIN' : 'PIN',
                  _pinnedUsers.contains(user) ? _olive : _aqua,
                  () {
                    Navigator.pop(context);
                    if (_pinnedUsers.contains(user)) {
                      setState(() => _pinnedUsers.remove(user));
                    } else if (_pinnedUsers.length < 6) {
                      setState(() => _pinnedUsers.add(user));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Max 6 pins - unpin someone first'),
                          backgroundColor: _olive,
                        ),
                      );
                    }
                  },
                ),
                _buildHoverAction(Icons.chat_bubble_outline, 'DM', _mint, () {
                  Navigator.pop(context);
                  _openDM(user);
                }),
                _buildHoverAction(Icons.person_outline, 'PROFILE', _olive, () {
                  Navigator.pop(context);
                  _openUserProfile(user);
                }),
                _buildHoverAction(Icons.block, 'BLOCK', Colors.red.shade300, () {
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHoverAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: label == 'PIN' && !_pinnedUsers.any((u) => u.name == label)
                  ? _aqua
                  : Colors.transparent,
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: label == 'PIN' ? _black : color,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showRoomChat() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _RoomChatOverlay(),
    );
  }

  void _showGridOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _black,
          border: Border.all(color: _mint.withOpacity(0.2)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grid Size',
              style: TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _buildGridOption('Full Grid (5x4)', 20),
            _buildGridOption('Medium Grid (4x3)', 12),
            _buildGridOption('Large Grid (3x2)', 6),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGridOption(String label, int size) {
    final isSelected = _gridSize == size;
    return GestureDetector(
      onTap: () {
        setState(() => _gridSize = size);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? _aqua : _olive,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _mint : _olive,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserSearch() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _UserSearchOverlay(users: _roomUsers),
    );
  }

  void _showPositionFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _PositionFilterModal(),
    );
  }

  void _showRoomExplorer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _RoomExplorerOverlay(),
    );
  }

  void _openDM(_RoomUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DMOverlay(user: user),
    );
  }

  void _openUserProfile(_RoomUser user) {
    // TODO: Navigate to full profile
  }
}

// Eye Painter for camera preview animation
class _EyePainter extends CustomPainter {
  final double animation;
  final double glowAnimation;
  final bool isReady;

  _EyePainter({
    required this.animation,
    required this.glowAnimation,
    required this.isReady,
  });

  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Outer eye shape
    final eyePaint = Paint()
      ..color = (isReady ? _aqua : _mint).withOpacity(0.3 + 0.3 * glowAnimation)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final eyeRadius = size.width * 0.4;
    final eyePath = Path();
    
    // Draw eye shape
    eyePath.moveTo(center.dx - eyeRadius, center.dy);
    eyePath.quadraticBezierTo(
      center.dx,
      center.dy - eyeRadius * 0.6 * (0.8 + 0.2 * animation),
      center.dx + eyeRadius,
      center.dy,
    );
    eyePath.quadraticBezierTo(
      center.dx,
      center.dy + eyeRadius * 0.6 * (0.8 + 0.2 * animation),
      center.dx - eyeRadius,
      center.dy,
    );
    
    canvas.drawPath(eyePath, eyePaint);
    
    // Iris
    final irisPaint = Paint()
      ..color = (isReady ? _aqua : _mint).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    canvas.drawCircle(center, eyeRadius * 0.4, irisPaint);
    
    // Pupil
    final pupilPaint = Paint()
      ..color = isReady ? _aqua : _mint
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, eyeRadius * 0.15, pupilPaint);
    
    // Glow effect when ready
    if (isReady) {
      final glowPaint = Paint()
        ..color = _aqua.withOpacity(0.2 * glowAnimation)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      
      canvas.drawCircle(center, eyeRadius * 0.3, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EyePainter oldDelegate) =>
      animation != oldDelegate.animation ||
      glowAnimation != oldDelegate.glowAnimation ||
      isReady != oldDelegate.isReady;
}

// Room Chat Overlay
class _RoomChatOverlay extends StatelessWidget {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: _black.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Room Chat',
                  style: TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: _mint),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User${index + 1}: ',
                        style: const TextStyle(color: _mint, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          index % 3 == 0 ? 'hey what\'s up' : index % 3 == 1 ? 'anyone down to chat?' : '👋',
                          style: TextStyle(color: _mint.withOpacity(0.8), fontSize: 14),
                        ),
                      ),
                      Text(
                        '${index + 1}m',
                        style: TextStyle(color: _olive, fontSize: 11),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: _mint),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: _olive),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.send, color: _aqua),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// User Search Overlay
class _UserSearchOverlay extends StatelessWidget {
  final List<_RoomUser> users;

  const _UserSearchOverlay({required this.users});

  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: _black,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: _mint),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Search Room',
                  style: TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: _aqua.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: _olive),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: _mint),
                      decoration: InputDecoration(
                        hintText: 'Search names...',
                        hintStyle: TextStyle(color: _olive),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.take(20).length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: _mint.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _aqua.withOpacity(0.5)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Container(
                            color: _mint.withOpacity(0.1),
                            child: Icon(Icons.person, color: _mint.withOpacity(0.3)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.name}, ${user.age}',
                              style: const TextStyle(color: _mint, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${user.distance} mi · ${user.position}',
                              style: TextStyle(color: _olive, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _aqua,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '📌 Pin',
                          style: TextStyle(color: _black, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: _mint),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '💬 DM',
                          style: TextStyle(color: _mint, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Position Filter Modal
class _PositionFilterModal extends StatelessWidget {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _black,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Position',
            style: TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _buildFilterOption(context, 'ALL', '200', true),
          _buildFilterOption(context, 'TOP', '45', false),
          _buildFilterOption(context, 'BOTTOM', '67', false),
          _buildFilterOption(context, 'VERSATILE', '72', false),
          _buildFilterOption(context, 'SIDE', '16', false),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: _aqua,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                'APPLY FILTER',
                style: TextStyle(color: _black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: _olive)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String label, String count, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: selected ? _aqua : _olive,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: selected ? _mint : _olive,
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            '($count)',
            style: TextStyle(color: _olive, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// Room Explorer Overlay
class _RoomExplorerOverlay extends StatelessWidget {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: _black,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: _mint),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Explore Rooms',
                  style: TextStyle(color: _mint, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _aqua,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+ Create',
                    style: TextStyle(color: _black, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('MAJOR CITIES', style: TextStyle(color: _olive, fontSize: 11, letterSpacing: 1)),
                const SizedBox(height: 12),
                _buildCityRoom('🗽 New York City', '200'),
                _buildCityRoom('🌴 Los Angeles', '200'),
                _buildCityRoom('🏖️ Miami', '184'),
                _buildCityRoom('🌆 Chicago', '156'),
                _buildCityRoom('⚡ Berlin', '143'),
                const SizedBox(height: 24),
                const Text('CUSTOM ROOMS', style: TextStyle(color: _olive, fontSize: 11, letterSpacing: 1)),
                const SizedBox(height: 12),
                _buildCustomRoom('🔥 NYC After Dark', '47/50', 'Late night vibes'),
                _buildCustomRoom('💪 Tops Only LA', '103/200', 'Looking for real ones'),
                _buildCustomRoom('🏳️‍🌈 Castro Hangout', '12/30', 'Chill vibes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityRoom(String name, String count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(name, style: const TextStyle(color: _mint, fontSize: 15)),
          const Spacer(),
          Text('($count)', style: TextStyle(color: _mint, fontSize: 14)),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, color: _olive, size: 14),
        ],
      ),
    );
  }

  Widget _buildCustomRoom(String name, String count, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _aqua.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: _mint, fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: _olive, fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _aqua.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(count, style: TextStyle(color: _aqua, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// DM Overlay
class _DMOverlay extends StatelessWidget {
  final _RoomUser user;

  const _DMOverlay({required this.user});

  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: _black,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _mint.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: _mint),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _aqua),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: _mint.withOpacity(0.1),
                      child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name}, ${user.age}',
                      style: const TextStyle(color: _mint, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Met in Lookout',
                      style: TextStyle(color: _olive, fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _aqua,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.videocam, color: _black, size: 18),
                ),
                const SizedBox(width: 8),
                Icon(Icons.more_vert, color: _mint),
              ],
            ),
          ),
          // Messages placeholder
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline, color: _olive.withOpacity(0.5), size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Start a conversation',
                    style: TextStyle(color: _olive, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: _mint.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.add, color: _mint, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: _mint.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
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
                Icon(Icons.send, color: _aqua),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Room User Model
class _RoomUser {
  final String id;
  final String name;
  final int age;
  final String distance;
  final String position;
  final bool isOnline;
  final bool isSpeaking;

  _RoomUser({
    required this.id,
    required this.name,
    required this.age,
    required this.distance,
    required this.position,
    required this.isOnline,
    required this.isSpeaking,
  });

  String get positionShort {
    switch (position) {
      case 'Top':
        return 'T';
      case 'Bottom':
        return 'B';
      case 'Versatile':
        return 'V';
      default:
        return 'S';
    }
  }

  static const List<String> _names = [
    'Alex', 'Jordan', 'Casey', 'Sam', 'Tyler', 'Ryan', 'Blake', 'Morgan',
    'Riley', 'Quinn', 'Avery', 'Parker', 'Drew', 'Skyler', 'Jamie', 'Taylor',
  ];

  static const List<String> _positions = ['Top', 'Bottom', 'Versatile', 'Side'];

  factory _RoomUser.generate(int index) {
    final random = Random(index);
    return _RoomUser(
      id: 'room_user_$index',
      name: _names[index % _names.length],
      age: 21 + random.nextInt(25),
      distance: (random.nextDouble() * 5).toStringAsFixed(1),
      position: _positions[random.nextInt(_positions.length)],
      isOnline: random.nextDouble() > 0.1,
      isSpeaking: random.nextDouble() > 0.9,
    );
  }
}
