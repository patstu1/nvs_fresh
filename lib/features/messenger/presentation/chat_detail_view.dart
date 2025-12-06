// lib/features/messenger/presentation/chat_detail_view.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../live/nvs_live_view.dart';

class ChatDetailView extends StatefulWidget {
  const ChatDetailView({required this.threadId, super.key});
  final String threadId;

  @override
  _ChatDetailViewState createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          // Status bar padding
          SizedBox(height: MediaQuery.of(context).padding.top),

          // --- Header with user's name and video call button ---
          _buildChatHeader(),

          // --- The message list ---
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Placeholder count
              itemBuilder: (BuildContext context, int index) {
                return _buildMessageBubble(
                  message: 'Sample message $index',
                  isFromCurrentUser: index % 2 == 0,
                );
              },
            ),
          ),

          // --- The rich input bar ---
          _buildRichInputBar(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'Username', // Fetched from thread data
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.videocam_rounded,
              color: Colors.cyan,
              size: 28,
            ),
            onPressed: _initiateVideoCall,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isFromCurrentUser,
  }) {
    return Align(
      alignment: isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isFromCurrentUser ? Colors.cyan : Colors.grey[800],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isFromCurrentUser ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRichInputBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.black.withOpacity(0.5),
      child: Row(
        children: <Widget>[
          // Button to send a private photo that requires an unlock
          IconButton(
            icon: const Icon(Icons.lock_rounded, color: Colors.yellow),
            onPressed: _sendPrivateImage,
          ),

          // Button to send a photo from the camera roll
          IconButton(
            icon: const Icon(Icons.photo_library_rounded, color: Colors.grey),
            onPressed: _sendImage,
          ),

          // The text input field
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                filled: true,
                fillColor: Colors.grey[900],
              ),
              onSubmitted: (String text) {
                if (text.isNotEmpty) {
                  _sendTextMessage(text);
                  _messageController.clear();
                }
              },
            ),
          ),

          const SizedBox(width: 8),

          // The "YO" button
          TextButton(
            onPressed: _sendYo,
            style: TextButton.styleFrom(
              backgroundColor: Colors.yellow.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'YO',
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initiateVideoCall() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const NvsLiveView(
          roomName: 'nvs_live_channel',
          identity: 'me',
          moderationBase: 'https://nvs-livekit-production.herokuapp.com',
          groupChatStream: Stream.empty(),
          sendGroupMessage: _noopGroup,
          dmStream: _noopDmStream,
          sendDm: _noopDm,
        ),
      ),
    );
  }

  static Future<void> _noopGroup(String _) async {}
  static Stream<List<DmMessage>> _noopDmStream(String _) => const Stream<List<DmMessage>>.empty();
  static Future<void> _noopDm(String _, String __) async {}

  Future<void> _sendPrivateImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // TODO: Send image with locked flag via GraphQL
      print('Sending private image: ${image.path}');
    }
  }

  Future<void> _sendImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // TODO: Send regular image via GraphQL
      print('Sending image: ${image.path}');
    }
  }

  void _sendTextMessage(String text) {
    // TODO: Send text message via GraphQL
    print('Sending message: $text to thread: ${widget.threadId}');
  }

  void _sendYo() {
    // TODO: Send YO message type via GraphQL
    print('Sending YO to thread: ${widget.threadId}');
  }
}
