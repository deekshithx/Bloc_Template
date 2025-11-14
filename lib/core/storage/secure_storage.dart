// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _authTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeAuthToken(String token) =>
      _storage.write(key: _authTokenKey, value: token);
  Future<String?> readAuthToken() => _storage.read(key: _authTokenKey);
  Future<void> deleteAuthToken() => _storage.delete(key: _authTokenKey);

  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);
  Future<void> deleteRefreshToken() => _storage.delete(key: _refreshTokenKey);
}
