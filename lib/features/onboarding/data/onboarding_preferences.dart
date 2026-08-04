import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the user has already completed the onboarding/intro
/// flow, so it's only ever shown once — on the very first app launch.
///
/// Kept as a small repository (data layer) so the presentation layer
/// (main.dart) never talks to SharedPreferences directly.
class OnboardingPreferences {
  static const _hasCompletedKey = 'has_completed_onboarding';

  /// Returns true if the user has already been through onboarding before.
  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedKey) ?? false;
  }

  /// Marks onboarding as completed so it won't be shown again.
  Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedKey, true);
  }
}
