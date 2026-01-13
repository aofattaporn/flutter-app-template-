import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../di/injection.dart';
import '../../../../domain/entities/plan.dart';
import '../../../../domain/repositories/plan_repository.dart';
import 'plan_editor_page.dart';

/// Detail page for a single plan (summary view)
/// Supports viewing plan details and editing
class PlanDetailPage extends StatefulWidget {
  final Plan plan;

  const PlanDetailPage({
    super.key,
    required this.plan,
  });

  @override
  State<PlanDetailPage> createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  final PlanRepository _planRepository = getIt<PlanRepository>();

  late Plan _currentPlan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPlan = widget.plan;
  }

  /// Navigate to edit plan and refresh data when returning
  void _navigateToEditPlan() async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => PlanEditorPage(
          existingPlan: _currentPlan,
          currentTotalPlanned: 0,
        ),
        fullscreenDialog: true,
      ),
    );

    // If plan was updated, refresh the data
    if (result == true && mounted) {
      await _refreshPlanData();
    }
  }

  /// Refresh plan data from repository
  Future<void> _refreshPlanData() async {
    setState(() => _isLoading = true);

    try {
      final updatedPlan = await _planRepository.getPlanById(_currentPlan.id);
      if (updatedPlan != null && mounted) {
        setState(() {
          _currentPlan = updatedPlan;
          _isLoading = false;
        });
      } else {
        // Plan was deleted, go back
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

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
          _currentPlan.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditPlan,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4D648D),
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshPlanData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          if (_currentPlan.isActive)
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
                                '${dateFormat.format(_currentPlan.startDate)} - ${dateFormat.format(_currentPlan.endDate)}',
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
                          if (_currentPlan.expectedIncome != null) ...[
                            _SummaryRow(
                              label: 'Expected Income',
                              value: currencyFormat
                                  .format(_currentPlan.expectedIncome),
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
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
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
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
