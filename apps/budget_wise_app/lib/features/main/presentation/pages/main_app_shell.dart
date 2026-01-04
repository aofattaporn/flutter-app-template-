import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import '../../../home/presentation/pages/home_placeholder_page.dart';
import '../../../plans/plans.dart';
import '../../../transactions/transactions.dart';
import '../../../accounts/accounts.dart';
import '../../../settings/settings.dart';

/// Main App Shell with Bottom Navigation and FAB
///
/// This is the main scaffold that wraps the entire app's navigation structure.
/// It contains:
/// - Bottom Navigation Bar with 5 tabs
/// - Floating Action Button positioned above the nav bar
/// - Content area that switches based on selected tab
///
/// Easy to extend: replace placeholder pages with actual feature pages
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 1; // Default to Plans tab (index 1)

  /// Pages for each tab
  /// Replace placeholder pages with actual feature pages when implementing
  final List<Widget> _pages = const [
    HomePlaceholderPage(),
    PlansPlaceholderPage(),
    TransactionsPlaceholderPage(),
    AccountsPlaceholderPage(),
    SettingsPlaceholderPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onFabPressed() {
    // TODO: Implement FAB action (e.g., add new transaction, plan item, etc.)
    debugPrint('FAB pressed - implement action');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: _onFabPressed,
        tooltip: 'Add new item',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
