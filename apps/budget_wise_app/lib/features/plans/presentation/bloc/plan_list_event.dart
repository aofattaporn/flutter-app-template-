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

/// Create a new plan
class CreatePlanFromListRequested extends PlanListEvent {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double? expectedIncome;
  final bool isActive;

  const CreatePlanFromListRequested({
    required this.name,
    required this.startDate,
    required this.endDate,
    this.expectedIncome,
    this.isActive = true,
  });

  @override
  List<Object?> get props =>
      [name, startDate, endDate, expectedIncome, isActive];
}
