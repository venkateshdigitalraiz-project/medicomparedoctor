import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Placeholder Login screen — replace with your real auth feature.
///
/// Reached in two ways:
///  - First launch: Splash -> Onboarding (3 intro pages) -> Login.
///  - Every launch after that: Splash -> Login directly (onboarding is
///    skipped once `OnboardingPreferences.hasCompletedOnboarding()` is true).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashWhite,
      body: const Center(
        child: Text(
          'Login Screen',
          style: TextStyle(fontSize: 22, color: AppColors.brandPurple),
        ),
      ),
    );
  }
}
