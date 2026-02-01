import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/plan.dart';
import '../../../../domain/entities/plan_item.dart';
import '../bloc/active_plan_bloc.dart';
import '../widgets/no_plan_widget.dart';
import '../widgets/plan_item_card.dart';
import '../widgets/plan_overview_section.dart';
import 'plan_editor_page.dart';
import 'plan_item_editor_page.dart';
import 'plan_list_page.dart';

/// Active Plan Page - Main screen for viewing and managing the active budget plan
///
/// This page displays:
/// - Plan overview with income/expense summary
/// - List of plan items with their budgets
/// - Options to add/edit/delete items
class ActivePlanPage extends StatefulWidget {
  const ActivePlanPage({super.key});

  @override
  State<ActivePlanPage> createState() => _ActivePlanPageState();
}

class _ActivePlanPageState extends State<ActivePlanPage> {
  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    _loadActivePlan();
  }

  void _loadActivePlan() {
    context.read<ActivePlanBloc>().add(const LoadActivePlan());
  }

  void _refreshActivePlan() {
    context.read<ActivePlanBloc>().add(const RefreshActivePlan());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _navigateToCreatePlan() async {
    final state = context.read<ActivePlanBloc>().state;
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (context) => PlanEditorPage(
          currentTotalPlanned: state.totalPlannedExpenses,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == true && mounted) {
      _refreshActivePlan();
    }
  }

  Future<void> _navigateToEditPlan(Plan plan) async {
    final state = context.read<ActivePlanBloc>().state;
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (context) => PlanEditorPage(
          existingPlan: plan,
          currentTotalPlanned: state.totalPlannedExpenses,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == true && mounted) {
      _refreshActivePlan();
    }
  }

  void _navigateToAllPlans() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PlanListPage()))
        .then((_) {
      if (mounted) {
        _refreshActivePlan();
      }
    });
  }

  Future<void> _navigateToAddItem(Plan plan) async {
    final state = context.read<ActivePlanBloc>().state;
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => PlanItemEditorPage(
          plan: plan,
          currentTotalPlanned: state.totalPlannedExpenses,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null && mounted) {
      context.read<ActivePlanBloc>().add(
            AddPlanItemRequested(
              name: result['name'] as String,
              expectedAmount: result['amount'] as double,
            ),
          );
    }
  }

  Future<void> _navigateToEditItem(Plan plan, PlanItem item) async {
    final state = context.read<ActivePlanBloc>().state;
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => PlanItemEditorPage(
          plan: plan,
          existingItem: item,
          currentTotalPlanned: state.totalPlannedExpenses,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null && mounted) {
      context.read<ActivePlanBloc>().add(
            UpdatePlanItemRequested(
              itemId: item.id,
              name: result['name'] as String,
              expectedAmount: result['amount'] as double,
            ),
          );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOG METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  void _showItemMenu(Plan plan, PlanItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) =>
          _buildItemMenuContent(sheetContext, plan, item),
    );
  }

  Widget _buildItemMenuContent(
      BuildContext sheetContext, Plan plan, PlanItem item) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Item'),
            onTap: () {
              Navigator.pop(sheetContext);
              _navigateToEditItem(plan, item);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red.shade700),
            title: Text('Delete Item',
                style: TextStyle(color: Colors.red.shade700)),
            onTap: () {
              Navigator.pop(sheetContext);
              _confirmDeleteItem(item);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  void _confirmDeleteItem(PlanItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<ActivePlanBloc>()
                  .add(DeletePlanItemRequested(item.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmClosePlan() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Close Plan'),
        content: const Text(
          'Are you sure you want to close this plan? '
          'This will make it inactive and you can create a new plan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<ActivePlanBloc>()
                  .add(const CloseActivePlanRequested());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Close Plan'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - MAIN
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ActivePlanBloc, ActivePlanState>(
          listener: _handleStateChanges,
          builder: _buildBody,
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ActivePlanState state) {
    if (state.status == ActivePlanStatus.error && state.errorMessage != null) {
      _showErrorSnackBar(state.errorMessage!);
    }
  }

  Widget _buildBody(BuildContext context, ActivePlanState state) {
    if (state.status == ActivePlanStatus.loading) {
      return _buildLoadingState();
    }

    if (!state.hasActivePlan) {
      return _buildNoPlanState();
    }

    return _buildActivePlanContent(state);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - STATES
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF4D648D)),
    );
  }

  Widget _buildNoPlanState() {
    return NoPlanWidget(
      onCreatePlan: _navigateToCreatePlan,
      onViewAllPlans: _navigateToAllPlans,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - ACTIVE PLAN CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildActivePlanContent(ActivePlanState state) {
    return RefreshIndicator(
      onRefresh: () async => _refreshActivePlan(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlanOverview(state),
            _buildPlanItemsSection(state),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOverview(ActivePlanState state) {
    return PlanOverviewSection(
      plan: state.plan!,
      actualIncome: state.actualIncome,
      totalPlanned: state.totalPlannedExpenses,
      totalSpent: state.totalActualExpenses,
      onEditPlan: () => _navigateToEditPlan(state.plan!),
      onClosePlan: _confirmClosePlan,
      onViewAllPlans: _navigateToAllPlans,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - PLAN ITEMS SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPlanItemsSection(ActivePlanState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 16),
          _buildPlanItemsList(state),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Budget Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            final state = context.read<ActivePlanBloc>().state;
            if (state.plan != null) {
              _navigateToAddItem(state.plan!);
            }
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Item'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF4D648D)),
        ),
      ],
    );
  }

  Widget _buildPlanItemsList(ActivePlanState state) {
    final items = state.planItems;

    if (items.isEmpty) {
      return _buildEmptyItemsState();
    }

    return Column(
      children: items.map((item) => _buildPlanItemCard(state, item)).toList(),
    );
  }

  Widget _buildEmptyItemsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No budget items yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add items to organize your budget',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanItemCard(ActivePlanState state, PlanItem item) {
    final plan = state.plan!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PlanItemCard(
        item: item,
        onTap: () => _showItemMenu(plan, item),
        onMenuTap: () => _showItemMenu(plan, item),
      ),
    );
  }
}
