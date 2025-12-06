import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nvs/meatup_core.dart';

import '../../data/live_provider.dart';
import '../../data/live_room_model.dart';
import '../../data/live_repository.dart' show LiveMessage; // Import LiveMessage for chat
import '../../data/room_theme.dart';
// LiveKit only
import '../../services/room_entry_service.dart';
import '../../../live/nvs_live_view.dart';
import '../../../live/nvs_group_chat.dart';
import '../../../live/nvs_dm_sheet.dart' show DmMessage;
import '../widgets/chat_sidebar_widget.dart';
import '../widgets/breakout_rooms_widget.dart';
import '../widgets/icebreaker_widget.dart';
import '../widgets/theme_selector_widget.dart';
import '../widgets/room_filter_bar.dart';
import '../widgets/room_grid_view.dart';
import '../widgets/live_background_video.dart';
import '../../../messenger/presentation/universal_messaging_sheet.dart';

class LivePage extends ConsumerStatefulWidget {
  const LivePage({super.key});

  @override
  ConsumerState<LivePage> createState() => _LivePageState();
}

class _LivePageState extends ConsumerState<LivePage> {
  bool _showChatSidebar = false;
  bool _showBreakoutRooms = false;
  bool _showIcebreaker = false;
  bool _showThemeSelector = false;
  String _currentFilter = 'all';

  // LiveKit
  final bool _isVideoInitialized = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeVideoService() {}

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<UserProfile>> liveUsersAsync = ref.watch(liveUserListProvider);
    final AsyncValue<List<LiveRoom>> liveRoomsAsync = ref.watch(liveRoomsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const NvsLogo(letterSpacing: 10),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.primary),
            onPressed: _openMessaging,
          ),
          IconButton(
            icon: Icon(Icons.groups, color: Theme.of(context).colorScheme.primary),
            onPressed: () => setState(() => _showBreakoutRooms = !_showBreakoutRooms),
          ),
          IconButton(
            icon: Icon(Icons.casino, color: Theme.of(context).colorScheme.primary),
            onPressed: () => setState(() => _showIcebreaker = !_showIcebreaker),
          ),
          IconButton(
            icon: Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
            onPressed: () => setState(() => _showThemeSelector = !_showThemeSelector),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Looping video background
          const LiveBackgroundVideo(),

          // Main content
          Column(
            children: <Widget>[
              // Room filter bar
              RoomFilterBar(
                selectedTag: _currentFilter,
                distance: 10.0,
                capacity: 200,
                privateOnly: false,
                aiCurated: false,
                onChanged: ({
                  String? tag,
                  double? distance,
                  int? capacity,
                  bool? privateOnly,
                  bool? aiCurated,
                }) {
                  setState(() {
                    if (tag != null) _currentFilter = tag;
                  });
                },
              ),

              // Room grid or user grid
              Expanded(
                child: liveRoomsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (Object e, StackTrace st) => _buildUserGrid(liveUsersAsync),
                  data: (List<LiveRoom> rooms) =>
                      rooms.isEmpty ? _buildUserGrid(liveUsersAsync) : _buildRoomGrid(rooms),
                ),
              ),
            ],
          ),

          // Chat sidebar overlay
          if (_showChatSidebar)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 300,
              child: ChatSidebarWidget(
                messages: const <LiveMessage>[],
                onSendMessage: (String message) {
                  print('Message sent: $message');
                },
                onClose: () => setState(() => _showChatSidebar = false),
              ),
            ),

          // Breakout rooms overlay
          if (_showBreakoutRooms)
            Positioned.fill(
              child: BreakoutRoomsWidget(
                roomId: 'main',
                onClose: () => setState(() => _showBreakoutRooms = false),
              ),
            ),

          // Icebreaker overlay
          if (_showIcebreaker)
            Positioned.fill(
              child: IcebreakerWidget(onClose: () => setState(() => _showIcebreaker = false)),
            ),

          // Theme selector overlay
          if (_showThemeSelector)
            Positioned(
              top: 100,
              right: 20,
              child: ThemeSelectorWidget(
                currentTheme: RoomTheme.cyberpunkNoir,
                onClose: () => setState(() => _showThemeSelector = false),
                onThemeSelected: (RoomTheme theme) {
                  print('Theme selected: $theme');
                  setState(() => _showThemeSelector = false);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Video call button (LiveKit)
          FloatingActionButton(
            heroTag: 'video',
            onPressed: _isVideoInitialized ? _joinVideoRoom : null,
            backgroundColor: _isVideoInitialized
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            child: const Icon(Icons.videocam, color: Colors.black),
          ),
          const SizedBox(height: 10),
          // Create room button
          FloatingActionButton(
            heroTag: 'create',
            onPressed: () => _createNewRoom(context),
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _openMessaging() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (_, __) => const UniversalMessagingSheet(
          section: MessagingSection.live,
          targetUserId: 'unknown',
          displayName: 'user',
        ),
      ),
    );
  }

  Widget _buildUserGrid(AsyncValue<List<UserProfile>> usersAsync) {
    return usersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace st) => Center(child: Text('Error: $e')),
      data: (List<UserProfile> users) {
        if (users.isEmpty) {
          return const Center(
            child: Text(
              'No users live right now.',
              style: TextStyle(color: NVSColors.ultraLightMint),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final UserProfile user = users[index];
              return _LiveUserTile(user: user);
            },
          ),
        );
      },
    );
  }

  Widget _buildRoomGrid(List<dynamic> rooms) {
    // Convert dynamic rooms to LiveRoom objects
    final List<LiveRoom> liveRooms = rooms.whereType<LiveRoom>().toList();

    return RoomGridView(rooms: liveRooms, onJoin: _handleRoomJoin);
  }

  /// Handle room joining with entry guard validation
  Future<void> _handleRoomJoin(LiveRoom room) async {
    try {
      // Check if user can quick join (no restrictions)
      if (RoomEntryService.canQuickJoin(room)) {
        final bool confirmed = await RoomEntryService.showQuickEntryDialog(
          context: context,
          room: room,
        );

        if (confirmed) {
          await _joinRoom(room);
        }
      } else {
        // Use comprehensive entry guard for restricted rooms
        final bool accessGranted = await RoomEntryService.attemptRoomEntry(
          context: context,
          room: room,
          enableDebugMode: true, // Enable for testing
        );

        if (accessGranted) {
          await _navigateToRoom(room);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join room: $e'), backgroundColor: NVSColors.electricPink),
      );
    }
  }

  /// Join room directly (for quick join scenarios)
  Future<void> _joinRoom(LiveRoom room) async {
    // Navigate to LiveKit view directly
    await _navigateToRoom(room);
  }

  /// Navigate to the live video room screen
  Future<void> _navigateToRoom(LiveRoom room) async {
    if (!mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => NvsLiveView(
          roomName: room.id,
          identity: 'me',
          moderationBase: 'https://nvs-livekit-production.herokuapp.com',
          groupChatStream: Stream<List<NvsChatMessage>>.periodic(
            const Duration(seconds: 1),
            (_) => const <NvsChatMessage>[],
          ),
          sendGroupMessage: (String text) async {},
          dmStream: (String _) => const Stream<List<DmMessage>>.empty(),
          sendDm: (String _, String __) async {},
        ),
      ),
    );
  }

  void _createNewRoom(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: NVSColors.pureBlack,
        title: const Text('Create Live Room', style: TextStyle(color: NVSColors.ultraLightMint)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Choose room type:', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _joinVideoRoom();
              },
              style: ElevatedButton.styleFrom(backgroundColor: NVSColors.ultraLightMint),
              child: const Text('Video Room', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Audio rooms coming soon!')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NVSColors.ultraLightMint.withValues(alpha: 0.7),
              ),
              child: const Text('Audio Room', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinVideoRoom() async {
    // Quick-start LiveKit view without constructing a full LiveRoom
    if (!mounted) return;
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => NvsLiveView(
          roomName: 'nvs_live_channel',
          identity: 'me',
          moderationBase: 'https://nvs-livekit-production.herokuapp.com',
          groupChatStream: Stream<List<NvsChatMessage>>.periodic(
            const Duration(seconds: 1),
            (_) => const <NvsChatMessage>[],
          ),
          sendGroupMessage: (String text) async {},
          dmStream: (String _) => const Stream<List<DmMessage>>.empty(),
          sendDm: (String _, String __) async {},
        ),
      ),
    );
  }
}

class _LiveUserTile extends StatelessWidget {
  const _LiveUserTile({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final String? liveStatus = user.toJson()['liveStatus'] as String?;
    final bool isBroadcasting = user.toJson()['isBroadcasting'] == true;
    return GestureDetector(
      onTap: () => context.go('/profile/${user.id}'),
      child: Card(
        color: NVSColors.pureBlack.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: NVSColors.ultraLightMint.withValues(alpha: 0.3)),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  CircleAvatar(
                    radius: 38,
                    backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty
                        ? NetworkImage(user.photoURL!)
                        : null,
                    backgroundColor: NVSColors.ultraLightMint.withValues(alpha: 0.1),
                    child: user.photoURL == null || user.photoURL!.isEmpty
                        ? const Icon(Icons.person, size: 38, color: NVSColors.ultraLightMint)
                        : null,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isBroadcasting ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isBroadcasting ? 'LIVE' : 'Online',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                user.displayName,
                style: const TextStyle(
                  color: NVSColors.ultraLightMint,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (liveStatus != null && liveStatus.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  liveStatus,
                  style: TextStyle(
                    color: NVSColors.ultraLightMint.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
