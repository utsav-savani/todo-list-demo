import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_firebase_demo/core/exceptions/app_exception.dart';
import 'package:todo_firebase_demo/core/navigation/nav_constants.dart';
import 'package:todo_firebase_demo/core/service/service_locator.dart';
import 'package:todo_firebase_demo/features/auth/domain/repositories/user_repository.dart';

/// Enum to represent the different states of the authentication process
class AuthState {
  final bool isLoading;
  final String? error;
  final String? userId;

  AuthState({required this.isLoading, this.error, this.userId});

  // Initial state when no user is authenticated
  factory AuthState.initial() {
    return AuthState(isLoading: false, error: null, userId: null);
  }

  // Factory method for successful login
  factory AuthState.success(String userId) {
    return AuthState(isLoading: false, error: null, userId: userId);
  }

  // Factory method for loading state
  factory AuthState.loading() {
    return AuthState(isLoading: true, error: null, userId: null);
  }

  // Factory method for error state
  factory AuthState.error(String error) {
    return AuthState(isLoading: false, error: error, userId: null);
  }
}

/// A class to represent the current state of authentication
class AuthStateNotifier extends StateNotifier<AuthState> {
  final UserRepository _userRepository;

  AuthStateNotifier()
      : _userRepository = taskInstance<UserRepository>(),
        super(AuthState.initial());

  /// Login function to authenticate the user
  Future<void> login(
      String email, String password) async {
    state = AuthState.loading();
    try {
      var user = await _userRepository.signIn(email: email, password: password);
      if (user != null) {
        state = AuthState.success(user.firebaseUid);
      } else {
        state = AuthState.error("Something went wrong!");
      }
    } catch (e) {
      if (e is AppException) {
        state = AuthState.error(e.message);
      } else {
        state = AuthState.error(e.toString());
      }
    }
  }

  /// Register function to create a new user account
  Future<void> register(
      String email, String password) async {
    state = AuthState.loading();
    try {
      var user =
          await _userRepository.register(email: email, password: password);
      if (user != null) {
        state = AuthState.success(user.firebaseUid);
      } else {
        state = AuthState.error("Something went wrong!");
      }
    } catch (e) {
      if (e is AppException) {
        state = AuthState.error(e.message);
      } else {
        state = AuthState.error(e.toString());
      }
    }
  }

  /// Logout function to log the user out
  Future<void> logout() async {
    await _userRepository.signOut();
    state = AuthState.initial();
  }

  void setSuccess(String userId) {
    state = AuthState.success(userId);
  }
}
