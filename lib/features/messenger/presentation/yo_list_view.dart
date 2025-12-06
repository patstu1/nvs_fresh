// lib/features/messenger/presentation/yo_list_view.dart

import 'package:flutter/material.dart';
import 'package:nvs/features/messenger/presentation/chat_detail_view.dart';

class YoListView extends StatelessWidget {
  const YoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Placeholder count
      itemBuilder: (BuildContext context, int index) {
        return _buildYoTile(
          context: context,
          userName: 'User $index',
          timestamp: '${index + 1}h ago',
          walletAddress: '0x${index}abc123',
        );
      },
    );
  }

  Widget _buildYoTile({
    required BuildContext context,
    required String userName,
    required String timestamp,
    required String walletAddress,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: <Widget>[
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.black,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Sent you a YO',
          style: TextStyle(
            color: Colors.yellow[300],
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              timestamp,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  onPressed: () {
                    // Dismiss the YO
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat, color: Colors.cyan, size: 20),
                  onPressed: () {
                    // Start a chat with this user
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ChatDetailView(threadId: walletAddress),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
