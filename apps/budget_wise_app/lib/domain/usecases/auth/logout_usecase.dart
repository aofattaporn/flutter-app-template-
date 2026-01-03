import '../../../core/base/use_case.dart';
import '../../../core/utils/typedefs.dart';
import '../../repositories/auth_repository.dart';

/// Logout use case
class LogoutUseCase implements UseCaseWithoutParams<void> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  ResultVoid call() {
    return _repository.logout();
  }
}
