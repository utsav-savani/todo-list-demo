import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_firebase_demo/features/home/presentation/provider/task_provider.dart';
import 'package:todo_firebase_demo/features/home/presentation/widget/add_task_dialog.dart';
import 'package:todo_firebase_demo/features/home/presentation/widget/confirm_delete_dialog.dart';
import 'package:todo_firebase_demo/features/auth/presentation/widget/confirm_logout_popup.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Tasks"),
        actions: [
          IconButton(
              onPressed: () {
                confirmLogout(context, ref);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: taskState.when(
        data: (tasks) {
          return tasks.isEmpty
              ? const Center(
                  child: Text("No Tasks Found"),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            showDialog(
                              context: context,
                              builder: (context) => AddTaskDialog(task: task),
                            );
                          } else if (value == 'delete') {
                            confirmDelete(context, task, ref);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Failed to load tasks: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
