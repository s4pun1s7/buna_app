import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

/// A reusable dialog for login options
class LoginOptionsDialog extends ConsumerWidget {
  final bool isLoading;
  final VoidCallback onGoogle;
  final VoidCallback onEmail;
  final VoidCallback onApple;
  final VoidCallback onMicrosoft;
  final VoidCallback onFacebook;
  final VoidCallback onGuest;

  const LoginOptionsDialog({
    super.key,
    required this.isLoading,
    required this.onGoogle,
    required this.onEmail,
    required this.onApple,
    required this.onMicrosoft,
    required this.onFacebook,
    required this.onGuest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sign In', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onGoogle,
                  icon: const Icon(Icons.login, size: 18),
                  label: Text(AppLocalizations.of(context)!.signInGoogle),
                ),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onEmail,
                  icon: const Icon(Icons.email, size: 18),
                  label: const Text('Email'),
                ),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onApple,
                  icon: const Icon(Icons.apple, size: 18),
                  label: const Text('Apple'),
                ),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onMicrosoft,
                  icon: const Icon(Icons.account_circle, size: 18),
                  label: const Text('Microsoft'),
                ),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onFacebook,
                  icon: const Icon(Icons.facebook, size: 18),
                  label: const Text('Facebook'),
                ),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : onGuest,
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: Text(AppLocalizations.of(context)!.signInGuest),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
