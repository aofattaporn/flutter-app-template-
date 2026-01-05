import '../../repositories/plan_repository.dart';

/// Use case to delete a plan item
class DeletePlanItem {
  final PlanRepository repository;

  DeletePlanItem(this.repository);

  Future<void> call(String itemId) async {
    return await repository.deletePlanItem(itemId);
  }
}
