// lib/features/auth/data/auth_api.dart
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';

class AuthApi {
  final ApiClient apiClient;

  AuthApi({required this.apiClient});

  /// Calls login endpoint.
  /// Expects token to be present in response headers (e.g. 'authorization' or 'x-auth-token').
  /// Response body is expected to contain user JSON (optional; adjust as needed).
  Future<Response> login({required String email, required String password}) {
    return apiClient.post(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> signup({required String email, required String password}) {
    return apiClient.post(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> me() {
    return apiClient.get('/api/v1/auth/profile');
  }
}
