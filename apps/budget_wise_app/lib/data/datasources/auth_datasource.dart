import '../models/user_model.dart';

/// Authentication data source interface
/// Implemented by REST and Supabase data sources
abstract class AuthDataSource {
  /// Login with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? avatarUrl,
  });

  /// Get auth token
  Future<String?> getToken();

  /// Refresh auth token
  Future<String?> refreshToken();
}
