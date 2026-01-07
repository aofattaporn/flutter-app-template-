import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

import '../config/app_config.dart';
import '../core/core.dart';
import '../data/data.dart';
import '../domain/domain.dart';

final getIt = GetIt.instance;

/// Configure dependencies
Future<void> configureDependencies() async {
  // ─────────────────────────────────────────────────────────────
  // Core
  // ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<LocalStorage>(() => SharedPrefsStorage());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  getIt.registerLazySingleton<ApiClient>(
    () => DioApiClient(baseUrl: AppConfig.apiBaseUrl),
  );

  // ─────────────────────────────────────────────────────────────
  // Supabase (if using Supabase backend)
  // ─────────────────────────────────────────────────────────────
  if (BackendConfig.isSupabase) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  }

  // ─────────────────────────────────────────────────────────────
  // Data Sources
  // ─────────────────────────────────────────────────────────────
  if (BackendConfig.isSupabase) {
    getIt.registerLazySingleton<AuthDataSource>(
      () => AuthSupabaseDataSource(
        supabaseClient: getIt<SupabaseClient>(),
      ),
    );
    getIt.registerLazySingleton<PlanDataSource>(
      () => PlanSupabaseDataSource(getIt<SupabaseClient>()),
    );
  } else {
    getIt.registerLazySingleton<AuthDataSource>(
      () => AuthRestDataSource(
        apiClient: getIt<ApiClient>(),
        localStorage: getIt<LocalStorage>(),
      ),
    );
    // TODO: Add REST implementation for PlanDataSource if needed
  }

  // ─────────────────────────────────────────────────────────────
  // Repositories
  // ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dataSource: getIt<AuthDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  if (BackendConfig.isSupabase) {
    getIt.registerLazySingleton<PlanRepository>(
      () => PlanRepositoryImpl(getIt<PlanDataSource>()),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Use Cases
  // ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => GetCurrentUserUseCase(getIt<AuthRepository>()));
}
