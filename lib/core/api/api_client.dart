import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Shared HTTP client configured with base URL and Firebase ID token header
class ApiClient {
  ApiClient._();
  static final ApiClient _instance = ApiClient._();
  static ApiClient get I => _instance;

  static const String _baseUrl = String.fromEnvironment('NVS_API_BASE');

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          final User? user = FirebaseAuth.instance.currentUser;
          final String? token = await user?.getIdToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

  Dio get dio => _dio;
  String get baseUrl => _baseUrl;
}


