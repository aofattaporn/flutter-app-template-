import 'package:flutter/material.dart';

/// Widget displaying the unassigned transactions notice
class UnassignedNotice extends StatelessWidget {
  final int unassignedCount;
  final VoidCallback? onTap;

  const UnassignedNotice({
    super.key,
    this.unassignedCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unassignedCount > 0
                        ? '$unassignedCount transaction(s) not assigned to any plan item'
                        : 'All transactions are assigned to plan items',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if (unassignedCount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Tap to review and assign them',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
