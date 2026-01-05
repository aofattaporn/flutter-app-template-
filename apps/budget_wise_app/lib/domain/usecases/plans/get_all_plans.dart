import '../../entities/plan.dart';
import '../../repositories/plan_repository.dart';

/// Use case to get all plans
class GetAllPlans {
  final PlanRepository repository;

  GetAllPlans(this.repository);

  Future<List<Plan>> call() async {
    return await repository.getAllPlans();
  }
}
