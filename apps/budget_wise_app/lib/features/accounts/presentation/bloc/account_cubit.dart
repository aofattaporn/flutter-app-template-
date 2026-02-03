import 'package:app_template/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepository;

  AccountCubit({
    required AccountRepository accountRepository,
  })  : _accountRepository = accountRepository,
        super(AccountInitial());

  Future<void> fetchAccounts() async {
    emit(AccountLoading());
    try {
      final accounts = await _accountRepository.getAccounts();
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> createAccount(Account account) async {
    emit(AccountLoading());
    try {
      await _accountRepository.createAccount(account);
      await fetchAccounts();
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
