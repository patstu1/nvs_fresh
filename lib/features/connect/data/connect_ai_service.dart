// lib/features/connect/data/connect_ai_service.dart

class UserProfile {
  UserProfile({
    required this.name,
    required this.role,
    required this.sun,
    required this.moon,
    required this.rising,
    required this.traits,
  });
  final String name;
  final String role;
  final String sun;
  final String moon;
  final String rising;
  final Map<String, int> traits;
}

class CompatibilityAIService {
  static int calculateMatchScore(UserProfile a, UserProfile b) {
    final Iterable<String> sharedKeys =
        a.traits.keys.where((String key) => b.traits.containsKey(key));
    double score = 0;

    for (final String key in sharedKeys) {
      final int delta = (a.traits[key]! - b.traits[key]!).abs();
      score += (10 - delta).clamp(0, 10);
    }

    return (score / sharedKeys.length * 10).clamp(0, 100).toInt();
  }

  static int estimateObsessionRisk(UserProfile profile) {
    return profile.traits['obsession'] ?? 0;
  }

  static bool isPolarityAligned(String roleA, String roleB) {
    final Map<String, List<String>> pairs = <String, List<String>>{
      'Top': <String>['Bottom', 'Vers Bottom'],
      'Bottom': <String>['Top', 'Vers Top'],
      'Vers': <String>['Vers'],
      'Power Bottom': <String>['Breeder', 'Top'],
      'Breeder': <String>['Bottom', 'Power Bottom'],
    };

    return pairs[roleA]?.contains(roleB) ?? false;
  }

  static String generateVerdict({
    required int compatibility,
    required int obsessionRisk,
    required bool polarityAligned,
  }) {
    if (compatibility > 85 && polarityAligned) {
      return 'Verdict: HIGH ALIGNMENT\nPsychological + sexual cohesion strong.';
    } else if (obsessionRisk > 7) {
      return 'Verdict: OBSSESSION RISK HIGH\nEngagement may spiral.';
    } else if (compatibility < 60) {
      return 'Verdict: LOW COMPATIBILITY\nCore needs conflict.';
    } else {
      return 'Verdict: MIXED FIELD\nPotential if emotional pacing is slow.';
    }
  }
}
