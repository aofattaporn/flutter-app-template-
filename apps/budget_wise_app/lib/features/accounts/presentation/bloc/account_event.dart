part of 'account_bloc.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// Account Events
/// ═══════════════════════════════════════════════════════════════════════════

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all accounts
class FetchAccountsRequested extends AccountEvent {
  const FetchAccountsRequested();
}

/// Event to create a new account
class CreateAccountRequested extends AccountEvent {
  final Account account;

  const CreateAccountRequested(this.account);

  @override
  List<Object?> get props => [account];
}

/// Event to update an existing account
class UpdateAccountRequested extends AccountEvent {
  final Account account;

  const UpdateAccountRequested(this.account);

  @override
  List<Object?> get props => [account];
}

/// Event to delete an account
class DeleteAccountRequested extends AccountEvent {
  final String accountId;

  const DeleteAccountRequested(this.accountId);

  @override
  List<Object?> get props => [accountId];
}

/// Event to refresh accounts list
class RefreshAccountsRequested extends AccountEvent {
  const RefreshAccountsRequested();
}
