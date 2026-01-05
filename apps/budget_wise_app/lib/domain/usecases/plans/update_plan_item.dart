import '../../entities/plan_item.dart';
import '../../repositories/plan_repository.dart';

/// Use case to update a plan item
class UpdatePlanItem {
  final PlanRepository repository;

  UpdatePlanItem(this.repository);

  Future<PlanItem> call(PlanItem item) async {
    return await repository.updatePlanItem(item);
  }
}
