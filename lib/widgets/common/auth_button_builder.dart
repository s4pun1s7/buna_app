import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common/login_options_dialog.dart';

/// Returns the appropriate auth button for the drawer (Log In for anonymous, Sign Out for authenticated)
Widget buildAuthButton(BuildContext context, User user) {
  final isAnonymous = user.isAnonymous;
  if (isAnonymous) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.login),
      label: const Text('Log In'),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => LoginOptionsDialog(
            isLoading: false,
            onGoogle: () {},
            onEmail: () {},
            onApple: () {},
            onMicrosoft: () {},
            onFacebook: () {},
            onGuest: () {},
          ),
        );
      },
    );
  } else {
    return OutlinedButton.icon(
      icon: const Icon(Icons.logout),
      label: const Text('Sign Out'),
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        try {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        } catch (e) {
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sign-out failed: \\${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}
