import 'package:isar/isar.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';

class IsarTaskDatasource {
  final Isar isar;

  IsarTaskDatasource({required this.isar});

  Stream<List<Task>> fetchTasksStream() async* {
    // Fetch all tasks where isDeleted is false
    final tasks = await isar.tasks.where().filter().isDeletedEqualTo(false).findAll();
    yield tasks; // Emit the current tasks

    // Listen for real-time updates using watch and apply the same filter
    await for (final updatedTasks in isar.tasks.where().filter().isDeletedEqualTo(false).watch()) {
      yield updatedTasks; // Emit updated tasks when there are changes
    }
  }


  Future<void> addTask(Task task, bool isSynced) async {
    try {
      task.isSynced = isSynced;
      await isar.writeTxn(() async {
        await isar.tasks.put(task);
      });
    } catch (e) {
      throw Exception("Error adding task: $e");
    }
  }

  // Update a task
  Future<void> updateTask(Task task, bool isSynced) async {
    try {
      Task? existingTask = await getTaskByDocId(task.docId);
      if (existingTask != null) {
        existingTask.title = task.title;
        existingTask.description = task.description;
        existingTask.docId = task.docId;
        existingTask.isSynced = isSynced;
        existingTask.isDeleted = task.isDeleted;
        await isar.writeTxn(() async {
          await isar.tasks.put(existingTask);
        });
      }
    } catch (e) {
      throw Exception("Error updating task: $e");
    }
  }

  // Delete a task
  Future<void> deleteTask(Task task, bool isSynced) async {
    try {
      if (isSynced) {
        await isar.writeTxn(() async {
          await isar.tasks.delete(task.id);
        });
      } else {
        var existingTask = await getTaskByDocId(task.docId);
        if (existingTask != null) {
          existingTask.isDeleted = true;
          await updateTask(existingTask, false);
        }
      }
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }

  // Insert a list of tasks into Isar database
  Future<void> insertTasksIntoIsar(List<Task> tasks) async {
    try {
      await isar.writeTxn((isar) async {
        await isar.tasks.putAll(tasks);
      } as Future Function());
    } catch (e) {
      throw Exception("Error inserting tasks: $e");
    }
  }

  Future<List<Task>> getUnsyncedTasks() async {
    return await isar.tasks.filter().isSyncedEqualTo(false).findAll();
  }

  Future<Task?> getTaskByDocId(String docId) {
    return isar.tasks.filter().docIdEqualTo(docId).findFirst();
  }
}
