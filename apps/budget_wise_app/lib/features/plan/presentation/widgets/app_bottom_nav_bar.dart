import 'package:flutter/material.dart';
import 'bottom_nav_item.dart';

/// App-wide bottom navigation bar widget
///
/// Contains 5 navigation items: Home, Plans, Transactions, Accounts, More
/// Fixed at the bottom of the screen with clean minimal design
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Primary color for active state (matches design: #4D648D)
  static const Color _activeColor = Color(0xFF4D648D);

  /// Inactive color for non-selected items
  static const Color _inactiveColor = Color(0xFFA3A3A3);

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
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
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
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
