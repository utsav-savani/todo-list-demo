import 'package:todo_firebase_demo/features/home/data/datasource/local/isar_task_datasource.dart';
import 'package:todo_firebase_demo/features/home/data/datasource/remote/firestore_task_datasource.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';
import 'package:todo_firebase_demo/features/home/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  FirebaseTaskDatasource firebaseTaskDatasource;
  IsarTaskDatasource isarTaskDatasource;

  TaskRepositoryImpl(
      {required this.firebaseTaskDatasource, required this.isarTaskDatasource});

  @override
  Stream<List<Task>> fetchTasksStream(
      {required bool isOnline, required String userId}) {
    if (isOnline) {
      return firebaseTaskDatasource.fetchTasksStream(userId);
    } else {
      return isarTaskDatasource.fetchTasksStream();
    }
  }

  @override
  Future<void> addTask(
      {required Task task, required bool isOnline, required String userId}) async{
    if (isOnline) {
      var docId = await firebaseTaskDatasource.addTask(task, userId);
      task.docId = docId;
      await isarTaskDatasource.addTask(task,true);
    } else {
      return await isarTaskDatasource.addTask(task,false);
    }
  }

  @override
  Future<void> updateTask(
      {required Task task, required bool isOnline, required String userId}) async {
    if (isOnline) {
      await isarTaskDatasource.updateTask(task,true);
      return await firebaseTaskDatasource.updateTask(task, userId);
    } else {
      return await isarTaskDatasource.updateTask(task,false);
    }
  }

  @override
  Future<void> deleteTask(
      {required Task task, required bool isOnline, required String userId}) async {
    if (isOnline) {
      await isarTaskDatasource.deleteTask(task,true);
      return await firebaseTaskDatasource.deleteTask(task, userId);
    } else {
      return await isarTaskDatasource.deleteTask(task,false);
    }
  }
}
