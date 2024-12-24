import 'package:todo_firebase_demo/features/auth/data/datasource/local/isar_auth_datasource.dart';
import 'package:todo_firebase_demo/features/auth/data/datasource/remote/firebase_auth_datasource.dart';
import 'package:todo_firebase_demo/features/auth/data/model/user_model.dart';
import 'package:todo_firebase_demo/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final IsarAuthDatasource isarAuthDatasource;

  UserRepositoryImpl(
      {required this.firebaseAuthDataSource, required this.isarAuthDatasource});

  // Register a new user
  @override
  Future<UserModel?> register(
      {required String email, required String password}) async {
    var user = await firebaseAuthDataSource.register(
      email: email,
      password: password,
    );
    if (user != null) {
      UserModel userModel = UserModel(
        firebaseUid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoURL: user.photoURL ?? '',
      );
      isarAuthDatasource.saveUser(userModel);
      return userModel;
    }
    return null;
  }

  // Sign in an existing user
  @override
  Future<UserModel?> signIn(
      {required String email, required String password}) async {
    var user = await firebaseAuthDataSource.signIn(
      email: email,
      password: password,
    );
    if (user != null) {
      UserModel userModel = UserModel(
        firebaseUid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoURL: user.photoURL ?? '',
      );
      isarAuthDatasource.saveUser(userModel);
      return userModel;
    }
    return null;
  }

  // Sign out the current user
  @override
  Future<void> signOut() async {
    UserModel? user = await isarAuthDatasource.getUser();
    if (user != null) {
      await isarAuthDatasource.removeUser(user.firebaseUid);
    }
    await firebaseAuthDataSource.signOut();
  }

  @override
  Future<String?> getCurrentUserId({required bool isOnline}) async {
    if (isOnline) {
      var currentUser = firebaseAuthDataSource.getCurrentUser();
      return currentUser?.uid;
    } else {
      var user = await isarAuthDatasource.getUser();
      return user?.firebaseUid;
    }
  }
}
