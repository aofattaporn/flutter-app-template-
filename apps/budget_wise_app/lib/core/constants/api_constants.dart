/// API-related constants
class ApiConstants {
  ApiConstants._();

  // ─────────────────────────────────────────────────────────────
  // Base URLs - Configure based on your backend
  // ─────────────────────────────────────────────────────────────

  /// REST API Base URL
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  /// Supabase URL
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  /// Supabase Anon Key
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // ─────────────────────────────────────────────────────────────
  // API Versions
  // ─────────────────────────────────────────────────────────────
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // ─────────────────────────────────────────────────────────────
  // Endpoints
  // ─────────────────────────────────────────────────────────────
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';

  static const String users = '/users';
  static const String profile = '$users/profile';

  // Add your app-specific endpoints here
  // static const String ingredients = '/ingredients';
  // static const String recipes = '/recipes';

  // ─────────────────────────────────────────────────────────────
  // Headers
  // ─────────────────────────────────────────────────────────────
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String accept = 'Accept';
  static const String applicationJson = 'application/json';
}
