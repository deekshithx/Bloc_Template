// lib/features/auth/data/auth_repository_impl.dart
import 'package:bloc_template/features/auth/domain/auth_repository.dart';
import 'package:bloc_template/features/auth/domain/models/user.dart';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/storage/secure_storage.dart';

import 'auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi authApi;
  final SecureStorage secureStorage;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.authApi,
    required this.secureStorage,
    required this.apiClient,
  });

  /// Utility to extract token from a Response's headers.
  String? _extractToken(Response response) {
    // First, check if token is in body
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('access_token')) {
        return data['access_token'] as String?;
      }
      if (data.containsKey('token')) {
        return data['token'] as String?;
      }
    }

    // Fallback to headers if API sends it there
    final keys = [
      'authorization',
      'Authorization',
      'x-auth-token',
      'X-Auth-Token',
    ];
    for (final k in keys) {
      final v = response.headers.value(k);
      if (v != null && v.isNotEmpty) {
        if (v.toLowerCase().startsWith('bearer ')) {
          return v.substring(7).trim();
        }
        return v.trim();
      }
    }

    return null;
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final resp = await authApi.login(email: email, password: password);

    final token = _extractToken(resp);
    if (token == null) {
      throw Exception(
        'Auth token not found in response headers.',
      ); // adjust to custom exception if you prefer
    }

    // save token
    await secureStorage.writeAuthToken(token);

    // optionally set default authorization header for apiClient
    apiClient.dio.options.headers['Authorization'] = 'Bearer $token';

    // Parse user from response body if available
    if (resp.data is Map<String, dynamic> && resp.data['user'] != null) {
      return User.fromJson(resp.data['user'] as Map<String, dynamic>);
    }

    // If user data isn't returned, fetch /auth/me
    final meResp = await authApi.me();
    if (meResp.data is Map<String, dynamic>) {
      return User.fromJson(meResp.data as Map<String, dynamic>);
    }

    throw Exception('User data not found after login.');
  }

  @override
  Future<void> logout() async {
    await secureStorage.deleteAuthToken();
    apiClient.dio.options.headers.remove('Authorization');
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await secureStorage.readAuthToken();
    if (token == null || token.isEmpty) return null;

    try {
      apiClient.dio.options.headers['Authorization'] = 'Bearer $token';
      final resp = await authApi.me();
      if (resp.data is Map<String, dynamic>) {
        return User.fromJson(resp.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
