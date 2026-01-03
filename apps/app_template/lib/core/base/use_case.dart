import '../utils/typedefs.dart';

/// Base use case interface with params
abstract class UseCase<Type, Params> {
  ResultFuture<Type> call(Params params);
}

/// Base use case interface without params
abstract class UseCaseWithoutParams<Type> {
  ResultFuture<Type> call();
}

/// Base use case interface for stream results
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

/// No params class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
