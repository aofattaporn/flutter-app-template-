import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checklist,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Active Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a plan to start tracking your budget',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCreatePlan,
                icon: const Icon(Icons.add),
                label: const Text('Create New Plan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D648D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onViewAllPlans,
              child: const Text(
                'View All Plans',
                style: TextStyle(
                  color: Color(0xFF4D648D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
