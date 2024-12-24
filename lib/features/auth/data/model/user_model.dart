import 'package:isar/isar.dart';

part 'user_model.g.dart';

@Collection()
class UserModel {
  Id id = Isar.autoIncrement;  // Auto-generated ID

  @Index()
  late String firebaseUid;

  late String email;
  late String displayName;
  late String photoURL;

  UserModel({
    required this.firebaseUid,
    required this.email,
    required this.displayName,
    required this.photoURL,
  });
}
