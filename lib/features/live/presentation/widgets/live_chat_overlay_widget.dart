// lib/features/live/presentation/widgets/live_chat_overlay_widget.dart

import 'package:flutter/material.dart';

class LiveChatOverlay extends StatelessWidget {
  const LiveChatOverlay({
    required this.messages,
    required this.onSend,
    super.key,
  });
  final List<String> messages;
  final void Function(String) onSend;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          border: const Border(top: BorderSide(color: Colors.white12, width: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 160,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (_, int index) {
                  final String msg = messages[messages.length - 1 - index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      msg,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: const Color(0xFFB2FFD6),
                    decoration: InputDecoration(
                      hintText: 'Say something...',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
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
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    final String msg = controller.text.trim();
                    if (msg.isNotEmpty) {
                      onSend(msg);
                      controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: Color(0xFFB2FFD6)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
