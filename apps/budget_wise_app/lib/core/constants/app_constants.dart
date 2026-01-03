/// App-wide constants
class AppConstants {
  AppConstants._();

  // ─────────────────────────────────────────────────────────────
  // App Info
  // ─────────────────────────────────────────────────────────────
  static const String appName = 'App Template';
  static const String appVersion = '1.0.0';

  // ─────────────────────────────────────────────────────────────
  // Timeouts
  // ─────────────────────────────────────────────────────────────
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ─────────────────────────────────────────────────────────────
  // Pagination
  // ─────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ─────────────────────────────────────────────────────────────
  // Cache
  // ─────────────────────────────────────────────────────────────
  static const Duration cacheValidDuration = Duration(hours: 1);

  // ─────────────────────────────────────────────────────────────
  // Storage Keys
  // ─────────────────────────────────────────────────────────────
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String localeKey = 'app_locale';
}
