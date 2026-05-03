import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'bottom_nav_item.dart';

/// App-wide bottom navigation bar widget
///
/// Contains 5 navigation items: Home, Plans, Transactions, Accounts, More
/// Fixed at the bottom of the screen with clean minimal design
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Navigation items configuration
  static const List<BottomNavItemData> _navItems = [
    BottomNavItemData(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    BottomNavItemData(
      icon: Icons.checklist_outlined,
      activeIcon: Icons.checklist,
      label: 'Plans',
    ),
    BottomNavItemData(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'Transactions',
    ),
    BottomNavItemData(
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      label: 'Accounts',
    ),
    BottomNavItemData(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        border: Border(
          top: BorderSide(
            color: context.colors.divider,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => BottomNavItem(
                data: _navItems[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
                activeColor: context.colors.primary,
                inactiveColor: context.colors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
