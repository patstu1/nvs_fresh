import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'people_repository.dart';

final Provider<PeopleRepository> peopleRepositoryProvider =
    Provider<PeopleRepository>((Ref ref) => PeopleRepository());

class NowFilters {
  const NowFilters({
    required this.distanceKm,
    required this.ageMin,
    required this.ageMax,
    this.verified,
    this.online,
    this.sort = 'score',
    this.tags = const <String>[],
  });
  final double distanceKm;
  final int ageMin;
  final int ageMax;
  final bool? verified;
  final bool? online;
  final String sort;
  final List<String> tags;
}

final StateProvider<NowFilters> nowFiltersProvider = StateProvider<NowFilters>(
  (Ref ref) => const NowFilters(distanceKm: 50, ageMin: 18, ageMax: 80),
);


