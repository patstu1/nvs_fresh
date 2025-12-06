// lib/features/live/presentation/nexus_view_livekit.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nvs/features/live/presentation/holographic_globe_view.dart';
import 'package:nvs/features/live/presentation/room_chat_overlay.dart';
import 'package:nvs/features/live/presentation/video_tile.dart';

enum NexusViewMode { gallery, list, pinned }

class NexusViewLiveKit extends ConsumerStatefulWidget {
  const NexusViewLiveKit({super.key});

  @override
  ConsumerState<NexusViewLiveKit> createState() => _NexusViewLiveKitState();
}

class _NexusViewLiveKitState extends ConsumerState<NexusViewLiveKit> with TickerProviderStateMixin {
  Room? _room;
  EventsListener<RoomEvent>? _listener;
  List<Participant> _participants = <Participant<TrackPublication<Track>>>[];
  late AudioPlayer _audioPlayer;
  late AnimationController _globeController;
  late AnimationController _chatController;

  NexusViewMode _viewMode = NexusViewMode.gallery;
  bool _isGlobeVisible = false;
  bool _isChatExpanded = true;
  String? _currentRoomId;
  final List<String> _pinnedUsers = <String>[];
  bool _isConnecting = false;
  bool _isAudioEnabled = true;
  bool _isVideoEnabled = true;

  @override
  void initState() {
    super.initState();

    _globeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _chatController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _audioPlayer = AudioPlayer();
    _joinRoom('berlin_underground');
  }

  Future<void> _joinRoom(String roomName) async {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
    });

    try {
      final String token = await _getLiveKitToken(roomName);
      const String livekitUrl = 'wss://nvs-livekit-production.herokuapp.com';

      _room = Room();

      _listener = _room!.createListener();
      _listener!
        ..on<RoomConnectedEvent>((RoomConnectedEvent event) {
          debugPrint('Connected to room: ${event.room.name}');
          _sortParticipants();
          _initializeLocalTracks();
        })
        ..on<ParticipantConnectedEvent>((ParticipantConnectedEvent event) {
          debugPrint('Participant connected: ${event.participant.identity}');
          _sortParticipants();
        })
        ..on<ParticipantDisconnectedEvent>((ParticipantDisconnectedEvent event) {
          debugPrint('Participant disconnected: ${event.participant.identity}');
          _sortParticipants();
        })
        ..on<TrackSubscribedEvent>((TrackSubscribedEvent event) {
          debugPrint('Track subscribed: ${event.track.sid}');
          _sortParticipants();
        })
        ..on<TrackUnsubscribedEvent>((TrackUnsubscribedEvent event) {
          debugPrint('Track unsubscribed: ${event.track.sid}');
          _sortParticipants();
        })
        ..on<DataReceivedEvent>(_handleDataReceived)
        ..on<RoomDisconnectedEvent>((RoomDisconnectedEvent event) {
          debugPrint('Room disconnected');
          _handleDisconnection();
        });

      await _room!.connect(livekitUrl, token);

      setState(() {
        _currentRoomId = roomName;
        _isConnecting = false;
      });
    } catch (e) {
      debugPrint('Error joining room: $e');
      setState(() {
        _isConnecting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join room: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _initializeLocalTracks() async {
    try {
      await _room!.localParticipant?.setCameraEnabled(_isVideoEnabled);
      await _room!.localParticipant?.setMicrophoneEnabled(_isAudioEnabled);
    } catch (e) {
      debugPrint('Error initializing local tracks: $e');
    }
  }

  Future<String> _getLiveKitToken(String roomName) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('https://nvs-backend-api.herokuapp.com/v1/livekit/token'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode(<String, Object>{
          'room': roomName,
          'identity': await _getUserIdentity(),
          'metadata': <String, String>{
            'displayName': await _getUserDisplayName(),
            'avatar': await _getUserAvatar(),
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'] as String;
      } else {
        throw Exception('Failed to get token: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting LiveKit token: $e');
      rethrow;
    }
  }

  Future<String> _getAuthToken() async {
    return 'user_auth_token_from_secure_storage';
  }

  Future<String> _getUserIdentity() async {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String> _getUserDisplayName() async {
    return 'NVS User';
  }

  Future<String> _getUserAvatar() async {
    return 'https://api.dicebear.com/7.x/avataaars/svg?seed=nvs';
  }

  void _sortParticipants() {
    setState(() {
      _participants =
          _room?.remoteParticipants.values.toList() ?? <Participant<TrackPublication<Track>>>[];
      if (_room?.localParticipant != null) {
        _participants.insert(0, _room!.localParticipant);
      }
    });
  }

  void _handleDataReceived(DataReceivedEvent event) {
    try {
      final String message = String.fromCharCodes(event.data);
      final data = jsonDecode(message);

      switch (data['type']) {
        case 'whisper':
          _handleWhisperMessage(data, event.participant);
          break;
        case 'reaction':
          _handleReaction(data, event.participant);
          break;
        case 'room_event':
          _handleRoomEvent(data);
          break;
        default:
          debugPrint('Unknown data type: ${data['type']}');
      }
    } catch (e) {
      debugPrint('Error processing data: $e');
    }
  }

  void _handleWhisperMessage(Map<String, dynamic> data, Participant? sender) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Whisper from ${sender?.identity ?? "Unknown"}',
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            data['message'] ?? '',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _sendWhisperReply(sender);
              },
              child: const Text('Reply'),
            ),
          ],
        ),
      );
    }
  }

  void _handleReaction(Map<String, dynamic> data, Participant? sender) {
    // Handle reaction animations
    debugPrint('Reaction from ${sender?.identity}: ${data['emoji']}');
  }

  void _handleRoomEvent(Map<String, dynamic> data) {
    // Handle room-wide events
    debugPrint('Room event: ${data['event']}');
  }

  void _handleDisconnection() {
    setState(() {
      _participants.clear();
      _currentRoomId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildNexusHeader(),
              Expanded(
                child: _isConnecting ? _buildLoadingView() : _buildMainContent(),
              ),
            ],
          ),
          if (_isGlobeVisible)
            AnimatedBuilder(
              animation: _globeController,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _globeController.value,
                  child: const HolographicGlobeView(),
                );
              },
            ),
          Positioned(
            right: 0,
            top: 100,
            bottom: 100,
            child: AnimatedBuilder(
              animation: _chatController,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(_isChatExpanded ? 0 : 320, 0),
                  child: const RoomChatOverlay(),
                );
              },
            ),
          ),
          _buildFloatingControls(),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(color: Color(0xFF04FFF7)),
          SizedBox(height: 16),
          Text(
            'ESTABLISHING SYNAPTIC LINK...',
            style: TextStyle(
              fontFamily: 'BellGothic',
              color: Colors.white,
              letterSpacing: 2,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNexusHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.black,
            const Color(0xFF04FFF7).withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF04FFF7).withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _currentRoomId?.replaceAll('_', ' ').toUpperCase() ?? 'CONNECTING...',
                  style: const TextStyle(
                    fontFamily: 'BellGothic',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_participants.length} participants • Live stream',
                  style: const TextStyle(
                    fontFamily: 'BellGothic',
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isAudioEnabled ? Icons.mic : Icons.mic_off,
              color: _isAudioEnabled ? const Color(0xFF04FFF7) : Colors.red,
            ),
            onPressed: _toggleMicrophone,
          ),
          IconButton(
            icon: Icon(
              _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
              color: _isVideoEnabled ? const Color(0xFF04FFF7) : Colors.red,
            ),
            onPressed: _toggleCamera,
          ),
          IconButton(
            icon: Icon(
              _isChatExpanded ? Icons.chat : Icons.chat_bubble_outline,
              color: Colors.white,
            ),
            onPressed: _toggleChat,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_participants.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.people_outline,
              color: Colors.grey,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'No participants in room',
              style: TextStyle(
                fontFamily: 'BellGothic',
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    switch (_viewMode) {
      case NexusViewMode.gallery:
        return _buildGalleryView();
      case NexusViewMode.list:
        return _buildListView();
      case NexusViewMode.pinned:
        return _buildPinnedView();
    }
  }

  Widget _buildGalleryView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: _participants.length,
      itemBuilder: (BuildContext context, int index) {
        return VideoTile(
          participant: _participants[index],
          onTap: () => _handleParticipantTap(_participants[index]),
          onLongPress: () => _showParticipantOptions(_participants[index]),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _participants.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: VideoTile(
            participant: _participants[index],
            isListMode: true,
            onTap: () => _handleParticipantTap(_participants[index]),
            onLongPress: () => _showParticipantOptions(_participants[index]),
          ),
        );
      },
    );
  }

  Widget _buildPinnedView() {
    final List<Participant<TrackPublication<Track>>> pinnedParticipants = _participants
        .where(
          (Participant<TrackPublication<Track>> p) => _pinnedUsers.contains(p.identity),
        )
        .take(4)
        .toList();
    final List<Participant<TrackPublication<Track>>> otherParticipants = _participants
        .where(
          (Participant<TrackPublication<Track>> p) => !_pinnedUsers.contains(p.identity),
        )
        .toList();

    return Column(
      children: <Widget>[
        if (pinnedParticipants.isNotEmpty)
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: pinnedParticipants.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoTile(
                  participant: pinnedParticipants[index],
                  isPinned: true,
                  onTap: () => _handleParticipantTap(pinnedParticipants[index]),
                  onLongPress: () => _showParticipantOptions(pinnedParticipants[index]),
                );
              },
            ),
          ),
        if (otherParticipants.isNotEmpty)
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: otherParticipants.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  child: VideoTile(
                    participant: otherParticipants[index],
                    isSmall: true,
                    onTap: () => _handleParticipantTap(otherParticipants[index]),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingControls() {
    return Positioned(
      bottom: 120,
      left: 20,
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: _toggleGlobe,
            backgroundColor: const Color(0xFF04FFF7).withOpacity(0.8),
            child: const Icon(Icons.public, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFF04FFF7).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildModeButton(Icons.grid_view, NexusViewMode.gallery),
                const SizedBox(width: 8),
                _buildModeButton(Icons.list, NexusViewMode.list),
                const SizedBox(width: 8),
                _buildModeButton(Icons.push_pin, NexusViewMode.pinned),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(IconData icon, NexusViewMode mode) {
    final bool isSelected = _viewMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = mode),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF04FFF7) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _handleParticipantTap(Participant participant) {
    setState(() {
      if (_pinnedUsers.contains(participant.identity)) {
        _pinnedUsers.remove(participant.identity);
      } else if (_pinnedUsers.length < 4) {
        _pinnedUsers.add(participant.identity);
      }
    });
  }

  void _showParticipantOptions(Participant participant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.message, color: Color(0xFF04FFF7)),
              title: const Text(
                'Send Whisper',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _sendWhisper(participant);
              },
            ),
            ListTile(
              leading: Icon(
                _pinnedUsers.contains(participant.identity)
                    ? Icons.push_pin
                    : Icons.push_pin_outlined,
                color: Colors.yellow,
              ),
              title: Text(
                _pinnedUsers.contains(participant.identity) ? 'Unpin User' : 'Pin User',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _handleParticipantTap(participant);
              },
            ),
            ListTile(
              leading: const Icon(Icons.call, color: Colors.green),
              title: const Text(
                'Start Breakout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _startBreakout(participant);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendWhisper(Participant participant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Whisper to ${participant.identity}',
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Type your message...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _sendWhisperMessage(participant, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendWhisperMessage(
    Participant participant,
    String message,
  ) async {
    final String data = jsonEncode(<String, String>{
      'type': 'whisper',
      'message': message,
      'recipient': participant.identity,
    });

    await _room!.localParticipant?.publishData(
      utf8.encode(data),
    );
  }

  void _sendWhisperReply(Participant? sender) {
    if (sender != null) {
      _sendWhisper(sender);
    }
  }

  void _startBreakout(Participant participant) {
    // Create a new room for breakout
    final String breakoutRoomName = 'breakout_${DateTime.now().millisecondsSinceEpoch}';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const NexusViewLiveKit(),
      ),
    );
  }

  void _toggleGlobe() {
    setState(() {
      _isGlobeVisible = !_isGlobeVisible;
    });

    if (_isGlobeVisible) {
      _globeController.forward();
    } else {
      _globeController.reverse();
    }
  }

  void _toggleChat() {
    setState(() {
      _isChatExpanded = !_isChatExpanded;
    });

    if (_isChatExpanded) {
      _chatController.forward();
    } else {
      _chatController.reverse();
    }
  }

  Future<void> _toggleMicrophone() async {
    setState(() {
      _isAudioEnabled = !_isAudioEnabled;
    });

    await _room!.localParticipant?.setMicrophoneEnabled(_isAudioEnabled);
  }

  Future<void> _toggleCamera() async {
    setState(() {
      _isVideoEnabled = !_isVideoEnabled;
    });

    await _room!.localParticipant?.setCameraEnabled(_isVideoEnabled);
  }

  @override
  void dispose() {
    _globeController.dispose();
    _chatController.dispose();
    _audioPlayer.dispose();
    _listener?.dispose();
    _room?.disconnect();
    _room?.dispose();
    super.dispose();
  }
}
