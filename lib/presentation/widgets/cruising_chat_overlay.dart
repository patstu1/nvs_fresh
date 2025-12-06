/// NVS CRUISING CHAT OVERLAY — DARK, SEXY, ANON CHAT THREAD
/// One file includes: model, mock data, and chat overlay UI for Now screen
library;

/// ---------------------------
/// FILE: lib/features/now/presentation/widgets/cruising_chat_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cruising Message Model
class CruisingMessage {
  final String content;
  final bool isAnonymous;
  final String timestamp;

  CruisingMessage({
    required this.content,
    required this.isAnonymous,
    required this.timestamp,
  });
}

/// Mock Cruising Message Feed Provider
final cruisingChatProvider = Provider<List<CruisingMessage>>((ref) {
  return [
    CruisingMessage(content: 'hosting', isAnonymous: true, timestamp: 'now'),
    CruisingMessage(
      content: 'looking 2 breed',
      isAnonymous: true,
      timestamp: '2m ago',
    ),
    CruisingMessage(
      content: 'down to dump rn',
      isAnonymous: false,
      timestamp: '10m ago',
    ),
  ];
});

/// Cruising Chat Overlay Widget
class CruisingChatOverlay extends ConsumerWidget {
  const CruisingChatOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(cruisingChatProvider);
    final controller = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.fireplace_outlined, color: Color(0xFFA7FFE0)),
              SizedBox(width: 6),
              Text(
                'Cruising Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: msg.isAnonymous
                            ? Colors.grey[800]
                            : Colors.white12,
                        radius: 14,
                        child: Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.white38,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.isAnonymous ? 'anonymous' : 'user',
                              style: TextStyle(
                                color: Color(0xFFA7FFE0),
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              msg.content,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              msg.timestamp,
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'type something...',
                    hintStyle: TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Color(0xFF1B1B1B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  controller.clear();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFA7FFE0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.send, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// USAGE:
/// In your now_view.dart → Stack children, add:
/// showModalBottomSheet(
///   context: context,
///   backgroundColor: Colors.transparent,
///   builder: (context) => CruisingChatOverlay(),
/// );
