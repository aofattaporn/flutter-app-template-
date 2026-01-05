import '../../entities/plan.dart';
import '../../repositories/plan_repository.dart';

/// Use case to create a new plan
class CreatePlan {
  final PlanRepository repository;

  CreatePlan(this.repository);

  Future<Plan> call({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    double? expectedIncome,
    bool isActive = false,
  }) async {
    return await repository.createPlan(
      name: name,
      startDate: startDate,
      endDate: endDate,
      expectedIncome: expectedIncome,
      isActive: isActive,
    );
  }
}
