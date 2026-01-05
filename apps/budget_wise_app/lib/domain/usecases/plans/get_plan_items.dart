import '../../entities/plan_item.dart';
import '../../repositories/plan_repository.dart';

/// Use case to get all items for a plan
class GetPlanItems {
  final PlanRepository repository;

  GetPlanItems(this.repository);

  Future<List<PlanItem>> call(String planId) async {
    return await repository.getPlanItems(planId);
  }
}
