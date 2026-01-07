import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../di/injection.dart';
import '../../../../domain/entities/plan.dart';
import '../bloc/plan_list_bloc.dart';
import 'plan_editor_page.dart';

/// Page to display list of all plans
class PlanListPage extends StatelessWidget {
  const PlanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlanListBloc(
        planRepository: getIt(),
      )..add(const LoadAllPlans()),
      child: const _PlanListView(),
    );
  }
}

class _PlanListView extends StatelessWidget {
  const _PlanListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D648D),
        foregroundColor: Colors.white,
        title: const Text(
          'All Plans',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<PlanListBloc, PlanListState>(
        builder: (context, state) {
          if (state.status == PlanListStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4D648D),
              ),
            );
          }

          if (state.status == PlanListStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load plans',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.read<PlanListBloc>().add(const LoadAllPlans());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.plans.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<PlanListBloc>().add(const RefreshPlans());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.plans.length,
              itemBuilder: (context, index) {
                final plan = state.plans[index];
                return _PlanCard(
                  plan: plan,
                  onTap: () => _viewPlanDetails(context, plan),
                  onSetActive: plan.isActive
                      ? null
                      : () => _confirmSetActive(context, plan),
                  onDelete: () => _confirmDelete(context, plan),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'planListFab',
        backgroundColor: const Color(0xFF4D648D),
        onPressed: () => _navigateToCreatePlan(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4D648D).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 64,
              color: Color(0xFF4D648D),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Plans Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first budget plan\nto start tracking expenses',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToCreatePlan(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4D648D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCreatePlan(BuildContext context) {
    final bloc = context.read<PlanListBloc>();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => const PlanEditorPage(
          currentTotalPlanned: 0,
        ),
      ),
    )
        .then((result) {
      if (result == true) {
        bloc.add(const RefreshPlans());
      }
    });
  }

  void _viewPlanDetails(BuildContext context, Plan plan) {
    final bloc = context.read<PlanListBloc>();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => PlanDetailPage(plan: plan),
      ),
    )
        .then((_) {
      bloc.add(const RefreshPlans());
    });
  }

  void _confirmSetActive(BuildContext context, Plan plan) {
    final bloc = context.read<PlanListBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Set as Active'),
        content: Text(
          'Set "${plan.name}" as your active plan?\n\nThis will deactivate the current active plan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(SetActivePlanRequested(planId: plan.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4D648D),
              foregroundColor: Colors.white,
            ),
            child: const Text('Set Active'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Plan plan) {
    final bloc = context.read<PlanListBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Plan'),
        content: Text(
          'Are you sure you want to delete "${plan.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(DeletePlanRequested(planId: plan.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Card widget to display a single plan
class _PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onTap;
  final VoidCallback? onSetActive;
  final VoidCallback onDelete;

  const _PlanCard({
    required this.plan,
    required this.onTap,
    required this.onSetActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    final isExpired = plan.endDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildStatusBadge(isExpired),
                  ],
                ),
                const SizedBox(height: 12),

                // Date range
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${dateFormat.format(plan.startDate)} - ${dateFormat.format(plan.endDate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Budget info
                if (plan.expectedIncome != null)
                  Row(
                    children: [
                      _InfoChip(
                        label: 'Expected Income',
                        value: currencyFormat.format(plan.expectedIncome),
                        color: const Color(0xFF4D648D),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onSetActive != null)
                      TextButton.icon(
                        onPressed: onSetActive,
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('Set Active'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF4D648D),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red[400],
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Delete plan',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isExpired) {
    if (plan.isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 14, color: Colors.green[700]),
            const SizedBox(width: 4),
            Text(
              'Active',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      );
    }

    if (isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              'Expired',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 14, color: Colors.blue[700]),
          const SizedBox(width: 4),
          Text(
            'Upcoming',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small info chip for displaying budget values
class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail page for a single plan (summary view)
class PlanDetailPage extends StatelessWidget {
  final Plan plan;

  const PlanDetailPage({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D648D),
        foregroundColor: Colors.white,
        title: Text(
          plan.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlanEditorPage(
                    existingPlan: plan,
                    currentTotalPlanned: 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Status Badge
                  if (plan.isActive)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              size: 18, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Active Plan',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Date Range
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Color(0xFF4D648D),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${dateFormat.format(plan.startDate)} - ${dateFormat.format(plan.endDate)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Budget Summary
                  if (plan.expectedIncome != null) ...[
                    _SummaryRow(
                      label: 'Expected Income',
                      value: currencyFormat.format(plan.expectedIncome),
                      valueColor: const Color(0xFF4D648D),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Info message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Set this plan as active to view and manage budget items.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
