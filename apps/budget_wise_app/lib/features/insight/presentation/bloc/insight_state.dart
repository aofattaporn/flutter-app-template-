part of 'insight_bloc.dart';

enum InsightStatus { initial, loading, loaded, error }

/// Daily aggregation for charts
class DailyAmount extends Equatable {
  final DateTime date;
  final double income;
  final double expense;

  const DailyAmount({
    required this.date,
    required this.income,
    required this.expense,
  });

  double get net => income - expense;

  @override
  List<Object?> get props => [date, income, expense];
}

/// Category insight — maps plan item budget vs actual spending
class CategoryInsight extends Equatable {
  final String name;
  final double budget;
  final double actual;

  const CategoryInsight({
    required this.name,
    required this.budget,
    required this.actual,
  });

  double get overAmount => actual > budget ? actual - budget : 0;
  double get remaining => budget - actual;
  bool get isOverBudget => actual > budget;
  double get percentage => budget > 0 ? (actual / budget).clamp(0.0, double.infinity) : 0;

  @override
  List<Object?> get props => [name, budget, actual];
}

class InsightState extends Equatable {
  final InsightStatus status;
  final List<Plan> allPlans;
  final int selectedPlanIndex;
  final List<Transaction> transactions;
  final Plan? activePlan;
  final List<PlanItem> planItems;
  final String? errorMessage;

  const InsightState({
    required this.status,
    this.allPlans = const [],
    this.selectedPlanIndex = 0,
    required this.transactions,
    this.activePlan,
    this.planItems = const [],
    this.errorMessage,
  });

  factory InsightState.initial() {
    return const InsightState(
      status: InsightStatus.initial,
      transactions: [],
    );
  }

  /// The currently viewed plan (from allPlans at selectedPlanIndex)
  Plan? get selectedPlan =>
      allPlans.isNotEmpty && selectedPlanIndex < allPlans.length
          ? allPlans[selectedPlanIndex]
          : null;

  /// Date range from the selected plan, or current calendar month as fallback
  DateTime get periodStart {
    final plan = selectedPlan;
    if (plan != null) return plan.startDate;
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  DateTime get periodEnd {
    final plan = selectedPlan;
    if (plan != null) return plan.endDate;
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }

  bool get canGoNext => selectedPlanIndex > 0;
  bool get canGoPrevious => selectedPlanIndex < allPlans.length - 1;

  // ── Computed values ────────────────────────────────────────

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get netAmount => totalIncome - totalExpense;

  double get totalBudget =>
      planItems.fold(0.0, (sum, item) => sum + item.expectedAmount);

  /// Plan item ID → name map
  Map<String, String> get _planItemNames {
    final map = <String, String>{};
    for (final item in planItems) {
      map[item.id] = item.name;
    }
    return map;
  }

  /// Resolve planItemId to a display name
  String categoryName(String? planItemId) {
    if (planItemId == null) return 'Uncategorized';
    return _planItemNames[planItemId] ?? 'Unknown';
  }

  /// Daily income & expense for line chart (uses plan date range)
  List<DailyAmount> get dailyAmounts {
    final start = periodStart;
    final end = periodEnd;
    final totalDays = end.difference(start).inDays + 1;
    final map = <DateTime, DailyAmount>{};

    for (int i = 0; i < totalDays; i++) {
      final date = DateTime(start.year, start.month, start.day + i);
      map[date] = DailyAmount(date: date, income: 0, expense: 0);
    }

    for (final txn in transactions) {
      final dateKey = DateTime(
          txn.occurredAt.year, txn.occurredAt.month, txn.occurredAt.day);
      final existing = map[dateKey];
      if (existing == null) continue;
      if (txn.type == TransactionType.income) {
        map[dateKey] = DailyAmount(
          date: existing.date,
          income: existing.income + txn.amount,
          expense: existing.expense,
        );
      } else if (txn.type == TransactionType.expense) {
        map[dateKey] = DailyAmount(
          date: existing.date,
          income: existing.income,
          expense: existing.expense + txn.amount,
        );
      }
    }

    final sorted = map.keys.toList()..sort();
    return sorted.map((d) => map[d]!).toList();
  }

  /// Expense grouped by category name (resolved from planItems)
  List<CategoryInsight> get categoryInsights {
    // Aggregate actual spending per planItemId
    final actualMap = <String?, double>{};
    for (final txn in transactions) {
      if (txn.type != TransactionType.expense) continue;
      actualMap[txn.planItemId] = (actualMap[txn.planItemId] ?? 0) + txn.amount;
    }

    final results = <CategoryInsight>[];

    // For each plan item, build insight with budget + actual
    for (final item in planItems) {
      final actual = actualMap.remove(item.id) ?? 0;
      results.add(CategoryInsight(
        name: item.name,
        budget: item.expectedAmount,
        actual: actual,
      ));
    }

    // Remaining entries are uncategorized or from unknown planItemIds
    double uncategorizedTotal = 0;
    for (final entry in actualMap.entries) {
      uncategorizedTotal += entry.value;
    }
    if (uncategorizedTotal > 0) {
      results.add(CategoryInsight(
        name: 'Uncategorized',
        budget: 0,
        actual: uncategorizedTotal,
      ));
    }

    // Sort by actual spending descending
    results.sort((a, b) => b.actual.compareTo(a.actual));
    return results;
  }

  /// Only categories that are over budget
  List<CategoryInsight> get overspentCategories =>
      categoryInsights.where((c) => c.isOverBudget).toList();

  int get transactionCount => transactions.length;

  InsightState copyWith({
    InsightStatus? status,
    List<Plan>? allPlans,
    int? selectedPlanIndex,
    List<Transaction>? transactions,
    Plan? activePlan,
    bool clearPlan = false,
    List<PlanItem>? planItems,
    String? errorMessage,
  }) {
    return InsightState(
      status: status ?? this.status,
      allPlans: allPlans ?? this.allPlans,
      selectedPlanIndex: selectedPlanIndex ?? this.selectedPlanIndex,
      transactions: transactions ?? this.transactions,
      activePlan: clearPlan ? null : (activePlan ?? this.activePlan),
      planItems: planItems ?? this.planItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, allPlans, selectedPlanIndex, transactions, activePlan, planItems, errorMessage];
}
