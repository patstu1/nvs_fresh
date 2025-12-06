import '../models/connect_match_model.dart';

class ConnectAISummaryService {
  static String generateSummary(ConnectMatchModel match) {
    final double score = match.compatibilityScore;
    final String signPair = '${match.yourSign} + ${match.theirSign}';

    if (score >= 90) {
      return '$signPair? Dangerous and magnetic. This isn’t just a match — it’s a collision.';
    } else if (score >= 80) {
      return '$signPair creates a pull you can’t fake. You want what they’re giving.';
    } else if (score >= 70) {
      return 'There’s tension. That could mean chemistry — or war. You decide.';
    } else {
      return 'This is a warning — but maybe that’s exactly what you’re into.';
    }
  }
}
