import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_firebase_demo/core/navigation/nav_constants.dart';
import 'package:todo_firebase_demo/features/auth/presentation/provider/auth_provider.dart';

void confirmLogout(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you really want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              await ref.read(authProvider.notifier).logout();
              context.go(NavConstants.login);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
