import 'package:todo_firebase_demo/features/auth/data/model/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> register({required String email, required String password});

  Future<UserModel?> signIn({required String email, required String password});

  Future<void> signOut();

  Future<String?> getCurrentUserId({required bool isOnline});
}
