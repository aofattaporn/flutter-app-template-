import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';
import '../auth_datasource.dart';

/// Supabase implementation of AuthDataSource
class AuthSupabaseDataSource implements AuthDataSource {
  final SupabaseClient _supabase;

  AuthSupabaseDataSource({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const UnauthorizedException(message: 'Invalid credentials');
      }

      return UserModel.fromSupabase(response.user!.toJson());
    } on AuthException catch (e) {
      throw UnauthorizedException(message: e.message);
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.user == null) {
        throw const ServerException(message: 'Registration failed');
      }

      return UserModel.fromSupabase(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabase(user.toJson());
  }

  @override
  Future<bool> isAuthenticated() async {
    return _supabase.auth.currentUser != null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            if (name != null) 'name': name,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      if (response.user == null) {
        throw const ServerException(message: 'Failed to update profile');
      }

      return UserModel.fromSupabase(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<String?> getToken() async {
    return _supabase.auth.currentSession?.accessToken;
  }

  @override
  Future<String?> refreshToken() async {
    final response = await _supabase.auth.refreshSession();
    return response.session?.accessToken;
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
