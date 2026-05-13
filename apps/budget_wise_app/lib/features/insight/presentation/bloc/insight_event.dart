part of 'insight_bloc.dart';

abstract class InsightEvent extends Equatable {
  const InsightEvent();

  @override
  List<Object?> get props => [];
}

class LoadInsightData extends InsightEvent {
  const LoadInsightData();
}

class RefreshInsightData extends InsightEvent {
  const RefreshInsightData();
}

/// Navigate to a specific plan by index in the allPlans list
class ChangeInsightPlan extends InsightEvent {
  final int planIndex;
  const ChangeInsightPlan(this.planIndex);

  @override
  List<Object?> get props => [planIndex];
}
