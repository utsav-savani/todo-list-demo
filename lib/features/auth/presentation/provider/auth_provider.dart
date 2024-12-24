import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

/// The provider that exposes the AuthStateNotifier
final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

