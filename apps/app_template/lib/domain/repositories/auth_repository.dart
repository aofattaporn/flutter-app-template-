import '../entities/user_entity.dart';
import '../../core/utils/typedefs.dart';

/// Authentication repository interface
/// Implemented by data layer
abstract class AuthRepository {
  /// Login with email and password
  ResultFuture<UserEntity> login({
    required String email,
    required String password,
  });

  /// Register new user
  ResultFuture<UserEntity> register({
    required String email,
    required String password,
    String? name,
  });

  /// Logout current user
  ResultVoid logout();

  /// Get current authenticated user
  ResultFuture<UserEntity?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Send password reset email
  ResultVoid sendPasswordResetEmail(String email);

  /// Update user profile
  ResultFuture<UserEntity> updateProfile({
    String? name,
    String? avatarUrl,
  });
}
