import '../../entities/plan.dart';
import '../../repositories/plan_repository.dart';

/// Use case to close/deactivate a plan
class ClosePlan {
  final PlanRepository repository;

  ClosePlan(this.repository);

  Future<Plan> call(String planId) async {
    return await repository.closePlan(planId);
  }
}
