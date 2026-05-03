import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// DESIGN SYSTEM – Theme-aware colors, dimensions & styles
/// Use `context.colors` and `context.styles` for theme-aware access.
/// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  final Color primary;
  final Color accent;
  final Color accentLight;
  final Color scaffoldBg;
  final Color cardBg;
  final Color surfaceLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnPrimary;
  final Color income;
  final Color expense;
  final Color incomeLight;
  final Color expenseLight;
  final Color border;
  final Color divider;

  const AppColors._({
    required this.primary,
    required this.accent,
    required this.accentLight,
    required this.scaffoldBg,
    required this.cardBg,
    required this.surfaceLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnPrimary,
    required this.income,
    required this.expense,
    required this.incomeLight,
    required this.expenseLight,
    required this.border,
    required this.divider,
  });

  // ── Light palette ─────────────────────────────────────────────────────
  static const light = AppColors._(
    primary: Color(0xFF1A1A2E),
    accent: Color(0xFF4D648D),
    accentLight: Color(0xFFEEF1F6),
    scaffoldBg: Color(0xFFFAFAFA),
    cardBg: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFF5F5F5),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    textOnPrimary: Color(0xFFFFFFFF),
    income: Color(0xFF059669),
    expense: Color(0xFFDC2626),
    incomeLight: Color(0xFFECFDF5),
    expenseLight: Color(0xFFFEF2F2),
    border: Color(0xFFE5E7EB),
    divider: Color(0xFFF3F4F6),
  );

  // ── Dark palette ──────────────────────────────────────────────────────
  static const dark = AppColors._(
    primary: Color(0xFFE0E0F0),
    accent: Color(0xFF7B93BD),
    accentLight: Color(0xFF2A2D3E),
    scaffoldBg: Color(0xFF121212),
    cardBg: Color(0xFF1E1E1E),
    surfaceLight: Color(0xFF2C2C2C),
    textPrimary: Color(0xFFE0E0E0),
    textSecondary: Color(0xFF9CA3AF),
    textTertiary: Color(0xFF6B7280),
    textOnPrimary: Color(0xFFFFFFFF),
    income: Color(0xFF34D399),
    expense: Color(0xFFF87171),
    incomeLight: Color(0xFF1A2E28),
    expenseLight: Color(0xFF2E1A1A),
    border: Color(0xFF374151),
    divider: Color(0xFF2D2D2D),
  );

  /// Resolve the palette for the current brightness.
  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

class AppDimens {
  AppDimens._();

  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;

  static const double pagePadding = 20.0;
  static const double cardPadding = 16.0;

  static const double iconSm = 32.0;
  static const double iconMd = 40.0;
  static const double iconLg = 48.0;
}

class AppStyles {
  final AppColors _c;

  const AppStyles._(this._c);

  /// Resolve styles for the current theme.
  static AppStyles of(BuildContext context) => AppStyles._(AppColors.of(context));

  // ── Card ───────────────────────────────────────────────────────────────
  BoxDecoration get card => BoxDecoration(
        color: _c.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: _c.border, width: 0.5),
      );

  BoxDecoration get cardFlat => BoxDecoration(
        color: _c.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      );

  // ── Text ───────────────────────────────────────────────────────────────
  TextStyle get displayLarge => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: _c.textPrimary,
        letterSpacing: -0.5,
      );

  TextStyle get displayMedium => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _c.textPrimary,
        letterSpacing: -0.3,
      );

  TextStyle get titleLarge => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _c.textPrimary,
      );

  TextStyle get titleMedium => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _c.textPrimary,
      );

  TextStyle get bodyLarge => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _c.textPrimary,
      );

  TextStyle get bodyMedium => TextStyle(
        fontSize: 14,
        color: _c.textPrimary,
      );

  TextStyle get bodySmall => TextStyle(
        fontSize: 13,
        color: _c.textSecondary,
      );

  TextStyle get caption => TextStyle(
        fontSize: 12,
        color: _c.textTertiary,
      );

  TextStyle get label => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _c.textSecondary,
        letterSpacing: 0.3,
      );

  // ── Input ──────────────────────────────────────────────────────────────
  TextStyle get inputText => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: _c.textPrimary,
      );

  InputDecoration input({
    String? label,
    String? hint,
    Widget? prefix,
    Widget? suffix,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: _c.textTertiary, fontSize: 14),
      prefixIcon: prefix,
      suffixIcon: suffix,
      prefixText: prefixText,
      prefixStyle: TextStyle(color: _c.textSecondary, fontSize: 16),
      filled: true,
      fillColor: _c.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        borderSide: BorderSide(color: _c.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        borderSide: BorderSide(color: _c.expense),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ── Buttons ────────────────────────────────────────────────────────────
  ButtonStyle get primaryButton {
    final isDark = identical(_c, AppColors.dark);
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? _c.accent : _c.primary,
      foregroundColor: _c.textOnPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
        foregroundColor: _c.textSecondary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        side: BorderSide(color: _c.border),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      );

  // ── Minimal AppBar ─────────────────────────────────────────────────────
  AppBar appBar({
    required String title,
    List<Widget>? actions,
    bool showBack = true,
    Widget? leading,
  }) {
    final isDark = identical(_c, AppColors.dark);
    return AppBar(
      backgroundColor: _c.cardBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(title, style: titleMedium),
      centerTitle: false,
      iconTheme: IconThemeData(color: _c.textPrimary),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: showBack,
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(color: _c.border, height: 0.5),
      ),
    );
  }

  // ── Bottom Sheet ───────────────────────────────────────────────────────
  Widget sheetHandle() => Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        decoration: BoxDecoration(
          color: _c.border,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  // ── Icon Container ─────────────────────────────────────────────────────
  Widget iconBox({
    required IconData icon,
    double size = 40,
    Color? bgColor,
    Color? iconColor,
    double iconSize = 20,
    double radius = 10,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor ?? _c.surfaceLight,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: iconColor ?? _c.accent),
    );
  }
}

// ─── Convenience Extension ───────────────────────────────────────────────────

extension AppThemeContext on BuildContext {
  AppColors get colors => AppColors.of(this);
  AppStyles get styles => AppStyles.of(this);
}
