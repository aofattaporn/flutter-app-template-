import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/main/main.dart';

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/main',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainAppShell(),
      ),
      // Add more routes here
      // GoRoute(
      //   path: '/login',
      //   name: 'login',
      //   builder: (context, state) => const LoginPage(),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
});

/// Route names for type-safe navigation
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register';
}
