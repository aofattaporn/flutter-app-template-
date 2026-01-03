import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Type alias for Either with Failure on the left
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Type alias for Either with Failure on the left (sync)
typedef Result<T> = Either<Failure, T>;

/// Type alias for void result
typedef ResultVoid = ResultFuture<void>;

/// Type alias for JSON map
typedef JsonMap = Map<String, dynamic>;

/// Type alias for JSON list
typedef JsonList = List<Map<String, dynamic>>;
