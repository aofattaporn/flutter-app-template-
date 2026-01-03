import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../models/user_model.dart';
import '../auth_datasource.dart';

/// REST API implementation of AuthDataSource
class AuthRestDataSource implements AuthDataSource {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  AuthRestDataSource({
    required ApiClient apiClient,
    required LocalStorage localStorage,
  })  : _apiClient = apiClient,
        _localStorage = localStorage;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final token = data['token'] as String?;
    final user = data['user'] as Map<String, dynamic>?;

    if (token != null) {
      await _localStorage.setString(AppConstants.tokenKey, token);
      _apiClient.setAuthToken(token);
    }

    if (data['refresh_token'] != null) {
      await _localStorage.setString(
        AppConstants.refreshTokenKey,
        data['refresh_token'] as String,
      );
    }

    if (user == null) {
      throw const ServerException(message: 'Invalid response from server');
    }

    final userModel = UserModel.fromJson(user);
    await _localStorage.setObject(AppConstants.userKey, userModel.toJson());

    return userModel;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        if (name != null) 'name': name,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final token = data['token'] as String?;
    final user = data['user'] as Map<String, dynamic>?;

    if (token != null) {
      await _localStorage.setString(AppConstants.tokenKey, token);
      _apiClient.setAuthToken(token);
    }

    if (user == null) {
      throw const ServerException(message: 'Invalid response from server');
    }

    final userModel = UserModel.fromJson(user);
    await _localStorage.setObject(AppConstants.userKey, userModel.toJson());

    return userModel;
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } catch (_) {
      // Ignore logout API errors
    } finally {
      await _localStorage.remove(AppConstants.tokenKey);
      await _localStorage.remove(AppConstants.refreshTokenKey);
      await _localStorage.remove(AppConstants.userKey);
      _apiClient.clearAuthToken();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = await _localStorage.getString(AppConstants.tokenKey);
    if (token == null) return null;

    // First try to get from cache
    final cachedUser = await _localStorage.getObject(
      AppConstants.userKey,
      UserModel.fromJson,
    );

    if (cachedUser != null) {
      _apiClient.setAuthToken(token);
      return cachedUser;
    }

    // Fetch from API
    try {
      _apiClient.setAuthToken(token);
      final response = await _apiClient.get(ApiConstants.profile);
      final data = response.data as Map<String, dynamic>;
      final userModel = UserModel.fromJson(data);
      await _localStorage.setObject(AppConstants.userKey, userModel.toJson());
      return userModel;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localStorage.getString(AppConstants.tokenKey);
    return token != null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _apiClient.post(
      '${ApiConstants.auth}/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    final response = await _apiClient.patch(
      ApiConstants.profile,
      data: {
        if (name != null) 'name': name,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final userModel = UserModel.fromJson(data);
    await _localStorage.setObject(AppConstants.userKey, userModel.toJson());

    return userModel;
  }

  @override
  Future<String?> getToken() async {
    return _localStorage.getString(AppConstants.tokenKey);
  }

  @override
  Future<String?> refreshToken() async {
    final refreshTokenValue = await _localStorage.getString(AppConstants.refreshTokenKey);
    if (refreshTokenValue == null) return null;

    try {
      final response = await _apiClient.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshTokenValue},
      );

      final data = response.data as Map<String, dynamic>;
      final newToken = data['token'] as String?;

      if (newToken != null) {
        await _localStorage.setString(AppConstants.tokenKey, newToken);
        _apiClient.setAuthToken(newToken);

        if (data['refresh_token'] != null) {
          await _localStorage.setString(
            AppConstants.refreshTokenKey,
            data['refresh_token'] as String,
          );
        }
      }

      return newToken;
    } catch (e) {
      await logout();
      return null;
    }
  }
}
