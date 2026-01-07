part of 'plan_list_bloc.dart';

/// Base class for plan list events
abstract class PlanListEvent extends Equatable {
  const PlanListEvent();

  @override
  List<Object?> get props => [];
}

/// Load all plans
class LoadAllPlans extends PlanListEvent {
  const LoadAllPlans();
}

/// Refresh plans list
class RefreshPlans extends PlanListEvent {
  const RefreshPlans();
}

/// Delete a plan
class DeletePlanRequested extends PlanListEvent {
  final String planId;

  const DeletePlanRequested({required this.planId});

  @override
  List<Object?> get props => [planId];
}

/// Set a plan as active
class SetActivePlanRequested extends PlanListEvent {
  final String planId;

  const SetActivePlanRequested({required this.planId});

  @override
  List<Object?> get props => [planId];
}
