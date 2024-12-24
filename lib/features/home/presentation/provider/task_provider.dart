import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_firebase_demo/core/presentation/provider/connectivity_provider.dart';
import 'package:todo_firebase_demo/core/service/service_locator.dart';
import 'package:todo_firebase_demo/core/service/task_sync_service.dart';
import 'package:todo_firebase_demo/features/auth/presentation/provider/auth_provider.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';
import 'package:todo_firebase_demo/features/home/domain/repositories/task_repository.dart';
import 'package:todo_firebase_demo/features/home/presentation/provider/task_state.dart';

final taskStreamProvider = StreamProvider<List<Task>>((ref) {
  final authState = ref.watch(authProvider);
  final connectivityState = ref.watch(connectivityStreamProvider);

  if (authState.userId == null) {
    return Stream.value([]);
  }

  return connectivityState.when(
    data: (connectivity) {
      if (connectivity == ConnectivityResult.none) {
        return taskInstance<TaskRepository>().fetchTasksStream(
          isOnline: false,
          userId: authState.userId ?? '',
        );
      } else {
        taskInstance<TaskSyncService>().syncTasks(authState.userId!);
        return taskInstance<TaskRepository>().fetchTasksStream(
          isOnline: true,
          userId: authState.userId ?? '',
        );
      }
    },
    loading: () {
      return Stream.value([]);
    },
    error: (error, stackTrace) {
      return Stream.value([]);
    },
  );
});

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier();
});
