// lib/features/connect/data/models/connect_ai_compatibility_report.dart

class AICompatibilityReport {
  AICompatibilityReport({
    required this.compatibilityPercent,
    required this.cosmicVerdict,
  });

  factory AICompatibilityReport.fromJson(Map<String, dynamic> json) {
    return AICompatibilityReport(
      compatibilityPercent: json['compatibilityPercent'] ?? '0%',
      cosmicVerdict: json['cosmicVerdict'] ?? '',
    );
  }
  final String compatibilityPercent;
  final String cosmicVerdict;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'compatibilityPercent': compatibilityPercent,
      'cosmicVerdict': cosmicVerdict,
    };
  }
}
