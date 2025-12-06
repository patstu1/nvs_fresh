/// NVS CRUISING CHAT OVERLAY — DARK, SEXY, ANON CHAT THREAD
/// One file includes: model, mock data, and chat overlay UI for Now screen
library;

/// ---------------------------
/// FILE: lib/features/now/presentation/widgets/cruising_chat_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cruising Message Model
class CruisingMessage {
  CruisingMessage({
    required this.content,
    required this.isAnonymous,
    required this.timestamp,
  });
  final String content;
  final bool isAnonymous;
  final String timestamp;
}

/// Mock Cruising Message Feed Provider
final Provider<List<CruisingMessage>> cruisingChatProvider =
    Provider<List<CruisingMessage>>((ProviderRef<List<CruisingMessage>> ref) {
  return <CruisingMessage>[
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
    final List<CruisingMessage> messages = ref.watch(cruisingChatProvider);
    final TextEditingController controller = TextEditingController();

    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
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
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final CruisingMessage msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: msg.isAnonymous ? Colors.grey[800] : Colors.white12,
                        radius: 14,
                        child: const Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.white38,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              msg.isAnonymous ? 'anonymous' : 'user',
                              style: const TextStyle(
                                color: Color(0xFFA7FFE0),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              msg.content,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              msg.timestamp,
                              style: const TextStyle(
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
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'type something...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1B1B1B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.clear,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA7FFE0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.send, color: Colors.black),
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
