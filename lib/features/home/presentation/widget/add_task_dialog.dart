import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_firebase_demo/core/presentation/provider/connectivity_provider.dart';
import 'package:todo_firebase_demo/features/auth/presentation/provider/auth_provider.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';
import 'package:todo_firebase_demo/features/home/presentation/provider/task_provider.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  final Task? task;

  const AddTaskDialog({super.key, this.task});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Task Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (titleController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty) {
              String title = titleController.text;
              String description = descriptionController.text;
              final isOnline = await ref.refresh(connectivityProvider.future);
              final authState = ref.watch(authProvider);
              if (widget.task != null) {
                ref.read(taskProvider.notifier).updateTask(
                    task: Task(
                        docId: widget.task!.docId,
                        title: title,
                        description: description),
                    isOnline: isOnline,
                    userId: authState.userId ?? '');
              } else {
                ref.read(taskProvider.notifier).addTask(
                    task:
                        Task(title: title, description: description, docId: ''),
                    isOnline: isOnline,
                    userId: authState.userId ?? '');
              }
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please enter both title and description')),
              );
            }
          },
          child: Text(widget.task != null ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}
