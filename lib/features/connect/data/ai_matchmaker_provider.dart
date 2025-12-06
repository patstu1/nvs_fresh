// lib/features/connect/data/providers/ai_matchmaker_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/services/ai_service.dart';

final Provider<AiService> aiMatchmakerProvider =
    Provider<AiService>((ProviderRef<AiService> ref) => AiService());

final FutureProviderFamily<AICompatibilityReport, String> aiMatchReportProvider =
    FutureProvider.family<AICompatibilityReport, String>(
        (FutureProviderRef<AICompatibilityReport> ref, String targetUserId) async {
  final AiService aiService = ref.read(aiMatchmakerProvider);
  return aiService.getCompatibilityReport(targetUserId);
});
