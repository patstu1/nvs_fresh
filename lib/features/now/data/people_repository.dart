import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';

class PersonItem {
  PersonItem({
    required this.id,
    required this.name,
    required this.age,
    required this.thumbUrl,
    required this.lat,
    required this.lng,
    required this.verified,
    required this.lastActive,
    required this.score,
  });

  factory PersonItem.fromJson(Map<String, dynamic> j) => PersonItem(
        id: (j['id'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        age: (j['age'] ?? 0) as int,
        thumbUrl: (j['thumbUrl'] ?? '').toString(),
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
        verified: (j['verified'] ?? false) as bool,
        lastActive: DateTime.tryParse((j['lastActive'] ?? '').toString()) ?? DateTime.now(),
        score: (j['score'] as num?)?.toDouble() ?? 0.0,
      );
  final String id;
  final String name;
  final int age;
  final String thumbUrl;
  final double lat;
  final double lng;
  final bool verified;
  final DateTime lastActive;
  final double score;
}

class PeopleRepository {
  final Dio _dio = ApiClient.I.dio;

  Future<List<PersonItem>> fetchPeople({
    required double neLat,
    required double neLng,
    required double swLat,
    required double swLng,
    double distanceKm = 50,
    int ageMin = 18,
    int ageMax = 80,
    bool? verified,
    bool? online,
    String sort = 'score',
    List<String> tags = const <String>[],
  }) async {
    final Response<dynamic> res = await _dio.get(
      '/people',
      queryParameters: <String, dynamic>{
        'nelat': neLat,
        'nelng': neLng,
        'swlat': swLat,
        'swlng': swLng,
        'distance_km': distanceKm,
        'age_min': ageMin,
        'age_max': ageMax,
        if (verified != null) 'verified': verified,
        if (online != null) 'online': online,
        'sort': sort,
        if (tags.isNotEmpty) 'tags': tags.join(','),
      },
    );
    final List<dynamic> arr = res.data as List<dynamic>? ?? <dynamic>[];
    return arr.map((dynamic e) => PersonItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}


