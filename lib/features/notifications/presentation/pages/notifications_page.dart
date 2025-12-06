import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/features/notifications/data/notification_model.dart';
import '../../data/notification_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AppNotification>> notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppTheme.primaryTextColor),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Error: $e')),
        data: (List<AppNotification> notifications) {
          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              final AppNotification n = notifications[index];
              return ListTile(
                tileColor:
                    n.read ? AppTheme.surfaceColor : AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(_iconForType(n.type), color: AppTheme.primaryColor),
                title: Text(
                  n.title,
                  style: const TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: n.body != null
                    ? Text(
                        n.body!,
                        style: const TextStyle(color: AppTheme.secondaryTextColor),
                      )
                    : null,
                onTap: () {
                  // TODO: Navigate to relevant section based on n.type/targetId
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Navigate to ${n.type}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'message':
        return Icons.message;
      case 'invite':
        return Icons.group_add;
      default:
        return Icons.notifications;
    }
  }
}
