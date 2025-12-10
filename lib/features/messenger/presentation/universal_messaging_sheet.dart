import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import '../../messages/state/chat_thread_provider.dart';
import '../../messages/domain/models/message_thread.dart';
import '../../messages/domain/models/message.dart';
import '../data/messenger_service.dart';

enum MessagingSection { grid, now, live, connect }

class UniversalMessagingSheet extends ConsumerStatefulWidget {
  const UniversalMessagingSheet({
    required this.section,
    required this.targetUserId,
    required this.displayName,
    super.key,
    this.avatarUrl,
  });
  final MessagingSection section;
  final String targetUserId;
  final String displayName;
  final String? avatarUrl;

  @override
  ConsumerState<UniversalMessagingSheet> createState() => _UniversalMessagingSheetState();
}

class _UniversalMessagingSheetState extends ConsumerState<UniversalMessagingSheet> {
  final TextEditingController _textController = TextEditingController();
  final MessengerService _svc = MessengerService();
  late MessageThread _thread;

  @override
  void initState() {
    super.initState();
    _thread = ref
        .read(chatThreadListProvider.notifier)
        .createThread(
          userId: widget.targetUserId,
          displayName: widget.displayName,
          context: _toContext(widget.section),
          avatarUrl: widget.avatarUrl,
        );
  }

  ChatContextType _toContext(MessagingSection s) {
    switch (s) {
      case MessagingSection.grid:
        return ChatContextType.grid;
      case MessagingSection.now:
        return ChatContextType.now;
      case MessagingSection.live:
        return ChatContextType.live;
      case MessagingSection.connect:
        return ChatContextType.connect;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: NVSColors.pureBlack,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: NVSColors.ultraLightMint.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'universal messaging',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.ultraLightMint,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _action('yo', Icons.flash_on, _sendYo),
                _action('camera', Icons.photo_camera, _openCamera),
                _action('private album', Icons.lock, _sharePrivateAlbum),
                _action('location', Icons.location_on, _shareLocation),
                _action('block', Icons.block, _blockUser),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: NVSColors.ultraLightMint,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'type a message…',
                      hintStyle: TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        color: NVSColors.secondaryText,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: NVSColors.ultraLightMint),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NVSColors.ultraLightMint,
                    foregroundColor: NVSColors.pureBlack,
                  ),
                  child: const Text('send', style: TextStyle(fontFamily: 'MagdaCleanMono')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(String label, IconData icon, VoidCallback onTap) {
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: NVSColors.ultraLightMint),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.secondaryText,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _sendText() {
    final String text = _textController.text.trim();
    if (text.isEmpty) return;
    ref.read(chatThreadListProvider.notifier).sendMessage(threadId: _thread.id, text: text);
    _svc.sendMessage(
      threadId: _thread.id,
      content: text,
      context: widget.section.name.toUpperCase(),
    );
    _textController.clear();
  }

  void _sendYo() => _svc.sendYo(receiverWalletAddress: widget.targetUserId);
  void _openCamera() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: NVSColors.neonMint),
                title: const Text(
                  'send photo from library',
                  style: TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.ultraLightMint),
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final ImagePicker picker = ImagePicker();
                  final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    await _uploadAndSendMedia(picked, isPrivate: false);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: NVSColors.neonLime),
                title: const Text(
                  'send video from library',
                  style: TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.ultraLightMint),
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final ImagePicker picker = ImagePicker();
                  final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
                  if (picked != null) {
                    await _uploadAndSendMedia(picked, isPrivate: false);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline, color: NVSColors.electricPink),
                title: const Text(
                  'send private photo',
                  style: TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.ultraLightMint),
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final ImagePicker picker = ImagePicker();
                  final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    await _uploadAndSendMedia(picked, isPrivate: true);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_camera_back, color: NVSColors.electricPink),
                title: const Text(
                  'send private video',
                  style: TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.ultraLightMint),
                ),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final ImagePicker picker = ImagePicker();
                  final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
                  if (picked != null) {
                    await _uploadAndSendMedia(picked, isPrivate: true);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadAndSendMedia(XFile file, {required bool isPrivate}) async {
    try {
      final String ext = file.name.toLowerCase();
      final bool isVideo = ext.endsWith('.mp4') || ext.endsWith('.mov') || ext.endsWith('.m4v');
      final String folder = isVideo ? 'videos' : 'images';
      final String privacy = isPrivate ? 'private' : 'public';
      final String objectPath =
          'chat-media/${_thread.id}/$privacy/$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name}';

      final Reference ref = FirebaseStorage.instance.ref().child(objectPath);
      final UploadTask task = ref.putFile(File(file.path));
      await task.whenComplete(() {});
      final String url = await ref.getDownloadURL();

      await _svc.sendMessage(
        threadId: _thread.id,
        content: url,
        messageType: isVideo ? 'VIDEO' : 'IMAGE',
        context: widget.section.name.toUpperCase(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${isPrivate ? 'private ' : ''}${isVideo ? 'video' : 'image'} sent',
              style: const TextStyle(fontFamily: 'MagdaCleanMono'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'failed to send media: $e',
              style: const TextStyle(fontFamily: 'MagdaCleanMono'),
            ),
          ),
        );
      }
    }
  }

  void _sharePrivateAlbum() {
    // Send a structured request message via existing GraphQL endpoint
    _svc.sendMessage(
      threadId: _thread.id,
      content: 'REQUEST_PRIVATE_ALBUM',
      messageType: 'PRIVATE_ALBUM_REQUEST',
      context: widget.section.name.toUpperCase(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('private album request sent', style: TextStyle(fontFamily: 'MagdaCleanMono')),
      ),
    );
  }

  Future<void> _shareLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'location permission denied';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'location permission permanently denied';
      }

      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final String appleMaps = 'http://maps.apple.com/?ll=${pos.latitude},${pos.longitude}';
      final String googleMaps =
          'https://www.google.com/maps/dir/?api=1&destination=${pos.latitude},${pos.longitude}';
      final String payload = '📍 location\napple maps: $appleMaps\ngoogle maps: $googleMaps';

      await _svc.sendMessage(
        threadId: _thread.id,
        content: payload,
        messageType: 'LOCATION',
        context: widget.section.name.toUpperCase(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('location sent', style: TextStyle(fontFamily: 'MagdaCleanMono')),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'failed to get location: $e',
              style: const TextStyle(fontFamily: 'MagdaCleanMono'),
            ),
          ),
        );
      }
    }
  }

  void _blockUser() {
    _svc.sendMessage(
      threadId: _thread.id,
      content: 'BLOCK_USER:${widget.targetUserId}',
      messageType: 'BLOCK',
      context: widget.section.name.toUpperCase(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('user blocked request sent', style: TextStyle(fontFamily: 'MagdaCleanMono')),
      ),
    );
  }
}
