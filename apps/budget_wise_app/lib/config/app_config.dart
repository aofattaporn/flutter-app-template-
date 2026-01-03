import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_template/data/config/backend_config.dart';

/// App configuration
class AppConfig {
  AppConfig._();

  /// Initialize app configuration
  static Future<void> initialize() async {
    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Configure backend type
    _configureBackend();
  }

  /// Configure backend type based on environment
  static void _configureBackend() {
    final backendType = dotenv.env['BACKEND_TYPE'] ?? 'rest';

    switch (backendType.toLowerCase()) {
      case 'supabase':
        BackendConfig.setBackend(BackendType.supabase);
        break;
      case 'rest':
      default:
        BackendConfig.setBackend(BackendType.rest);
        break;
    }
  }

  /// Get environment variable
  static String get(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Check if debug mode
  static bool get isDebug => dotenv.env['DEBUG'] == 'true';

  /// Get API base URL
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';

  /// Get Supabase URL
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Get Supabase Anon Key
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
