import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remote;

  AccountRepositoryImpl(this.remote);

  @override
  Future<List<Account>> getAccounts() async {
    final models = await remote.fetchAccounts();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Account> createAccount(Account account) async {
    final model = AccountModel.fromEntity(account);
    final created = await remote.createAccount(model);
    return created.toEntity();
  }
}
