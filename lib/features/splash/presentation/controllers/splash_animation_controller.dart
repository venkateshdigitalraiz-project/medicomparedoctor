import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';

/// Encapsulates every piece of animation math for the splash screen.
///
/// This class deliberately contains **no widgets** — it only owns the
/// driving [AnimationController] and exposes pure functions that turn the
/// controller's current `t` (0..1 over the full 8s timeline) into concrete
/// values (offsets, scales, opacities, decorations) that the widget layer
/// consumes inside an [AnimatedBuilder]. This separation is what keeps the
/// architecture clean: animation *logic* lives here, animation
/// *presentation* lives in the widgets.
class SplashAnimationController {
  SplashAnimationController({required TickerProvider vsync})
      : controller = AnimationController(
          vsync: vsync,
          duration: AppDurations.totalSplashDuration,
        );

  /// The single controller driving the entire 8-second sequence.
  final AnimationController controller;

  /// Starts the splash sequence from the beginning.
  TickerFuture play() => controller.forward(from: 0.0);

  void dispose() => controller.dispose();

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------

  /// Maps the global timeline value [t] into a local, eased 0..1 progress
  /// for the stage spanning [start]..[end]. Returns 0.0 before the stage
  /// starts and 1.0 after it ends, so values driven by this function hold
  /// steady outside of their stage instead of jumping.
  double _stageProgress(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    final local = (t - start) / (end - start);
    return Curves.easeInOutCubic.transform(local);
  }

  // ---------------------------------------------------------------------
  // STAGE 2 (0.25 - 0.5): circle slides from above the screen to center.
  // ---------------------------------------------------------------------

  /// Vertical offset of the circle, expressed as a fraction of screen
  /// height. -1.4 = well above the top edge, 0.0 = resting in place.
  double circleOffsetY(double t) {
    final p = _stageProgress(t, AppDurations.stage2Start, AppDurations.stage2End);
    return Tween<double>(begin: -1.4, end: 0.0).transform(p);
  }

  // ---------------------------------------------------------------------
  // STAGE 3 (0.5 - 0.75): circle zooms outward dramatically.
  // ---------------------------------------------------------------------

  /// Scale multiplier applied to the circle. Stays at 1.0 through stages
  /// 1-2, expands to [targetScale] (enough for the circle to cover the
  /// full screen width — computed by the widget from actual screen size)
  /// over the FIRST HALF of stage 3 (4s-5s), then holds steady at
  /// [targetScale] for the remaining second (5s-6s) before fading out
  /// in stage 4.
  double circleScale(double t, double targetScale) {
    final p = _stageProgress(t, AppDurations.stage3Start, AppDurations.stage3HoldStart);
    return Tween<double>(begin: 1.0, end: targetScale).transform(p);
  }

  /// Shadow strength behind the circle: builds up as it starts expanding,
  /// gets progressively lighter as it grows, then stays light through the
  /// 1s hold.
  double circleShadowOpacity(double t) {
    final p = _stageProgress(t, AppDurations.stage3Start, AppDurations.stage3HoldStart);
    return Tween<double>(begin: 0.35, end: 0.05).transform(p);
  }

  /// Soft glow rendered behind the circle. Fades in while the circle is
  /// expanding, stays steady through the 1s hold, then fades back out
  /// during stage 4 alongside the circle itself.
  double glowOpacity(double t) {
    if (t < AppDurations.stage3Start) return 0.0;
    if (t < AppDurations.stage3HoldStart) {
      final p = _stageProgress(t, AppDurations.stage3Start, AppDurations.stage3HoldStart);
      return Tween<double>(begin: 0.0, end: 0.6).transform(p);
    }
    if (t < AppDurations.stage4Start) return 0.6;
    final p4 = _stageProgress(t, AppDurations.stage4Start, AppDurations.stage4End);
    return Tween<double>(begin: 0.6, end: 0.0).transform(p4);
  }

  // ---------------------------------------------------------------------
  // Circle opacity across stages 1, 2/3 (visible) and 4 (fade out).
  // ---------------------------------------------------------------------

  double circleOpacity(double t) {
    const fadeInEnd = AppDurations.stage2Start + 0.02; // quick reveal as it enters

    if (t < AppDurations.stage2Start) return 0.0;

    if (t < fadeInEnd) {
      final local = (t - AppDurations.stage2Start) / (fadeInEnd - AppDurations.stage2Start);
      return Tween<double>(begin: 0.0, end: 1.0)
          .transform(Curves.easeInOutCubic.transform(local));
    }

    if (t < AppDurations.stage4Start) return 1.0;

    final p4 = _stageProgress(t, AppDurations.stage4Start, AppDurations.stage4End);
    return Tween<double>(begin: 1.0, end: 0.0).transform(p4);
  }

  // ---------------------------------------------------------------------
  // STAGE 4 (0.75 - 1.0): subtle horizontal shake on the logo.
  // ---------------------------------------------------------------------

  /// Linear (un-eased) local progress through [start]..[end]. Used only
  /// for the shake's oscillation phase, so the wobble frequency stays
  /// even instead of being distorted by an ease curve.
  double _rawStageProgress(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  /// Horizontal shake offset for the logo, in logical pixels.
  ///
  /// [amplitude] is the peak offset (computed by the widget from screen
  /// width, so it scales sensibly across devices). The shake oscillates
  /// a few times then settles back to 0 exactly as stage 4 ends —
  /// the oscillation phase uses raw linear progress (even wobble timing)
  /// while the amplitude envelope itself eases out with
  /// Curves.easeInOutCubic.
  double logoShakeOffset(double t, double amplitude) {
    final rawP = _rawStageProgress(t, AppDurations.stage4Start, AppDurations.stage4End);
    final envelope = Tween<double>(begin: amplitude, end: 0.0).transform(Curves.easeInOutCubic.transform(rawP));
    const cycles = 4; // number of full left-right wobbles across the stage
    final oscillation = math.sin(rawP * cycles * 2 * math.pi);
    return envelope * oscillation;
  }

  /// Vertical scaling factor for the logo during stage 4.
  ///
  /// Returns 1.0 before stage 4 starts, then linearly (eased) shrinks to
  /// 0.5 by the end of the animation. Adjust the `end` value to change the
  /// final scale.
  double logoScaleY(double t) {
    if (t < AppDurations.stage4Start) return 1.0;
    final p = _stageProgress(t, AppDurations.stage4Start, AppDurations.stage4End);
    return Tween<double>(begin: 1.0, end: 0.5).transform(p);
  }


  // ---------------------------------------------------------------------
  // Background decoration across all 4 stages.
  // ---------------------------------------------------------------------

  /// Returns the full background [BoxDecoration] for the current timeline
  /// value [t]:
  ///  - Stage 1 (0-2s):  solid white.
  ///  - Stage 2 (2-4s):  eases from solid white into a vertical linear
  ///                     gradient — purple at the top, white in the
  ///                     middle, purple at the bottom.
  ///  - Stage 3 (4-6s):  the white middle band closes into solid purple
  ///                     exactly as the circle finishes expanding (4-5s),
  ///                     then holds as solid purple (#601CA3) for the
  ///                     remaining second (5-6s).
  ///  - Stage 4 (6-8s):  eases solid purple back to solid white.
  BoxDecoration backgroundDecoration(double t) {
    const white = AppColors.splashWhite;
    const purple = AppColors.brandPurple;

    // Stage 1: flat white.
    if (t < AppDurations.stage1End) {
      return const BoxDecoration(color: white);
    }

    // Stage 2: solid white -> [purple, white, purple] linear gradient.
    if (t < AppDurations.stage2End) {
      final p = _stageProgress(t, AppDurations.stage2Start, AppDurations.stage2End);
      final edge = Color.lerp(white, purple, p)!;
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [edge, white, edge],
          stops: const [0.0, 0.5, 1.0],
        ),
      );
    }

    // Stage 3: white middle band closes to solid purple (synced with the
    // circle's expansion), then holds solid through the 1s hold window.
    if (t < AppDurations.stage3End) {
      final p = _stageProgress(t, AppDurations.stage3Start, AppDurations.stage3HoldStart);
      final middle = Color.lerp(white, purple, p)!;
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [purple, middle, purple],
          stops: const [0.0, 0.5, 1.0],
        ),
      );
    }

    // Stage 4: solid purple -> solid white.
    final p = _stageProgress(t, AppDurations.stage4Start, AppDurations.stage4End);
    final color = Color.lerp(purple, white, p)!;
    return BoxDecoration(color: color);
  }
}
