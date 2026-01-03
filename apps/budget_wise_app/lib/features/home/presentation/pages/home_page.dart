import 'package:flutter/material.dart';
import 'package:budgetwise_design_system/budgetwise_design_system.dart';

/// Home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Template'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            DSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to App Template! 👋',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const DSGap.sm(),
                  Text(
                    'Your clean architecture Flutter starter template.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            const DSGap.lg(),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const DSGap.sm(),

            Row(
              children: [
                Expanded(
                  child: DSButton(
                    label: 'Primary Action',
                    icon: Icons.add,
                    onPressed: () {
                      showDSSnackbar(context, message: 'Primary action tapped!');
                    },
                  ),
                ),
                const DSGap.sm(),
                Expanded(
                  child: DSButton(
                    label: 'Secondary',
                    variant: DSButtonVariant.outlined,
                    icon: Icons.star,
                    onPressed: () {
                      showDSSnackbar(context, message: 'Secondary action tapped!');
                    },
                  ),
                ),
              ],
            ),

            const DSGap.xl(),

            // Sample List
            Text(
              'Recent Items',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const DSGap.sm(),

            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const DSGap.sm(),
                itemBuilder: (context, index) {
                  return DSCard(
                    onTap: () {
                      showDSSnackbar(context, message: 'Item ${index + 1} tapped!', variant: DSSnackbarVariant.success);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const DSGap.md(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sample Item ${index + 1}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'Description of item ${index + 1}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDSSnackbar(context, message: 'FAB pressed!', variant: DSSnackbarVariant.success);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }
}
