import 'dart:convert';
import 'package:http/http.dart' as http;

/// Zero-tolerance moderation hooks.
/// Backend must instantly eject & ban on banned topics (child/animal).
class ModerationService {
  // e.g., https://api.yourdomain.com
  ModerationService(this.baseUrl);
  final String baseUrl;

  /// Stream transcript + metadata for AI monitoring (server enforces).
  Future<void> sendTranscriptChunk({
    required String room,
    required String speakerId,
    required String text,
    required DateTime at,
  }) async {
    final http.Response r = await http.post(
      Uri.parse('$baseUrl/v1/live/mod/ingest'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'room': room,
        'speakerId': speakerId,
        'text': text,
        'at': at.toIso8601String(),
      }),
    );
    if (r.statusCode >= 300) {
      throw Exception('Moderation ingest failed: ${r.statusCode} ${r.body}');
    }
  }

  /// Server returns actions if thresholds hit (eject/report).
  Future<void> heartbeat(String room) async {
    final http.Response r = await http.post(
      Uri.parse('$baseUrl/v1/live/mod/heartbeat'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'room': room}),
    );
    if (r.statusCode >= 300) {
      throw Exception('Moderation heartbeat failed: ${r.statusCode} ${r.body}');
    }
  }
}









