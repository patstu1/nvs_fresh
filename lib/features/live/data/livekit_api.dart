import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/nvs_brand.dart';

class LivekitApi {
  const LivekitApi();

  Future<String> getToken({required String identity, required String room}) async {
    final http.Response res = await http.post(
      Uri.parse(NvsBrand.tokenEndpoint),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'identity': identity, 'room': room}),
    );
    if (res.statusCode != 200) {
      throw Exception('Token error: ${res.statusCode} ${res.body}');
    }
    return (jsonDecode(res.body) as Map<String, dynamic>)['token'] as String;
  }

  // Optional: send moderation report to backend
  Future<void> reportModeration({
    required String room,
    required String offender,
    required String reason,
    required String payload,
  }) async {
    try {
      await http.post(
        Uri.parse('https://YOUR_API/v1/moderation/report'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'room': room,
          'offender': offender,
          'reason': reason,
          'payload': payload,
        }),
      );
    } catch (_) {/* fire-and-forget */}
  }
}











