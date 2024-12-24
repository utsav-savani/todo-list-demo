import 'package:todo_firebase_demo/features/home/data/model/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> fetchTasksStream(
      {required bool isOnline, required String userId});

  Future<void> addTask(
      {required Task task, required bool isOnline, required String userId});

  Future<void> updateTask(
      {required Task task, required bool isOnline, required String userId});

  Future<void> deleteTask(
      {required Task task, required bool isOnline, required String userId});
}
