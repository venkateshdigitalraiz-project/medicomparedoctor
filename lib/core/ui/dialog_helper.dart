import 'package:flutter/material.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/main.dart';

/// Helper class to manage dialog display globally.
class DialogHelper {
  static bool _isShowing404Dialog = false;

  /// Shows the session expired dialog.
  /// Prevents duplicates by checking [_isShowing404Dialog].
  static void showSessionExpired(BuildContext context) {
    if (_isShowing404Dialog) return;
    _isShowing404Dialog = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Session Expired'),
          content: const Text(
            'Your session has expired. Please log in again.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Dismiss the dialog first
                Navigator.of(dialogContext).pop();
                _isShowing404Dialog = false;

                // Clear all session/login data
                await SessionManager.clearSession();

                // Navigate to Login screen using pushAndRemoveUntil
                final navigator = MyApp.navigatorKey.currentState;
                if (navigator != null) {
                  navigator.pushNamedAndRemoveUntil(
                    RouteNames.login,
                    (_) => false,
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      // Safety reset in case of dialog being dismissed by other means
      _isShowing404Dialog = false;
    });
  }
}
