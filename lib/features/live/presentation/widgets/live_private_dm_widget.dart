// lib/features/live/presentation/widgets/live_private_dm_widget.dart

import 'package:flutter/material.dart';

class LivePrivateDM extends StatelessWidget {
  const LivePrivateDM({
    required this.username,
    required this.avatarUrl,
    required this.messages,
    required this.onSend,
    required this.onClose,
    super.key,
  });
  final String username;
  final String avatarUrl;
  final List<String> messages;
  final void Function(String) onSend;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Material(
      color: Colors.black.withValues(alpha: 0.95),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          Row(
            children: <Widget>[
              const SizedBox(width: 16),
              CircleAvatar(backgroundImage: AssetImage(avatarUrl), radius: 24),
              const SizedBox(width: 12),
              Text(
                username,
                style: const TextStyle(
                  color: Color(0xFFB2FFD6),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: onClose,
              ),
              const SizedBox(width: 8),
            ],
          ),
          const Divider(color: Colors.white10, height: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (_, int index) {
                  final String msg = messages[messages.length - 1 - index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          msg,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: const Color(0xFFB2FFD6),
                    decoration: InputDecoration(
                      hintText: 'Say something private...',
                      hintStyle: const TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (String value) {
                      if (value.trim().isNotEmpty) {
                        onSend(value.trim());
                        controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    final String msg = controller.text.trim();
                    if (msg.isNotEmpty) {
                      onSend(msg);
                      controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: Color(0xFFCCFF33)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
