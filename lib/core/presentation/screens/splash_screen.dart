import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_firebase_demo/core/navigation/nav_constants.dart';
import 'package:todo_firebase_demo/core/presentation/provider/connectivity_provider.dart';
import 'package:todo_firebase_demo/core/service/service_locator.dart';
import 'package:todo_firebase_demo/features/auth/domain/repositories/user_repository.dart';
import 'package:todo_firebase_demo/features/auth/presentation/provider/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Initialize the timer
    _timer = Timer(const Duration(seconds: 1), () async {
      final isOnline = await ref.refresh(connectivityProvider.future);
      if (!mounted) return;

      final userId = await taskInstance<UserRepository>()
          .getCurrentUserId(isOnline: isOnline);
      if (userId != null) {
        ref.read(authProvider.notifier).setSuccess(userId);
        if (mounted) {
          context.go(NavConstants.home);
        }
      } else if (mounted) {
        context.go(NavConstants.login);
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer if it's still active
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Todo App"),
      ),
    );
  }
}
