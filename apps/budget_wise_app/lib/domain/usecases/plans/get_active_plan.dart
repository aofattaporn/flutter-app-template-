import '../../entities/plan.dart';
import '../../repositories/plan_repository.dart';

/// Use case to get the currently active plan
class GetActivePlan {
  final PlanRepository repository;

  GetActivePlan(this.repository);

  Future<Plan?> call() async {
    return await repository.getActivePlan();
  }
}
