import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_repository.dart';

final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>((ProviderRef<SettingsRepository> ref) {
  return SettingsRepository();
});

final FutureProvider<Map<String, dynamic>?> userSettingsProvider =
    FutureProvider<Map<String, dynamic>?>((FutureProviderRef<Map<String, dynamic>?> ref) async {
  final SettingsRepository repo = ref.watch(settingsRepositoryProvider);
  return repo.getUserSettings();
});

final FutureProviderFamily<void, Map<String, dynamic>> updateUserSettingsProvider =
    FutureProvider.family<void, Map<String, dynamic>>(
        (FutureProviderRef<void> ref, Map<String, dynamic> settings) async {
  final SettingsRepository repo = ref.watch(settingsRepositoryProvider);
  await repo.updateUserSettings(settings);
});
