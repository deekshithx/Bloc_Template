import 'package:bloc_template/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import '../utils/logger.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage secureStorage;

  AuthInterceptor({required this.secureStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await secureStorage.readAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e, st) {
      Logger.error('AuthInterceptor onRequest error', error: e, stackTrace: st);
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Example: if 401, you might trigger token refresh flow here
    // Do not implement refresh logic here unless you have repository available.
    return handler.next(err);
  }
}
