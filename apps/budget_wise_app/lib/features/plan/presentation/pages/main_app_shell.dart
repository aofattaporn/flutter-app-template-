import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Main App Shell with Bottom Navigation and FAB
///
/// This is the main scaffold that wraps the entire app's navigation structure.
/// It contains:
/// - Bottom Navigation Bar with 5 tabs
/// - Floating Action Button positioned above the nav bar
/// - Content area that switches based on selected tab
///
/// Easy to extend: add new pages by adding them to [_pages] list
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 1; // Default to Plans tab (index 1)

  /// Placeholder pages for each tab
  /// Replace these with actual page widgets when implementing features
  final List<Widget> _pages = const [
    _PlaceholderPage(title: 'Home', icon: Icons.home),
    _PlaceholderPage(title: 'Plans', icon: Icons.checklist),
    _PlaceholderPage(title: 'Transactions', icon: Icons.receipt_long),
    _PlaceholderPage(title: 'Accounts', icon: Icons.account_balance_wallet),
    _PlaceholderPage(title: 'More', icon: Icons.settings),
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

/// Placeholder page widget for tabs
///
/// Used as temporary content until actual pages are implemented
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
