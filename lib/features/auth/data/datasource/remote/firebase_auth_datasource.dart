import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_firebase_demo/core/exceptions/app_exception.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Register a new user
  Future<User?> register(
      {required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'An error occurred during registration');
    }
  }

  // Sign in an existing user
  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'An error occurred during login');
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppException(e.message ?? 'An error occurred during logout');
    }
  }

  // Get the currently signed-in user
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  // Check if the user is authenticated
  bool isAuthenticated() {
    return firebaseAuth.currentUser != null;
  }
}
