import 'package:equatable/equatable.dart';

import '../../../core/base/use_case.dart';
import '../../../core/utils/typedefs.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Register use case
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  ResultFuture<UserEntity> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// Register parameters
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String? name;

  const RegisterParams({
    required this.email,
    required this.password,
    this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}
