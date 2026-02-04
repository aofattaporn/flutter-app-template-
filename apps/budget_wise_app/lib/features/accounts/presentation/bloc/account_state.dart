part of 'account_bloc.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// Account States
/// ═══════════════════════════════════════════════════════════════════════════

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AccountInitial extends AccountState {
  const AccountInitial();
}

/// Loading state - fetching accounts
class AccountLoading extends AccountState {
  const AccountLoading();
}

/// Success state - accounts loaded
class AccountLoaded extends AccountState {
  final List<Account> accounts;
  final double totalBalance;

  const AccountLoaded({
    required this.accounts,
    required this.totalBalance,
  });

  @override
  List<Object?> get props => [accounts, totalBalance];

  /// Check if accounts list is empty
  bool get isEmpty => accounts.isEmpty;

  /// Get account count
  int get accountCount => accounts.length;
}

/// Error state
class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state after creating account
class AccountCreated extends AccountState {
  final Account account;

  const AccountCreated(this.account);

  @override
  List<Object?> get props => [account];
}

/// Success state after updating account
class AccountUpdated extends AccountState {
  final Account account;

  const AccountUpdated(this.account);

  @override
  List<Object?> get props => [account];
}

/// Success state after deleting account
class AccountDeleted extends AccountState {
  final String accountId;

  const AccountDeleted(this.accountId);

  @override
  List<Object?> get props => [accountId];
}
