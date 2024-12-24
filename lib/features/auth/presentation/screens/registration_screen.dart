import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_firebase_demo/core/navigation/nav_constants.dart';
import 'package:todo_firebase_demo/core/presentation/provider/connectivity_provider.dart';
import 'package:todo_firebase_demo/core/validators/email_validator.dart';
import 'package:todo_firebase_demo/core/validators/password_validator.dart';
import 'package:todo_firebase_demo/features/auth/presentation/provider/auth_provider.dart';
import 'package:todo_firebase_demo/features/auth/presentation/widget/password_field_widget.dart';

class RegistrationScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the auth provider to get the current registration state
    final authState = ref.watch(authProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (authState.userId != null) {
        context.go(NavConstants.home);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                PasswordFieldWidget(
                    controller: _passwordController,
                    isConfirmPassword: false,
                    labelText: 'Password'),
                const SizedBox(height: 16),
                PasswordFieldWidget(
                    controller: _confirmPasswordController,
                    isConfirmPassword: true,
                    labelText: 'Confirm Password'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;

                    String? emailMessage = EmailValidator.validateEmail(email);
                    String? pwdMessage =
                        PasswordValidator.validatePassword(password);
                    String? confPwdMessage =
                        PasswordValidator.validateConfirmPassword(
                            confirmPassword, password);
                    final isOnline =
                        await ref.refresh(connectivityProvider.future);
                    if (isOnline) {
                      if (emailMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(emailMessage)));
                      } else if (pwdMessage != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(pwdMessage)));
                      } else if (confPwdMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(confPwdMessage)));
                      } else {
                        ref
                            .read(authProvider.notifier)
                            .register(email, password);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please check your internet")));
                    }
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 16),
                if (authState.error != null)
                  Text(
                    authState.error ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          if (authState.isLoading)
            Positioned.fill(
                child: Container(
                    color: Colors.black45,
                    child: const Center(child: CircularProgressIndicator()))),
        ],
      ),
    );
  }
}
