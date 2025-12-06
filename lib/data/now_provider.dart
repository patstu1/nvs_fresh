import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'now_repository.dart';

final nowRepositoryProvider = Provider<NowRepository>((ref) {
  return NowRepository();
});

final nowUserListProvider = StreamProvider<List<UserProfile>>((ref) {
  final repo = ref.watch(nowRepositoryProvider);
  return repo.getNowUsers();
});
