part of 'active_plan_bloc.dart';

/// Events for ActivePlanBloc
abstract class ActivePlanEvent extends Equatable {
  const ActivePlanEvent();

  @override
  List<Object?> get props => [];
}

/// Load the active plan and its items
class LoadActivePlan extends ActivePlanEvent {
  const LoadActivePlan();
}

/// Refresh the active plan data
class RefreshActivePlan extends ActivePlanEvent {
  const RefreshActivePlan();
}

/// Close the current active plan
class CloseActivePlanRequested extends ActivePlanEvent {
  const CloseActivePlanRequested();
}

/// Add a new plan item
class AddPlanItemRequested extends ActivePlanEvent {
  final String name;
  final double expectedAmount;

  const AddPlanItemRequested({
    required this.name,
    required this.expectedAmount,
  });

  @override
  List<Object?> get props => [name, expectedAmount];
}

/// Delete a plan item
class DeletePlanItemRequested extends ActivePlanEvent {
  final String itemId;

  const DeletePlanItemRequested(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Update a plan item
class UpdatePlanItemRequested extends ActivePlanEvent {
  final String itemId;
  final String? name;
  final double? expectedAmount;

  const UpdatePlanItemRequested({
    required this.itemId,
    this.name,
    this.expectedAmount,
  });

  @override
  List<Object?> get props => [itemId, name, expectedAmount];
}
