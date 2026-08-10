/// All durations for the splash animation sequence in one place.
///
/// The 4 stages are expressed both as absolute durations (for readability /
/// product-spec traceability) and as normalized [0,1] progress boundaries
/// (used internally by the animation controller, since a single
/// [AnimationController] drives the whole timeline).
class AppDurations {
  const AppDurations._();

  // ---- Absolute stage durations -----------------------
  static const Duration stage1Duration = Duration(seconds: 2); // static hold
  static const Duration stage2Duration = Duration(seconds: 2); // slide in
  static const Duration stage3Duration = Duration(seconds: 2); // zoom out
  static const Duration stage4Duration = Duration(seconds: 4); // fade out (2s) + shake (2s)

  /// Total duration of the driving AnimationController (2+2+2+4 = 10s).
  static const Duration totalSplashDuration = Duration(milliseconds: 10000);

  /// Delay after the animation completes and before navigating away.
  static const Duration postAnimationDelay = Duration(milliseconds: 500);

  // ---- Normalized stage boundaries (fractions of totalSplashDuration) --
  static const double stage1Start = 0.0;
  static const double stage1End = 0.2; // 0s - 2s
  static const double stage2Start = 0.2;
  static const double stage2End = 0.4; // 2s - 4s
  static const double stage3Start = 0.4;
  static const double stage3End = 0.6; // 4s - 6s

  /// Midpoint of stage 3: the circle finishes expanding to full screen width here (5s).
  static const double stage3HoldStart = 0.5;
  static const double stage4Start = 0.6; // 6s
  static const double stage4TransitionEnd = 0.8; // 8s
  static const double stage4End = 1.0; // 10s
}
