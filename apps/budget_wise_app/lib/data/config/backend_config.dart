/// Backend type enum for dynamic backend switching
enum BackendType {
  /// REST API backend
  rest,

  /// Supabase serverless backend
  supabase,
}

/// Backend configuration
class BackendConfig {
  /// Current backend type
  static BackendType currentBackend = BackendType.rest;

  /// Check if using REST backend
  static bool get isRest => currentBackend == BackendType.rest;

  /// Check if using Supabase backend
  static bool get isSupabase => currentBackend == BackendType.supabase;

  /// Switch to REST backend
  static void useRest() {
    currentBackend = BackendType.rest;
  }

  /// Switch to Supabase backend
  static void useSupabase() {
    currentBackend = BackendType.supabase;
  }

  /// Set backend type directly
  static void setBackend(BackendType type) {
    currentBackend = type;
  }

  /// Set backend from string (useful for environment config)
  static void setFromString(String backend) {
    switch (backend.toLowerCase()) {
      case 'supabase':
        currentBackend = BackendType.supabase;
        break;
      case 'rest':
      default:
        currentBackend = BackendType.rest;
    }
  }
}
