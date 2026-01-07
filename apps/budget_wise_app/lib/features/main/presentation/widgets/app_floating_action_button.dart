import 'package:flutter/material.dart';

/// App Floating Action Button widget
///
/// A customizable FAB that can be positioned above the bottom navigation bar
/// Follows the app's design system with primary color (#4D648D)
class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  /// Primary color for FAB (matches design: #4D648D)
  static const Color _defaultBackgroundColor = Color(0xFF4D648D);

  const AppFloatingActionButton({
    super.key,
    this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'mainAppFab',
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? _defaultBackgroundColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation ?? 6,
      shape: const CircleBorder(),
      child: Icon(
        icon,
        size: 28,
      ),
    );
  }
}
