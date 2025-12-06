import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'livekit_controller.dart';
import 'nvs_live_constants.dart';
import 'nvs_video_tile.dart';
import 'nvs_group_chat.dart';
import 'nvs_dm_sheet.dart';
import 'moderation_service.dart';

enum LiveViewMode { gallery, list }

class NvsLiveView extends StatefulWidget {
  const NvsLiveView({
    required this.roomName,
    required this.identity,
    required this.moderationBase,
    required this.groupChatStream,
    required this.sendGroupMessage,
    required this.dmStream,
    required this.sendDm,
    super.key,
  });
  final String roomName; // e.g., "Los_Angeles"
  final String identity; // wallet address or user id
  final String moderationBase; // backend base url for moderation API
  final Stream<List<NvsChatMessage>> groupChatStream;
  final Future<void> Function(String text) sendGroupMessage;
  final Stream<List<DmMessage>> Function(String otherUserId) dmStream;
  final Future<void> Function(String otherUserId, String text) sendDm;

  @override
  State<NvsLiveView> createState() => _NvsLiveViewState();
}

class _NvsLiveViewState extends State<NvsLiveView> with TickerProviderStateMixin {
  final LiveKitController _lk = LiveKitController();
  final AudioPlayer _audio = AudioPlayer();
  final List<StreamSubscription<dynamic>> _mods = <StreamSubscription<dynamic>>[];

  LiveViewMode _mode = LiveViewMode.gallery;
  Participant? _pinned;
  List<Participant> _participants = <Participant>[];
  late final ModerationService _moderation;

  @override
  void initState() {
    super.initState();
    _moderation = ModerationService(widget.moderationBase);
    _boot();
  }

  Future<void> _boot() async {
    await _lk.connect(
      roomName: widget.roomName,
      identity: widget.identity,
      onParticipantsChanged: _refresh,
    );

    unawaited(_audio.setReleaseMode(ReleaseMode.loop));
    unawaited(_audio.play(UrlSource(berlinBeachouseUrl)));

    _mods.add(
      Stream.periodic(const Duration(seconds: 10)).listen((_) {
        _moderation.heartbeat(widget.roomName);
      }),
    );
    _refresh();
  }

  void _refresh() {
    final Room? room = _lk.room;
    if (room == null) return;
    final List<Participant> others = <Participant>[...room.remoteParticipants.values];
    final LocalParticipant? me = room.localParticipant;
    setState(() {
      _participants = <Participant>[...others, if (me != null) me];
      if (_pinned != null && !_participants.contains(_pinned)) {
        _pinned = null;
      }
    });
  }

  @override
  void dispose() {
    for (final StreamSubscription<dynamic> s in _mods) {
      s.cancel();
    }
    _audio.dispose();
    _lk.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Room? room = _lk.room;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: _mainArea()),
            Positioned(
              top: 12,
              right: 12,
              bottom: 12,
              child: NvsGroupChat(
                roomName: widget.roomName,
                messageStream: widget.groupChatStream,
                onSend: widget.sendGroupMessage,
              ),
            ),
            Positioned(
              top: 10,
              left: 12,
              right: 360,
              child: Row(
                children: <Widget>[
                  _segmented(),
                  const Spacer(),
                  if (room != null) _camsStatus(room),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segmented() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: nvsMint.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _segBtn('Gallery', _mode == LiveViewMode.gallery, () {
            setState(() => _mode = LiveViewMode.gallery);
          }),
          _segBtn('List', _mode == LiveViewMode.list, () {
            setState(() => _mode = LiveViewMode.list);
          }),
        ],
      ),
    );
  }

  Widget _segBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? nvsMint : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  Widget _camsStatus(Room room) {
    final bool localOn = room.localParticipant?.isCameraEnabled() ?? false;
    return Row(
      children: <Widget>[
        Icon(
          localOn ? Icons.videocam : Icons.videocam_off,
          color: localOn ? nvsMint : Colors.redAccent,
          size: 20,
        ),
        const SizedBox(width: 6),
        Text(
          localOn ? 'Camera On' : 'Camera Off',
          style: TextStyle(color: localOn ? nvsMint : Colors.redAccent),
        ),
      ],
    );
  }

  Widget _mainArea() {
    if (_mode == LiveViewMode.list) return _listView();
    return _galleryView();
  }

  Widget _galleryView() {
    if (_pinned != null) {
      final Participant pinned = _pinned!;
      return Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 56, 380, 12),
              child: NvsVideoTile(
                participant: pinned,
                onPin: (_) {},
              ),
            ),
          ),
          _miniStrip(),
          _pinnedActions(),
          const SizedBox(height: 10),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 56, 380, 12),
      child: GridView.builder(
        itemCount: _participants.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (BuildContext _, int i) => NvsVideoTile(
          participant: _participants[i],
          onPin: (Participant p) => setState(() => _pinned = p),
        ),
      ),
    );
  }

  Widget _miniStrip() {
    final List<Participant> others = _participants.where((Participant p) => p != _pinned).toList();
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 392, 8),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext _, int __) => const SizedBox(width: 10),
        itemCount: others.length,
        itemBuilder: (BuildContext _, int i) => AspectRatio(
          aspectRatio: 16 / 9,
          child: NvsVideoTile(
            participant: others[i],
            onPin: (Participant p) => setState(() => _pinned = p),
          ),
        ),
      ),
    );
  }

  Widget _pinnedActions() {
    if (_pinned == null) return const SizedBox.shrink();
    final String otherId = _pinned!.identity ?? 'user';
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 392, 0),
      child: Row(
        children: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: nvsMint,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _openDm(otherId),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Direct Message'),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: nvsMint,
              side: const BorderSide(color: nvsMint, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => setState(() => _pinned = null),
            icon: const Icon(Icons.close),
            label: const Text('Unpin'),
          ),
        ],
      ),
    );
  }

  Widget _listView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 56, 380, 12),
      child: ListView.separated(
        itemCount: _participants.length,
        separatorBuilder: (BuildContext _, int __) => const Divider(color: Colors.white12),
        itemBuilder: (BuildContext _, int i) {
          final Participant p = _participants[i];
          final bool camOn = p.isCameraEnabled();
          return ListTile(
            onTap: () => setState(() => _pinned = p),
            leading: Icon(
              camOn ? Icons.videocam : Icons.videocam_off,
              color: camOn ? nvsMint : Colors.redAccent,
            ),
            title: Text(p.identity ?? 'user', style: const TextStyle(color: Colors.white)),
            trailing: IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: nvsMint),
              onPressed: () => _openDm(p.identity ?? 'user'),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openDm(String otherUserId) async {
    if (!mounted) return;
    final Stream<List<DmMessage>> stream = widget.dmStream(otherUserId);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NvsDmSheet(
        otherUserId: otherUserId,
        messageStream: stream,
        onSend: (String text) => widget.sendDm(otherUserId, text),
      ),
    );
  }
}
