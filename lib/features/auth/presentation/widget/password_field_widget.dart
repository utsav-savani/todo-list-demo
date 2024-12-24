import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for managing password visibility
final passwordVisibilityProvider = StateProvider<bool>((ref) => true); // Password is hidden by default
final confirmPasswordVisibilityProvider = StateProvider<bool>((ref) => true); // Confirm Password is hidden by default

// Password Field Widget that watches visibility state
class PasswordFieldWidget extends ConsumerWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isConfirmPassword;

  const PasswordFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isConfirmPassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the visibility state based on the field type
    final isPasswordVisible = isConfirmPassword
        ? ref.watch(confirmPasswordVisibilityProvider)
        : ref.watch(passwordVisibilityProvider);

    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible, // Toggling visibility
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            !isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            // Toggle visibility state
            if (isConfirmPassword) {
              ref.read(confirmPasswordVisibilityProvider.notifier).state =
              !isPasswordVisible;
            } else {
              ref.read(passwordVisibilityProvider.notifier).state =
              !isPasswordVisible;
            }
          },
        ),
      ),
    );
  }
}
