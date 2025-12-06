// features/connect/data/models/ai_compatibility_report.dart

class AICompatibilityReport {
  AICompatibilityReport({
    required this.compatibilityScore,
    required this.cosmicVerdict,
    required this.yourAstroProfile,
    required this.theirAstroProfile,
    required this.heatZones,
    required this.vibeMatchDescription,
    required this.dynamicChartSummary,
    required this.shadowAnalysis,
    required this.aiFinalVerdict,
    required this.isRecommended,
  });

  // MOCK: for loading offline test data
  factory AICompatibilityReport.mock() {
    return AICompatibilityReport(
      compatibilityScore: 78,
      cosmicVerdict: 'You’ll either fuck on sight or fight about daddy issues.',
      yourAstroProfile:
          'Scorpio sun, Leo moon, Virgo rising. Intense. You read people before they even speak.',
      theirAstroProfile: 'Pisces sun, Libra moon, Gemini rising. Sweet talker with a chaos streak.',
      heatZones:
          '🔥 Mars square Venus = magnetic tension. 🧊 Moon opposition = emotional misunderstanding.',
      vibeMatchDescription: 'Your kinks align, but your triggers might too.',
      dynamicChartSummary: 'Saturn return meets Pluto in retrograde — a karmic collision course.',
      shadowAnalysis:
          'You both idealize partners then panic when they get too close. Trauma twins.',
      aiFinalVerdict:
          'This will either be the best sex of your life or the start of your villain origin story.',
      isRecommended: true,
    );
  }
  final int compatibilityScore; // e.g., 78
  final String cosmicVerdict;

  final String yourAstroProfile;
  final String theirAstroProfile;

  final String heatZones; // textual summary of hot/cold areas
  final String vibeMatchDescription;

  final String dynamicChartSummary;
  final String shadowAnalysis;

  final String aiFinalVerdict; // bold opinionated sentence
  final bool isRecommended;
}
