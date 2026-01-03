import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
/// Uses Either pattern from dartz for error handling
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

// ─────────────────────────────────────────────────────────────
// Server Failures
// ─────────────────────────────────────────────────────────────

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.message = 'Access forbidden',
    super.statusCode = 403,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.statusCode = 404,
  });
}

// ─────────────────────────────────────────────────────────────
// Network Failures
// ─────────────────────────────────────────────────────────────

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Connection timeout',
  });
}

// ─────────────────────────────────────────────────────────────
// Cache Failures
// ─────────────────────────────────────────────────────────────

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
  });
}

// ─────────────────────────────────────────────────────────────
// Validation Failures
// ─────────────────────────────────────────────────────────────

class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    super.message = 'Validation error',
    this.errors,
    super.statusCode = 422,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

// ─────────────────────────────────────────────────────────────
// Unknown Failure
// ─────────────────────────────────────────────────────────────

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unknown error occurred',
  });
}
