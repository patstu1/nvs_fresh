import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Lightweight HTTP middleware that injects auth headers and handles logging.
class TokenMiddleware {
  const TokenMiddleware._();

  /// Executes an HTTP request against the authenticated API.
  static Future<http.Response?> apiRequest({
    required String baseUrl,
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final http.Client client = http.Client();

    try {
      final String verb = method.toUpperCase();
      http.Response response;

      switch (verb) {
        case 'GET':
          response = await client.get(uri, headers: headers).timeout(timeout);
          break;
        case 'POST':
          response = await client
              .post(
                uri,
                headers: _jsonHeaders(headers),
                body: body == null ? null : jsonEncode(body),
              )
              .timeout(timeout);
          break;
        case 'PUT':
          response = await client
              .put(
                uri,
                headers: _jsonHeaders(headers),
                body: body == null ? null : jsonEncode(body),
              )
              .timeout(timeout);
          break;
        case 'DELETE':
          response = await client
              .delete(
                uri,
                headers: _jsonHeaders(headers),
                body: body == null ? null : jsonEncode(body),
              )
              .timeout(timeout);
          break;
        default:
          throw UnsupportedError('Unsupported HTTP method: $method');
      }

      return response;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('TokenMiddleware request failed: $e');
        debugPrint(stackTrace.toString());
      }
      return null;
    } finally {
      client.close();
    }
  }

  static Map<String, String> _jsonHeaders(Map<String, String>? headers) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    };
  }
}
