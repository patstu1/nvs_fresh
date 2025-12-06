import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  Future<void> initialize() async {}
  Future<void> requestPermission() async {}
  Future<void> showNotification(String title, String body) async {}
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
