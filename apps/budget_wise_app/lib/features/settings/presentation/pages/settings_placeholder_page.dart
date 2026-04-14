import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Settings/More placeholder page
/// 
/// Temporary UI until actual settings feature is implemented
class SettingsPlaceholderPage extends StatelessWidget {
  const SettingsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text('Settings', style: AppStyles.displayMedium),
            const SizedBox(height: 8),
            Text('Coming soon...', style: AppStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
