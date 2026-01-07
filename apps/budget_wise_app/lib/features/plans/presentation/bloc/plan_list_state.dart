part of 'plan_list_bloc.dart';

enum PlanListStatus { initial, loading, loaded, error }

/// State for plan list
class PlanListState extends Equatable {
  final PlanListStatus status;
  final List<Plan> plans;
  final String? errorMessage;

  const PlanListState({
    this.status = PlanListStatus.initial,
    this.plans = const [],
    this.errorMessage,
  });

  PlanListState copyWith({
    PlanListStatus? status,
    List<Plan>? plans,
    String? errorMessage,
  }) {
    return PlanListState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plans, errorMessage];
}
