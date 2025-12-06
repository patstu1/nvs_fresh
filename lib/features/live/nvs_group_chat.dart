import 'package:flutter/material.dart';
import 'nvs_live_constants.dart';

class NvsGroupChat extends StatefulWidget {
  const NvsGroupChat({
    required this.roomName,
    required this.messageStream,
    required this.onSend,
    super.key,
  });
  final String roomName;
  final Stream<List<NvsChatMessage>> messageStream;
  final Future<void> Function(String text) onSend;

  @override
  State<NvsGroupChat> createState() => _NvsGroupChatState();
}

class _NvsGroupChatState extends State<NvsGroupChat> {
  final TextEditingController _controller = TextEditingController();
  List<NvsChatMessage> _messages = <NvsChatMessage>[];

  @override
  void initState() {
    super.initState();
    widget.messageStream.listen((List<NvsChatMessage> msgs) {
      setState(() => _messages = msgs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: nvsMint.withOpacity(0.5), width: 1.2),
      ),
      child: Column(
        children: <Widget>[
          _header(),
          const Divider(height: 1, color: Colors.white12),
          Expanded(child: _list()),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.roomName,
        style: const TextStyle(
          color: nvsMint,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _list() {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(12),
      itemCount: _messages.length,
      itemBuilder: (BuildContext context, int i) {
        final NvsChatMessage m = _messages[_messages.length - 1 - i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, height: 1.25),
              children: <TextSpan>[
                TextSpan(
                  text: m.sender,
                  style: const TextStyle(color: nvsMint, fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: '  '),
                TextSpan(text: m.text),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: nvsMint,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
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
              foregroundColor: Colors.black,
              backgroundColor: nvsMint,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _send(_controller.text),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _send(String text) async {
    final String t = text.trim();
    if (t.isEmpty) return;
    _controller.clear();
    await widget.onSend(t);
  }
}

class NvsChatMessage {
  NvsChatMessage({required this.id, required this.sender, required this.text, required this.at});
  final String id;
  final String sender;
  final String text;
  final DateTime at;
}


