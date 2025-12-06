import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_model.dart';
import 'notification_repository.dart';

final Provider<NotificationRepository> notificationRepositoryProvider =
    Provider<NotificationRepository>((ProviderRef<NotificationRepository> ref) {
  return NotificationRepository();
});

final StreamProvider<List<AppNotification>> notificationsProvider =
    StreamProvider<List<AppNotification>>((StreamProviderRef<List<AppNotification>> ref) {
  final NotificationRepository repo = ref.watch(notificationRepositoryProvider);
  return repo.getUserNotifications();
});
