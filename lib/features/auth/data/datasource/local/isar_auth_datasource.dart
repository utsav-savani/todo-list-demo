import 'package:isar/isar.dart';
import 'package:todo_firebase_demo/features/auth/data/model/user_model.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';

class IsarAuthDatasource {
  final Isar isar;

  IsarAuthDatasource({required this.isar});

  Future<void> saveUser(UserModel user) async {
    var oldUser = await isar.userModels.filter().emailEqualTo(user.email).findFirst();
    if(oldUser == null){
      await isar.writeTxn(() async {
        await isar.userModels.put(user);
      });
    }
  }

  Future<UserModel?> getUser() async {
    return await isar.userModels.where().findFirst();
  }

  Future<void> removeUser(String firebaseUid) async {
    await isar.writeTxn(() async {
      await isar.tasks.clear();
      await isar.userModels
          .filter()
          .firebaseUidEqualTo(firebaseUid)
          .deleteAll();
    });
  }
}
