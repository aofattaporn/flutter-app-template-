import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budgetwise_design_system/budgetwise_design_system.dart';

import 'config/app_config.dart';
import 'di/injection.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig.initialize();

  // Initialize dependency injection
  await configureDependencies();

  runApp(
    const ProviderScope(
      child: AppTemplateApp(),
    ),
  );
}

class AppTemplateApp extends ConsumerWidget {
  const AppTemplateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'App Template',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      // Router
      routerConfig: router,
    );
  }
}

