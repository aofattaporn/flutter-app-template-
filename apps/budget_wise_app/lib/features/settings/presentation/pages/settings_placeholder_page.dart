import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';

/// Settings page with dark mode toggle
class SettingsPlaceholderPage extends ConsumerWidget {
  const SettingsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Settings', style: AppStyles.displayMedium),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(AppDimens.cardPadding),
              decoration: AppStyles.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance', style: AppStyles.label),
                  const SizedBox(height: 12),
                  _buildThemeOption(
                    context,
                    ref,
                    icon: Icons.phone_android,
                    label: 'System',
                    isSelected: themeMode == ThemeMode.system,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.system),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildThemeOption(
                    context,
                    ref,
                    icon: Icons.light_mode_outlined,
                    label: 'Light',
                    isSelected: themeMode == ThemeMode.light,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.light),
                  ),
                  const Divider(height: 1, color: AppColors.divider),
                  _buildThemeOption(
                    context,
                    ref,
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark',
                    isSelected: themeMode == ThemeMode.dark,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppStyles.bodyMedium)),
            if (isSelected)
              const Icon(Icons.check, size: 20, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
