import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budgetwise_design_system/budgetwise_design_system.dart';

import '../../../../router/app_router.dart';

/// Splash page shown on app startup
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Icon(
              Icons.apps_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const DSGap.lg(),
            Text(
              'App Template',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const DSGap.xl(),
            const DSLoading(),
          ],
        ),
      ),
    );
  }
}
