import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_firebase_demo/core/service/task_sync_service.dart';
import 'package:todo_firebase_demo/features/auth/data/datasource/local/isar_auth_datasource.dart';
import 'package:todo_firebase_demo/features/auth/data/datasource/remote/firebase_auth_datasource.dart';
import 'package:todo_firebase_demo/features/auth/data/model/user_model.dart';
import 'package:todo_firebase_demo/features/auth/data/repositories/user_repository_impl.dart';
import 'package:todo_firebase_demo/features/auth/domain/repositories/user_repository.dart';
import 'package:todo_firebase_demo/features/home/data/datasource/local/isar_task_datasource.dart';
import 'package:todo_firebase_demo/features/home/data/datasource/remote/firestore_task_datasource.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';
import 'package:todo_firebase_demo/features/home/data/repositories/task_repository_impl.dart';
import 'package:todo_firebase_demo/features/home/domain/repositories/task_repository.dart';

final taskInstance = GetIt.instance;

Future<void> initializeDependencies() async {
  var storageDir = await getApplicationSupportDirectory();
  var isar = await Isar.open(
      [TaskSchema, UserModelSchema], // Add all your Isar models here
      inspector: true,
      directory: storageDir.path);
  taskInstance
    ..registerLazySingleton(() => FirebaseAuthDataSource())
    ..registerLazySingleton(() => FirebaseTaskDatasource())
    ..registerLazySingleton(() => IsarTaskDatasource(isar: isar))
    ..registerLazySingleton(() => IsarAuthDatasource(isar: isar))
    ..registerLazySingleton(() => TaskSyncService(
        taskInstance(), taskInstance(), taskInstance(), taskInstance()))
    ..registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        firebaseAuthDataSource: taskInstance(),
        isarAuthDatasource: taskInstance()))
    ..registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
        firebaseTaskDatasource: taskInstance(),
        isarTaskDatasource: taskInstance()));
}
