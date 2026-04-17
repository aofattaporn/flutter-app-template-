import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../domain/entities/plan_item.dart';
import '../pages/plan_item_editor_page.dart';

/// Widget displaying a single plan item card — minimal flat style
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

  Color _getProgressColor() {
    switch (item.status) {
      case PlanItemStatus.overBudget:
        return AppColors.expense;
      case PlanItemStatus.nearLimit:
        return const Color(0xFFD97706); // amber
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = item.remainingAmount;
    final hasStatus = item.status == PlanItemStatus.overBudget ||
        item.status == PlanItemStatus.nearLimit;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppStyles.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                AppStyles.iconBox(
                  icon: PlanItemIcon.getIcon(item.iconIndex),
                  size: 36,
                  iconSize: 18,
                  radius: 8,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppStyles.bodyLarge, overflow: TextOverflow.ellipsis),
                      Text('Expense', style: AppStyles.caption),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onMenuTap,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.chevron_right, size: 20, color: AppColors.textTertiary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Amounts
            _buildAmountRow('Planned', item.expectedAmount),
            const SizedBox(height: 6),
            _buildAmountRow('Actual', item.actualAmount),
            const SizedBox(height: 6),
            _buildAmountRow(
              item.isOverBudget ? 'Over' : 'Remaining',
              item.isOverBudget ? item.overAmount : remaining,
              isHighlight: true,
              isOver: item.isOverBudget,
            ),
            const SizedBox(height: 12),

            // Progress (remaining — 100% when unused, decreases as spent)
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: 1.0 - item.progressPercentage,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
                minHeight: 4,
              ),
            ),

            if (hasStatus) ...[
              const SizedBox(height: 8),
              _buildStatusIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, {bool isHighlight = false, bool isOver = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.caption),
        Text(
          CurrencyUtils.formatCurrency(amount),
          style: TextStyle(
            fontSize: 12,
            color: isOver ? AppColors.expense : AppColors.textPrimary,
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    final isOver = item.status == PlanItemStatus.overBudget;
    final color = isOver ? AppColors.expense : const Color(0xFFD97706);
    return Row(
      children: [
        Icon(isOver ? Icons.error_outline : Icons.warning_amber_outlined, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          isOver ? 'Over planned amount' : 'Near limit',
          style: TextStyle(fontSize: 11, color: color),
        ),
      ],
    );
  }

}
