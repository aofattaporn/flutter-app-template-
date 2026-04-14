part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final Plan? activePlan;
  final List<PlanItem> planItems;
  final double actualIncome;
  final List<Account> accounts;
  final List<Transaction> recentTransactions;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.activePlan,
    this.planItems = const [],
    this.actualIncome = 0,
    this.accounts = const [],
    this.recentTransactions = const [],
    this.errorMessage,
  });

  bool get hasActivePlan => activePlan != null;

  double get totalBalance =>
      accounts.fold(0, (sum, account) => sum + account.balance);

  int get accountCount => accounts.length;

  double get totalPlannedExpenses =>
      planItems.fold(0, (sum, item) => sum + item.expectedAmount);

  double get totalActualExpenses =>
      planItems.fold(0, (sum, item) => sum + item.actualAmount);

  double get remainingBudget =>
      (activePlan?.expectedIncome ?? 0) - totalActualExpenses;

  HomeState copyWith({
    HomeStatus? status,
    Plan? activePlan,
    List<PlanItem>? planItems,
    double? actualIncome,
    List<Account>? accounts,
    List<Transaction>? recentTransactions,
    String? errorMessage,
    bool clearPlan = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      activePlan: clearPlan ? null : (activePlan ?? this.activePlan),
      planItems: planItems ?? this.planItems,
      actualIncome: actualIncome ?? this.actualIncome,
      accounts: accounts ?? this.accounts,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activePlan,
        planItems,
        actualIncome,
        accounts,
        recentTransactions,
        errorMessage,
      ];
}
