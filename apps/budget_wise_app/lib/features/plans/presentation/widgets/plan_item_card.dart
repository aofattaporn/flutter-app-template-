import 'package:flutter/material.dart';

import '../../../../core/utils/currency_utils.dart';
import '../../../../domain/entities/plan_item.dart';

/// Widget displaying a single plan item card
class PlanItemCard extends StatelessWidget {
  final PlanItem item;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  const PlanItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onMenuTap,
  });

  Color _getBorderColor() {
    switch (item.status) {
      case PlanItemStatus.overBudget:
        return Colors.grey.shade400;
      case PlanItemStatus.nearLimit:
        return const Color(0xFFB1A296);
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getProgressColor() {
    switch (item.status) {
      case PlanItemStatus.overBudget:
        return Colors.grey.shade700;
      case PlanItemStatus.nearLimit:
        return const Color(0xFFB1A296);
      default:
        return const Color(0xFF4D648D);
    }
  }

  Widget _buildStatusIndicator() {
    switch (item.status) {
      case PlanItemStatus.overBudget:
        return Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 14,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              'Over planned amount',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        );
      case PlanItemStatus.nearLimit:
        return Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              size: 14,
              color: Color(0xFFB1A296),
            ),
            const SizedBox(width: 4),
            Text(
              'Near limit',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFB1A296),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = item.remainingAmount;
    final hasStatusIndicator =
        item.status == PlanItemStatus.overBudget ||
        item.status == PlanItemStatus.nearLimit;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _getBorderColor()),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getCategoryIcon(item.name),
                              size: 18,
                              color: const Color(0xFF4D648D),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expense',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onMenuTap,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Amount Details
            Column(
              children: [
                _buildAmountRow('Planned', item.expectedAmount),
                const SizedBox(height: 8),
                _buildAmountRow('Actual', item.actualAmount),
                const SizedBox(height: 8),
                _buildAmountRow(
                  item.isOverBudget ? 'Over' : 'Remaining',
                  item.isOverBudget ? item.overAmount : remaining,
                  isRemaining: true,
                  isOver: item.isOverBudget,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: item.progressPercentage,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
                minHeight: 8,
              ),
            ),

            // Status Indicator
            if (hasStatusIndicator) ...[
              const SizedBox(height: 8),
              _buildStatusIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount, {
    bool isRemaining = false,
    bool isOver = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          CurrencyUtils.formatCurrency(amount),
          style: TextStyle(
            fontSize: 12,
            color: isOver ? Colors.red.shade700 : Colors.black87,
            fontWeight: isRemaining ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('food') || lowerName.contains('grocery')) {
      return Icons.restaurant;
    } else if (lowerName.contains('transport')) {
      return Icons.directions_car;
    } else if (lowerName.contains('entertainment')) {
      return Icons.movie;
    } else if (lowerName.contains('health')) {
      return Icons.local_hospital;
    } else if (lowerName.contains('shopping')) {
      return Icons.shopping_bag;
    } else if (lowerName.contains('salary') || lowerName.contains('income')) {
      return Icons.attach_money;
    }
    return Icons.category;
  }
}
