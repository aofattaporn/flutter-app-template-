import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/plan.dart';
import '../../../../domain/entities/plan_item.dart';
import '../../../../domain/repositories/plan_repository.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/repositories/account_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PlanRepository _planRepository;
  final AccountRepository _accountRepository;

  HomeBloc({
    required PlanRepository planRepository,
    required AccountRepository accountRepository,
  })  : _planRepository = planRepository,
        _accountRepository = accountRepository,
        super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await _loadData(emit);
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<HomeState> emit) async {
    try {
      final activePlan = await _planRepository.getActivePlan();
      List<PlanItem> planItems = [];
      double actualIncome = 0;

      if (activePlan != null) {
        planItems = await _planRepository.getPlanItems(activePlan.id);
        actualIncome = await _planRepository.getActualIncome(activePlan.id);
      }

      final accounts = await _accountRepository.getAccounts();

      emit(state.copyWith(
        status: HomeStatus.loaded,
        activePlan: activePlan,
        planItems: planItems,
        actualIncome: actualIncome,
        accounts: accounts,
        clearPlan: activePlan == null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
