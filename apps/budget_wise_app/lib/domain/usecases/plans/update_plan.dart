import '../../entities/plan.dart';
import '../../repositories/plan_repository.dart';

/// Use case to update an existing plan
class UpdatePlan {
  final PlanRepository repository;

  UpdatePlan(this.repository);

  Future<Plan> call(Plan plan) async {
    return await repository.updatePlan(plan);
  }
}
