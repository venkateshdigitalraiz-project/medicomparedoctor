import 'package:flutter/material.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/main.dart';

/// Helper class to manage dialog display globally.
class DialogHelper {
  static bool _isShowingDialog = false;
  static bool isAtLoginScreen = false;

  /// Shows a global error dialog.
  /// Prevents duplicates by checking [_isShowingDialog].
  static void showGlobalErrorDialog(
    BuildContext context,
    String message, {
    String profile = 'Your Profile',
    String okButtonText = 'Login',
    bool shouldRedirect = true,
    bool showCancelButton = false,
  }) {
    if (_isShowingDialog || isAtLoginScreen) return;
    _isShowingDialog = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFEFF6FF),
          title: Text(
            profile,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: Colors.red.shade500,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unable to load your profile details. Please try again.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
              if (shouldRedirect) ...[
                const SizedBox(height: 12),
                const Text(
                  'Do you want to go to the login page?',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ],
          ),
          actions: [
            if (showCancelButton)
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _isShowingDialog = false;
                },
                child: const Text('Cancel'),
              ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
              ),
              onPressed: () async {
                // Dismiss the dialog first
                Navigator.of(dialogContext).pop();
                _isShowingDialog = false;

                if (shouldRedirect) {
                  // Clear all session/login data
                  await SessionManager.clearSession();
                  isAtLoginScreen = true;

                  // Navigate to Login screen using pushAndRemoveUntil
                  final navigator = MyApp.navigatorKey.currentState;
                  if (navigator != null) {
                    navigator.pushNamedAndRemoveUntil(
                      RouteNames.login,
                      (_) => false,
                    );
                  }
                }
              },
              child: Text(okButtonText),
            ),
          ],
        );
      },
    ).then((_) {
      // Safety reset in case of dialog being dismissed by other means
      _isShowingDialog = false;
    });
  }

  /// Shows the session expired dialog.
  static void showSessionExpired(BuildContext context) {
    showGlobalErrorDialog(
      context,
      'Your session has expired. Please log in again.',
      shouldRedirect: true,
    );
  }
}
