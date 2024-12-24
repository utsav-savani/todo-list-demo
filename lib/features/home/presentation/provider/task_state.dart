import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_firebase_demo/core/service/service_locator.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';
import 'package:todo_firebase_demo/features/home/domain/repositories/task_repository.dart';

// State for the task list fetching process
class TaskState {
  final bool isLoading;
  final String? error;

  TaskState({required this.isLoading, this.error});

  // Initial state when no tasks have been fetched yet
  factory TaskState.initial() {
    return TaskState(isLoading: false, error: null);
  }

  // Factory method for successful data fetching
  factory TaskState.success() {
    return TaskState(isLoading: false, error: null);
  }

  // Factory method for loading state
  factory TaskState.loading() {
    return TaskState(isLoading: true, error: null);
  }

  // Factory method for error state
  factory TaskState.error(String error) {
    return TaskState(isLoading: false, error: error);
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _taskRepository;

  TaskNotifier()
      : _taskRepository = taskInstance<TaskRepository>(),
        super(TaskState.initial());

  Future<void> addTask(
      {required Task task,
      required bool isOnline,
      required String userId}) async {
    try {
      await _taskRepository.addTask(
          isOnline: isOnline, task: task, userId: userId);
      state = TaskState.success();
    } catch (e) {
      state = TaskState.error('Failed to add task: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateTask(
      {required Task task,
      required bool isOnline,
      required String userId}) async {
    try {
      await _taskRepository.updateTask(
          task: task, isOnline: isOnline, userId: userId);
      state = TaskState.success();
    } catch (e) {
      state = TaskState.error('Failed to update task: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteTask(
      {required Task task,
      required bool isOnline,
      required String userId}) async {
    try {
      await _taskRepository.deleteTask(
          task: task, isOnline: isOnline, userId: userId);
      state = TaskState.success();
    } catch (e) {
      state = TaskState.error('Failed to delete task: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Task>> tasks({required bool isOnline, required String userId}) {
    return _taskRepository
        .fetchTasksStream(isOnline: isOnline, userId: userId)
        .last;
  }
}
