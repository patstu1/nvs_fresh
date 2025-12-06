import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/live_room_model.dart';
import '../../data/room_theme.dart';
import '../widgets/room_grid_view.dart';
import '../widgets/room_filter_bar.dart';

class LiveRoomsPage extends StatefulWidget {
  const LiveRoomsPage({super.key});

  @override
  State<LiveRoomsPage> createState() => _LiveRoomsPageState();
}

class _LiveRoomsPageState extends State<LiveRoomsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LiveRoom> _rooms = <LiveRoom>[];
  String _selectedTag = '';
  double _distance = 10.0;
  int _capacity = 200;
  bool _privateOnly = false;
  bool _aiCurated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _rooms = _mockRooms;
  }

  void _onFilterChanged({
    String? tag,
    double? distance,
    int? capacity,
    bool? privateOnly,
    bool? aiCurated,
  }) {
    setState(() {
      if (tag != null) _selectedTag = tag;
      if (distance != null) _distance = distance;
      if (capacity != null) _capacity = capacity;
      if (privateOnly != null) _privateOnly = privateOnly;
      if (aiCurated != null) _aiCurated = aiCurated;
    });
  }

  List<LiveRoom> get _filteredRooms {
    // Filter logic (mock for now)
    return _rooms.where((LiveRoom room) {
      if (_selectedTag.isNotEmpty && !room.tags.contains(_selectedTag)) {
        return false;
      }
      if (_privateOnly && !room.isPrivate) return false;
      if (room.maxParticipants > _capacity) return false;
      // Add distance/AI logic as needed
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'LIVE',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: Color(0xFF4BEFE0),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4BEFE0),
          labelColor: const Color(0xFF4BEFE0),
          unselectedLabelColor: Colors.white54,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.location_on), text: 'Nearby'),
            Tab(icon: Icon(Icons.star), text: 'Themed'),
            Tab(icon: Icon(Icons.public), text: 'Global'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_box_rounded, color: Color(0xFFFF6B6B)),
            tooltip: 'Create Room',
            onPressed: () {
              _showCreateRoomDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          RoomFilterBar(
            selectedTag: _selectedTag,
            distance: _distance,
            capacity: _capacity,
            privateOnly: _privateOnly,
            aiCurated: _aiCurated,
            onChanged: _onFilterChanged,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                RoomGridView(rooms: _filteredRooms, onJoin: _onJoinRoom),
                RoomGridView(
                  rooms: _filteredRooms.where((LiveRoom r) => r.tags.isNotEmpty).toList(),
                  onJoin: _onJoinRoom,
                ),
                RoomGridView(
                  rooms: _filteredRooms.where((LiveRoom r) => r.tags.contains('global')).toList(),
                  onJoin: _onJoinRoom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onJoinRoom(LiveRoom room) {
    // Navigate to the video room experience
    context.push('/live/room/${room.id}');
  }

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: NVSColors.surfaceColor,
        title: const Text(
          'Create Live Room',
          style: TextStyle(color: NVSColors.primaryNeonMint, fontFamily: 'BellGothic'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              style: const TextStyle(color: NVSColors.primaryText),
              decoration: InputDecoration(
                labelText: 'Room Name',
                labelStyle: TextStyle(color: NVSColors.secondaryText),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: NVSColors.primaryNeonMint),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: NVSColors.primaryText),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: NVSColors.secondaryText),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: NVSColors.primaryNeonMint),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: NVSColors.secondaryText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Creating room... This will connect to the live service.'),
                  backgroundColor: NVSColors.primaryNeonMint,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: NVSColors.primaryNeonMint,
              foregroundColor: NVSColors.pureBlack,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

// Mock data for demo
final List<LiveRoom> _mockRooms = <LiveRoom>[
  LiveRoom(
    id: '1',
    title: 'Power Bottom Pit',
    description: 'Within 5km | 156 online',
    emoji: '⚡',
    activeUsers: 156,
    hostId: 'host1',
    participants: <String>['u1', 'u2', 'u3'],
    coHosts: <String>['u4'],
    maxParticipants: 200,
    createdAt: DateTime.now(),
    settings: <String, dynamic>{},
    tags: <String>['NSFW', 'KINK'],
    themeData: <String, dynamic>{},
  ),
  LiveRoom(
    id: '2',
    title: 'Astro Hunks',
    description: 'Within 2km | 88 online',
    emoji: '🚀',
    activeUsers: 88,
    theme: RoomTheme.digitalGarden,
    hostId: 'host2',
    participants: <String>['u5', 'u6', 'u7'],
    coHosts: <String>[],
    isPremium: true,
    createdAt: DateTime.now(),
    settings: <String, dynamic>{},
    tags: <String>['ASTRO', 'COZY'],
    currentSentiment: SentimentType.relaxed,
    themeData: <String, dynamic>{},
  ),
  LiveRoom(
    id: '3',
    title: 'Only Tops',
    description: 'Global | 200 online',
    emoji: '🔝',
    activeUsers: 200,
    theme: RoomTheme.neonNoir,
    hostId: 'host3',
    participants: <String>['u8', 'u9', 'u10'],
    coHosts: <String>[],
    maxParticipants: 200,
    createdAt: DateTime.now(),
    settings: <String, dynamic>{},
    tags: <String>['global', 'NSFW'],
    currentSentiment: SentimentType.social,
    themeData: <String, dynamic>{},
  ),
];
