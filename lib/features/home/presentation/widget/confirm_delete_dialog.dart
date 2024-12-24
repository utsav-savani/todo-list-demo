import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_firebase_demo/core/presentation/provider/connectivity_provider.dart';
import 'package:todo_firebase_demo/features/auth/presentation/provider/auth_provider.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';
import 'package:todo_firebase_demo/features/home/presentation/provider/task_provider.dart';

void confirmDelete(BuildContext context, Task task, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you really want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authState = ref.watch(authProvider);
              final isOnline = await ref.refresh(connectivityProvider.future);
              Navigator.pop(context);

              await ref
                  .read(taskProvider.notifier)
                  .deleteTask(task: task, isOnline: isOnline, userId: authState.userId ?? '');
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
