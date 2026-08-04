/// All durations for the splash animation sequence in one place.
///
/// The 4 stages are expressed both as absolute durations (for readability /
/// product-spec traceability) and as normalized [0,1] progress boundaries
/// (used internally by the animation controller, since a single
/// [AnimationController] drives the whole 8-second timeline).
class AppDurations {
  const AppDurations._();

  // ---- Absolute stage durations (spec: 2s each) -----------------------
  static const Duration stage1Duration = Duration(seconds: 2); // static hold
  static const Duration stage2Duration = Duration(seconds: 2); // slide in
  static const Duration stage3Duration = Duration(seconds: 2); // zoom out
  static const Duration stage4Duration = Duration(seconds: 2); // fade + breathe

  /// Total duration of the driving AnimationController (2+2+2+2 = 8s).
  static const Duration totalSplashDuration = Duration(
    milliseconds: 8000,
  );

  /// Delay after the animation completes and before navigating away.
  static const Duration postAnimationDelay = Duration(milliseconds: 500);

  // ---- Normalized stage boundaries (fractions of totalSplashDuration) --
  static const double stage1Start = 0.0;
  static const double stage1End = 0.25; // 0s - 2s
  static const double stage2Start = 0.25;
  static const double stage2End = 0.5; // 2s - 4s
  static const double stage3Start = 0.5;
  static const double stage3End = 0.75; // 4s - 6s

  /// Midpoint of stage 3: the circle finishes expanding to full screen
  /// width here (5s), then holds steady for the remaining 1 second (5s-6s).
  static const double stage3HoldStart = 0.625;
  static const double stage4Start = 0.75;
  static const double stage4End = 1.0; // 6s - 8s
}
