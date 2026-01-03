/// Base exception class for the app
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const AppException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'AppException: $message (statusCode: $statusCode)';
}

// ─────────────────────────────────────────────────────────────
// Server Exceptions
// ─────────────────────────────────────────────────────────────

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred',
    super.statusCode,
    super.data,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
    super.data,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Access forbidden',
    super.statusCode = 403,
    super.data,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.data,
  });
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation error',
    this.errors,
    super.statusCode = 422,
    super.data,
  });
}

// ─────────────────────────────────────────────────────────────
// Network Exceptions
// ─────────────────────────────────────────────────────────────

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
    super.data,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Connection timeout',
    super.statusCode,
    super.data,
  });
}

// ─────────────────────────────────────────────────────────────
// Cache Exceptions
// ─────────────────────────────────────────────────────────────

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred',
    super.statusCode,
    super.data,
  });
}
