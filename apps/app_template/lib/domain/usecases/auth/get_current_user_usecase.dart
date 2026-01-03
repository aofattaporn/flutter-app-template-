import '../../../core/base/use_case.dart';
import '../../../core/utils/typedefs.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Get current user use case
class GetCurrentUserUseCase implements UseCaseWithoutParams<UserEntity?> {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  ResultFuture<UserEntity?> call() {
    return _repository.getCurrentUser();
  }
}
