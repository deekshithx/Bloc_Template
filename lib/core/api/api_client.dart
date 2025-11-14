// lib/core/api/api_client.dart
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';
import 'interceptors.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._internal(this._dio);

  factory ApiClient({
    required String baseUrl,
    required SecureStorage securedStorage,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        // 👇 Important: prevent Dio from throwing automatically on 400/401/etc.
        // So _handleRequest() can handle it instead.
        validateStatus: (status) => true,
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(AuthInterceptor(secureStorage: securedStorage));

    return ApiClient._internal(dio);
  }

  Dio get dio => _dio;

  // --- Centralized error handler ---
  Future<Response<T>> _handleRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      final response = await request();
      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        return response;
      }

      switch (statusCode) {
        case 400:
          throw Exception('Bad request');
        case 401:
          throw UnauthorizedException();
        case 403:
          throw Exception('Access denied');
        case 404:
          throw Exception('Not found');
        case 500:
          throw Exception('Server error');
        default:
          throw Exception('Unexpected error [HTTP $statusCode]');
      }
    } on DioException catch (e) {
      Logger.error('API Error', error: e, stackTrace: e.stackTrace);
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      }
      throw Exception('Network error: ${e.message}');
    } catch (e, st) {
      Logger.error('Unhandled API error', error: e, stackTrace: st);
      rethrow;
    }
  }

  // --- Public methods, all using _handleRequest() ---
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _handleRequest(
      () =>
          _dio.get<T>(path, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _handleRequest(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _handleRequest(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _handleRequest(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }
}

class UnauthorizedException implements Exception {
  @override
  String toString() => 'Unauthorized';
}
