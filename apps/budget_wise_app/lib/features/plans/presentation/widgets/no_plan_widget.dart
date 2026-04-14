import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Widget for empty state when no active plan exists
class NoPlanWidget extends StatelessWidget {
  final VoidCallback? onCreatePlan;
  final VoidCallback? onViewAllPlans;

  const NoPlanWidget({
    super.key,
    this.onCreatePlan,
    this.onViewAllPlans,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.checklist, size: 28, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 24),
            Text('No Active Plan', style: AppStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Create a plan to start tracking your budget',
              style: AppStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCreatePlan,
                style: AppStyles.primaryButton,
                child: const Text('Create New Plan'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onViewAllPlans,
              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              child: const Text('View All Plans'),
            ),
          ],
        ),
      ),
    );
  }
}
