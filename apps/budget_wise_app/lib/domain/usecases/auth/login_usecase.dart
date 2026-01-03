import 'package:equatable/equatable.dart';

import '../../../core/base/use_case.dart';
import '../../../core/utils/typedefs.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Login use case
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  ResultFuture<UserEntity> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Login parameters
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
