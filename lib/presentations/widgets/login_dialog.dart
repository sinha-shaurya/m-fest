import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';

class LoginDialog extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginDialog({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Login Required'),
      content: Text(
        'To access this feature, please log in to your account.',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
