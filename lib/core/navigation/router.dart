import 'package:go_router/go_router.dart';
import 'package:todo_firebase_demo/core/navigation/nav_constants.dart';
import 'package:todo_firebase_demo/core/presentation/screens/splash_screen.dart';
import 'package:todo_firebase_demo/features/auth/presentation/screens/login_screen.dart';
import 'package:todo_firebase_demo/features/auth/presentation/screens/registration_screen.dart';
import 'package:todo_firebase_demo/features/home/presentation/screens/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: NavConstants.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: NavConstants.login,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: NavConstants.registration,
      builder: (context, state) => RegistrationScreen(),
    ),
    GoRoute(
      path: NavConstants.home,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
  initialLocation: '/splash', // Start at the login screen
);
