// lib/features/messenger/presentation/chat_threads_list_view.dart

import 'package:flutter/material.dart';
import 'package:nvs/features/messenger/presentation/chat_detail_view.dart';

class ChatThreadsListView extends StatelessWidget {
  const ChatThreadsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Placeholder count
      itemBuilder: (BuildContext context, int index) {
        return _buildThreadTile(
          context: context,
          threadId: 'thread_$index',
          userName: 'User $index',
          lastMessage: 'Last message preview...',
          timestamp: '2m ago',
          unreadCount: index % 3 == 0 ? index + 1 : 0,
        );
      },
    );
  }

  Widget _buildThreadTile({
    required BuildContext context,
    required String threadId,
    required String userName,
    required String lastMessage,
    required String timestamp,
    required int unreadCount,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        userName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: TextStyle(
          color: Colors.grey[400],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
          if (unreadCount > 0) ...<Widget>[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatDetailView(threadId: threadId),
          ),
        );
      },
    );
  }
}
