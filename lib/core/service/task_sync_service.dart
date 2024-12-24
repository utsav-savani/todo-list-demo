import 'package:todo_firebase_demo/features/auth/data/datasource/local/isar_auth_datasource.dart';
import 'package:todo_firebase_demo/features/auth/data/datasource/remote/firebase_auth_datasource.dart';
import 'package:todo_firebase_demo/features/auth/data/model/user_model.dart';
import 'package:todo_firebase_demo/features/home/data/datasource/remote/firestore_task_datasource.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';

import '../../features/home/data/datasource/local/isar_task_datasource.dart';

class TaskSyncService {
  final IsarTaskDatasource _isarTaskDatasource;
  final FirebaseTaskDatasource _firebaseTaskDatasource;
  final FirebaseAuthDataSource _firebaseAuthDataSource;
  final IsarAuthDatasource _isarAuthDatasource;

  TaskSyncService(this._isarTaskDatasource, this._firebaseTaskDatasource,
      this._isarAuthDatasource, this._firebaseAuthDataSource);

  Future<void> syncTasks(String userId) async {
    await insertUser();
    await _syncLocalToFirebase(userId);
    await _syncFirebaseToLocal(userId);
  }

  // Sync local tasks (from Isar) to Firebase
  Future<void> _syncLocalToFirebase(String userId) async {
    final unsyncedTasks = await _isarTaskDatasource.getUnsyncedTasks();
    for (var task in unsyncedTasks) {
      try {
        if (task.isDeleted) {
          await _firebaseTaskDatasource.deleteTask(task, userId);
          await _isarTaskDatasource.deleteTask(task, true);
        } else if (task.docId.isEmpty) {
          var docId = await _firebaseTaskDatasource.addTask(
              Task(
                  docId: task.docId,
                  title: task.title,
                  description: task.description),
              userId);
          task.docId = docId;
          await _isarTaskDatasource.updateTask(task, true);
        } else {
          await _firebaseTaskDatasource.updateTask(
              Task(
                  docId: task.docId,
                  title: task.title,
                  description: task.description),
              userId);
          await _isarTaskDatasource.updateTask(task, true);
        }
      } catch (e) {
        print("Failed to sync task: $e");
      }
    }
  }

  // Sync remote tasks (from Firebase) to Isar
  Future<void> _syncFirebaseToLocal(String userId) async {
    try {
      var allTasks = await _firebaseTaskDatasource.getAllTasks(userId);
      for (var task in allTasks) {
        // Insert or update the task in Isar
        Task? existingTask = await _isarTaskDatasource.getTaskByDocId(task.docId);
        if (existingTask == null) {
          task.isSynced = true;
          await _isarTaskDatasource.addTask(task, true);
        } else {
          // Update existing task if necessary
          existingTask.title = task.title;
          existingTask.description = task.description;
          existingTask.docId = task.docId;
          if (existingTask.title != task.title ||
              existingTask.description != task.description) {
            await _isarTaskDatasource.updateTask(existingTask, true);
          }
        }
      }
    } catch (e) {
      print("Failed to sync from Firebase: $e");
    }
  }

  Future<void> insertUser() async {
    var user = _firebaseAuthDataSource.getCurrentUser();
    if (user != null) {
      UserModel userModel = UserModel(
        firebaseUid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoURL: user.photoURL ?? '',
      );
      await _isarAuthDatasource.saveUser(userModel);
    }
  }
}
