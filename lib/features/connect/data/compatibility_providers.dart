import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'compatibility_repository.dart';

final Provider<CompatibilityRepository> compatibilityRepositoryProvider =
    Provider<CompatibilityRepository>((ProviderRef<CompatibilityRepository> ref) {
  return CompatibilityRepository(FirebaseFirestore.instance);
});

final StreamProviderFamily<CompatibilityData?, ({String userId, String matchId})>
    compatibilityStreamProvider = StreamProvider.family<CompatibilityData?, ({String userId, String matchId})>((StreamProviderRef<CompatibilityData?> ref, ({String matchId, String userId}) ids) {
  final CompatibilityRepository repo = ref.watch(compatibilityRepositoryProvider);
  return repo.watchCompatibility(ids.userId, ids.matchId);
});



