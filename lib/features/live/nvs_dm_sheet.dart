import 'package:flutter/material.dart';
import 'nvs_live_constants.dart';

class NvsDmSheet extends StatefulWidget {
  const NvsDmSheet({
    required this.otherUserId,
    required this.messageStream,
    required this.onSend,
    super.key,
  });
  final String otherUserId;
  final Stream<List<DmMessage>> messageStream;
  final Future<void> Function(String text) onSend;

  @override
  State<NvsDmSheet> createState() => _NvsDmSheetState();
}

class _NvsDmSheetState extends State<NvsDmSheet> {
  final TextEditingController _controller = TextEditingController();
  List<DmMessage> _messages = <DmMessage>[];

  @override
  void initState() {
    super.initState();
    widget.messageStream.listen((List<DmMessage> msgs) => setState(() => _messages = msgs));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border.all(color: nvsMint.withOpacity(0.55), width: 1.2),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 46,
            alignment: Alignment.center,
            child: Container(
              width: 48,
              height: 4,
              decoration:
                  BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Text(
                  widget.otherUserId,
                  style: const TextStyle(color: nvsMint, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
              ],
            ),
          ),
          const Divider(height: 12, color: Colors.white12),
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (BuildContext _, int i) {
                final DmMessage m = _messages[_messages.length - 1 - i];
                final bool isMine = m.isMine;
                return Align(
                  alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMine ? nvsMint : Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(color: isMine ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          _input(),
        ],
      ),
    );
  }

  Widget _input() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: nvsMint,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Direct message',
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: nvsMint),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onSubmitted: _send,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: nvsMint,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _send(_controller.text),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _send(String t) async {
    final String text = t.trim();
    if (text.isEmpty) return;
    _controller.clear();
    await widget.onSend(text);
  }
}

class DmMessage {
  DmMessage({required this.id, required this.text, required this.isMine, required this.at});
  final String id;
  final String text;
  final bool isMine;
  final DateTime at;
}
