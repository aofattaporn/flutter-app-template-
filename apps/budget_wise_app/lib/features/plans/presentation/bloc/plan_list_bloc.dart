import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/plan.dart';
import '../../../../domain/repositories/plan_repository.dart';

part 'plan_list_event.dart';
part 'plan_list_state.dart';

/// BLoC for managing plan list state
class PlanListBloc extends Bloc<PlanListEvent, PlanListState> {
  final PlanRepository _planRepository;

  PlanListBloc({
    required PlanRepository planRepository,
  })  : _planRepository = planRepository,
        super(const PlanListState()) {
    on<LoadAllPlans>(_onLoadAllPlans);
    on<RefreshPlans>(_onRefreshPlans);
    on<DeletePlanRequested>(_onDeletePlan);
    on<SetActivePlanRequested>(_onSetActivePlan);
  }

  Future<void> _onLoadAllPlans(
    LoadAllPlans event,
    Emitter<PlanListState> emit,
  ) async {
    emit(state.copyWith(status: PlanListStatus.loading));

    try {
      final plans = await _planRepository.getAllPlans();

      // Sort: active first, then by start date descending
      plans.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return b.startDate.compareTo(a.startDate);
      });

      emit(state.copyWith(
        status: PlanListStatus.loaded,
        plans: plans,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PlanListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshPlans(
    RefreshPlans event,
    Emitter<PlanListState> emit,
  ) async {
    try {
      final plans = await _planRepository.getAllPlans();

      plans.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return b.startDate.compareTo(a.startDate);
      });

      emit(state.copyWith(
        status: PlanListStatus.loaded,
        plans: plans,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PlanListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeletePlan(
    DeletePlanRequested event,
    Emitter<PlanListState> emit,
  ) async {
    try {
      await _planRepository.deletePlan(event.planId);

      emit(state.copyWith(
        plans: state.plans.where((p) => p.id != event.planId).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PlanListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSetActivePlan(
    SetActivePlanRequested event,
    Emitter<PlanListState> emit,
  ) async {
    try {
      final updatedPlan = await _planRepository.setActivePlan(event.planId);

      // Update all plans - set the selected one as active, others as inactive
      final updatedPlans = state.plans.map((p) {
        if (p.id == event.planId) {
          return updatedPlan;
        }
        return p.copyWith(isActive: false);
      }).toList();

      // Re-sort
      updatedPlans.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return b.startDate.compareTo(a.startDate);
      });

      emit(state.copyWith(plans: updatedPlans));
    } catch (e) {
      emit(state.copyWith(
        status: PlanListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
