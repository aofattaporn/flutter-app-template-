import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../utils/logger.dart';

/// Abstract API client interface
/// Allows switching between different implementations (REST, Supabase, etc.)
abstract class ApiClient {
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  void setAuthToken(String token);
  void clearAuthToken();
}

/// Dio-based REST API client implementation
class DioApiClient implements ApiClient {
  late final Dio _dio;
  final AppLogger _logger = AppLogger();

  DioApiClient({
    String? baseUrl,
    Dio? dio,
  }) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl ?? ApiConstants.baseUrl,
            connectTimeout: AppConstants.connectionTimeout,
            receiveTimeout: AppConstants.receiveTimeout,
            headers: {
              ApiConstants.contentType: ApiConstants.applicationJson,
              ApiConstants.accept: ApiConstants.applicationJson,
            },
          ),
        );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Logging Interceptor
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.debug(
            'REQUEST[${options.method}] => PATH: ${options.path}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.debug(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.error(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
            error: error,
          );
          return handler.next(error);
        },
      ),
    ]);
  }

  @override
  void setAuthToken(String token) {
    _dio.options.headers[ApiConstants.authorization] = 'Bearer $token';
  }

  @override
  void clearAuthToken() {
    _dio.options.headers.remove(ApiConstants.authorization);
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: e.message ?? 'Connection timeout');

      case DioExceptionType.connectionError:
        return NetworkException(message: e.message ?? 'Connection error');

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);

      default:
        return ServerException(
          message: e.message ?? 'Unknown error occurred',
          statusCode: e.response?.statusCode,
        );
    }
  }

  AppException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    final message = data is Map ? data['message'] as String? : null;

    switch (statusCode) {
      case 400:
        return ServerException(
          message: message ?? 'Bad request',
          statusCode: statusCode,
        );
      case 401:
        return UnauthorizedException(
          message: message ?? 'Unauthorized',
        );
      case 403:
        return ForbiddenException(
          message: message ?? 'Forbidden',
        );
      case 404:
        return NotFoundException(
          message: message ?? 'Not found',
        );
      case 422:
        final errors = data is Map ? data['errors'] as Map<String, dynamic>? : null;
        return ValidationException(
          message: message ?? 'Validation error',
          errors: errors?.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ),
        );
      case 500:
      default:
        return ServerException(
          message: message ?? 'Server error',
          statusCode: statusCode,
        );
    }
  }
}
