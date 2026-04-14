import 'package:app_template/features/accounts/domain/entities/account.dart';
import 'package:app_template/features/accounts/domain/repositories/account_repository.dart';
import 'package:app_template/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection.dart';
import '../../../../domain/repositories/plan_repository.dart';
import '../widgets/widgets.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/pages/home_overview_page.dart';
import '../../../plans/presentation/bloc/active_plan_bloc.dart';
import '../../../plans/presentation/pages/active_plan_page.dart';
import '../../../transactions/transactions.dart';
import '../../../accounts/accounts.dart';
import '../../../settings/settings.dart';

/// Main App Shell with Bottom Navigation and FAB
///
/// This is the main scaffold that wraps the entire app's navigation structure.
/// It contains:
/// - Bottom Navigation Bar with 5 tabs
/// - Floating Action Button positioned above the nav bar
/// - Content area that switches based on selected tab
///
/// Easy to extend: replace placeholder pages with actual feature pages
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0; // Default to Home tab (index 0)
  late final HomeBloc _homeBloc;
  late final ActivePlanBloc _activePlanBloc;
  late final AccountBloc _accountBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      planRepository: getIt<PlanRepository>(),
      accountRepository: getIt<AccountRepository>(),
      transactionRepository: getIt<TransactionRepository>(),
    );
    _activePlanBloc = ActivePlanBloc(
      planRepository: getIt<PlanRepository>(),
    );
    _accountBloc = AccountBloc(repository: getIt<AccountRepository>());
  }

  @override
  void dispose() {
    _homeBloc.close();
    _activePlanBloc.close();
    _accountBloc.close();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Auto-refresh the target tab's data
    _refreshTab(index);
  }

  void _refreshTab(int index) {
    switch (index) {
      case 0:
        _homeBloc.add(const RefreshHomeData());
        break;
      case 1:
        _activePlanBloc.add(const RefreshActivePlan());
        break;
      case 3:
        _accountBloc.add(const RefreshAccountsRequested());
        break;
    }
  }

  void _refreshAllBlocs() {
    _homeBloc.add(const RefreshHomeData());
    _activePlanBloc.add(const RefreshActivePlan());
    _accountBloc.add(const RefreshAccountsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeBloc),
        BlocProvider.value(value: _activePlanBloc),
        BlocProvider.value(value: _accountBloc),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const HomeOverviewPage(),
            const ActivePlanPage(),
            const TransactionsPlaceholderPage(),
            const AccountScreen(),
            const SettingsPlaceholderPage(),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
