import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// MINIMAL DESIGN SYSTEM
/// Clean, flat, high-contrast. White backgrounds, no colored AppBars,
/// no heavy shadows. Accent color used sparingly for interactive elements.
/// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A1A2E);
  static const Color accent = Color(0xFF4D648D);
  static const Color accentLight = Color(0xFFEEF1F6);

  // ── Backgrounds ────────────────────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFFFAFAFA);
  static const Color cardBg = Colors.white;
  static const Color surfaceLight = Color(0xFFF5F5F5);

  // ── Text ───────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;

  // ── Semantic ───────────────────────────────────────────────────────────
  static const Color income = Color(0xFF059669);
  static const Color expense = Color(0xFFDC2626);
  static const Color incomeLight = Color(0xFFECFDF5);
  static const Color expenseLight = Color(0xFFFEF2F2);

  // ── Borders / Dividers ─────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
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
  AppStyles._();

  // ── Card ───────────────────────────────────────────────────────────────
  static BoxDecoration get card => BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.5),
      );

  static BoxDecoration get cardFlat => BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      );

  // ── Text ───────────────────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textTertiary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  // ── Input ──────────────────────────────────────────────────────────────
  static const TextStyle inputText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static InputDecoration input({
    String? label,
    String? hint,
    Widget? prefix,
    Widget? suffix,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
      prefixIcon: prefix,
      suffixIcon: suffix,
      prefixText: prefixText,
      prefixStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
      filled: true,
      fillColor: AppColors.scaffoldBg,
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
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        borderSide: const BorderSide(color: AppColors.expense),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ── Buttons ────────────────────────────────────────────────────────────
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      );

  static ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        side: const BorderSide(color: AppColors.border),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      );

  // ── Minimal AppBar ─────────────────────────────────────────────────────
  static AppBar appBar({
    required String title,
    List<Widget>? actions,
    bool showBack = true,
    Widget? leading,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(title, style: titleMedium),
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: showBack,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(color: AppColors.border, height: 0.5),
      ),
    );
  }

  // ── Bottom Sheet ───────────────────────────────────────────────────────
  static Widget sheetHandle() => Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  // ── Icon Container ─────────────────────────────────────────────────────
  static Widget iconBox({
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
        color: bgColor ?? AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize, color: iconColor ?? AppColors.accent),
    );
  }
}
