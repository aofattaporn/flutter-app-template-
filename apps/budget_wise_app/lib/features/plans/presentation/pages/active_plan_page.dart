import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/plan.dart';
import '../../../../domain/entities/plan_item.dart';
import '../bloc/active_plan_bloc.dart';
import '../widgets/no_plan_widget.dart';
import '../widgets/plan_item_card.dart';
import '../widgets/plan_overview_section.dart';
import '../widgets/unassigned_notice.dart';
import 'plan_editor_page.dart';
import 'plan_item_editor_page.dart';

/// Active Plan page displaying the current active plan and its items
class ActivePlanPage extends StatefulWidget {
  const ActivePlanPage({super.key});

  @override
  State<ActivePlanPage> createState() => _ActivePlanPageState();
}

class _ActivePlanPageState extends State<ActivePlanPage> {
  @override
  void initState() {
    super.initState();
    context.read<ActivePlanBloc>().add(const LoadActivePlan());
  }

  void _navigateToCreatePlan() async {
    final state = context.read<ActivePlanBloc>().state;
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => PlanEditorPage(
          currentTotalPlanned: state.totalPlannedExpenses,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null && mounted) {
      context.read<ActivePlanBloc>().add(
            CreatePlanRequested(
              name: result['name'] as String,
              startDate: result['startDate'] as DateTime,
              endDate: result['endDate'] as DateTime,
              expectedIncome: result['expectedIncome'] as double?,
              isActive: result['isActive'] as bool? ?? true,
            ),
          );
    }
  }

  void _navigateToEditPlan(Plan plan) async {
    final state = context.read<ActivePlanBloc>().state;
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => PlanEditorPage(
          existingPlan: plan,
          currentTotalPlanned: state.totalPlannedExpenses,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null && mounted) {
      context.read<ActivePlanBloc>().add(
            UpdatePlanRequested(
              planId: plan.id,
              name: result['name'] as String,
              startDate: result['startDate'] as DateTime,
              endDate: result['endDate'] as DateTime,
              expectedIncome: result['expectedIncome'] as double?,
              isActive: result['isActive'] as bool?,
            ),
          );
    }
  }

  void _navigateToAddItem(Plan plan) async {
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

  void _navigateToEditItem(Plan plan, PlanItem item) async {
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

  void _showItemMenu(Plan plan, PlanItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Item'),
              onTap: () {
                Navigator.pop(context);
                _navigateToEditItem(plan, item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('View Transactions'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to transactions
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red.shade700),
              title: Text(
                'Delete Item',
                style: TextStyle(color: Colors.red.shade700),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteItem(item);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteItem(PlanItem item) {
    final bloc = context.read<ActivePlanBloc>();
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(DeletePlanItemRequested(item.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmClosePlan() {
    final bloc = context.read<ActivePlanBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Close Plan'),
        content: const Text(
          'Are you sure you want to close this plan? You can create or activate another plan afterward.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(const CloseActivePlanRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4D648D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Close Plan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ActivePlanBloc, ActivePlanState>(
          listener: (context, state) {
            // ***
            /// Handle error states globally
            /// ***
            if (state.status == ActivePlanStatus.error &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          },
          builder: (context, state) {
            // ***
            /// Hanler loading state globally
            /// ***
            if (state.status == ActivePlanStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4D648D),
                ),
              );
            }

            // ***
            /// Hanler no active plan state globally
            /// ***
            if (!state.hasActivePlan) {
              return NoPlanWidget(
                onCreatePlan: _navigateToCreatePlan,
                onViewAllPlans: () {
                  // TODO: Navigate to plans list
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ActivePlanBloc>().add(const RefreshActivePlan());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ****
                    // Plan Overview Section
                    // ***
                    PlanOverviewSection(
                      plan: state.plan!,
                      actualIncome: state.actualIncome,
                      totalPlanned: state.totalPlannedExpenses,
                      totalSpent: state.totalActualExpenses,
                      onEditPlan: () => _navigateToEditPlan(state.plan!),
                      onClosePlan: _confirmClosePlan,
                      onViewAllPlans: () {
                        // TODO: Navigate to plans list
                      },
                    ),

                    // ***
                    // Plan Items Section
                    // ***
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Plan Items',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _navigateToAddItem(state.plan!),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Color(0xFF4D648D),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Add Item',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4D648D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Plan Items List
                          if (state.planItems.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No plan items yet',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Add items to track your budget',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.planItems.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = state.planItems[index];
                                return PlanItemCard(
                                  item: item,
                                  onTap: () {
                                    // TODO: Navigate to item detail
                                  },
                                  onMenuTap: () =>
                                      _showItemMenu(state.plan!, item),
                                );
                              },
                            ),

                          // Unassigned Notice
                          const UnassignedNotice(
                            unassignedCount: 3, // TODO: Get from state
                          ),

                          // Bottom padding for FAB
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<ActivePlanBloc, ActivePlanState>(
        builder: (context, state) {
          if (!state.hasActivePlan) return const SizedBox.shrink();

          return FloatingActionButton(
            heroTag: 'activePlanFab',
            onPressed: () => _navigateToAddItem(state.plan!),
            backgroundColor: const Color(0xFF4D648D),
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
