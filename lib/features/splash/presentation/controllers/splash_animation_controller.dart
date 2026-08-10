import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';

/// Encapsulates every piece of animation math for the splash screen.
class SplashAnimationController {
  SplashAnimationController({required TickerProvider vsync})
    : controller = AnimationController(
        vsync: vsync,
        duration: AppDurations.totalSplashDuration,
      );

  /// The single controller driving the entire splash sequence.
  final AnimationController controller;

  /// Starts the splash sequence from the beginning.
  TickerFuture play() => controller.forward(from: 0.0);

  void dispose() => controller.dispose();

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------

  /// Maps the global timeline value [t] into a local, eased 0..1 progress
  /// for the stage spanning [start]..[end].
  double _stageProgress(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    final local = (t - start) / (end - start);
    return Curves.easeInOutCubic.transform(local);
  }

  // ---------------------------------------------------------------------
  // STAGE 2 (2s - 4s): circle slides from above the screen to center.
  // ---------------------------------------------------------------------

  double circleOffsetY(double t) {
    final p = _stageProgress(
      t,
      AppDurations.stage2Start,
      AppDurations.stage2End,
    );
    return Tween<double>(begin: -1.4, end: 0.0).transform(p);
  }

  // ---------------------------------------------------------------------
  // STAGE 3 (4s - 6s): circle zooms outward dramatically.
  // ---------------------------------------------------------------------

  double circleScale(double t, double targetScale) {
    final p = _stageProgress(
      t,
      AppDurations.stage3Start,
      AppDurations.stage3HoldStart,
    );
    return Tween<double>(begin: 1.0, end: targetScale).transform(p);
  }

  double circleShadowOpacity(double t) {
    final p = _stageProgress(
      t,
      AppDurations.stage3Start,
      AppDurations.stage3HoldStart,
    );
    return Tween<double>(begin: 0.35, end: 0.05).transform(p);
  }

  double glowOpacity(double t) {
    if (t < AppDurations.stage3Start) return 0.0;
    if (t < AppDurations.stage3HoldStart) {
      final p = _stageProgress(
        t,
        AppDurations.stage3Start,
        AppDurations.stage3HoldStart,
      );
      return Tween<double>(begin: 0.0, end: 0.6).transform(p);
    }
    if (t < AppDurations.stage4Start) return 0.6;
    final p4 = _stageProgress(
      t,
      AppDurations.stage4Start,
      AppDurations.stage4TransitionEnd,
    );
    return Tween<double>(begin: 0.6, end: 0.0).transform(p4);
  }

  // ---------------------------------------------------------------------
  // Circle opacity: fades out over Stage 4 Transition (6s - 8s).
  // ---------------------------------------------------------------------

  double circleOpacity(double t) {
    const fadeInEnd = AppDurations.stage2Start + 0.02;

    if (t < AppDurations.stage2Start) return 0.0;

    if (t < fadeInEnd) {
      final local =
          (t - AppDurations.stage2Start) /
          (fadeInEnd - AppDurations.stage2Start);
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).transform(Curves.easeInOutCubic.transform(local));
    }

    if (t < AppDurations.stage4Start) return 1.0;

    final p4 = _stageProgress(
      t,
      AppDurations.stage4Start,
      AppDurations.stage4TransitionEnd,
    );
    return Tween<double>(begin: 1.0, end: 0.0).transform(p4);
  }

  // ---------------------------------------------------------------------
  // STAGE 4 Part 2 (8s - 10s): subtle vertical shake on the logo.
  // ---------------------------------------------------------------------

  double _rawStageProgress(double t, double start, double end) {
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return (t - start) / (end - start);
  }

  double logoShakeOffset(double t, double amplitude) {
    if (t < AppDurations.stage4TransitionEnd) return 0.0;
    final rawP = _rawStageProgress(
      t,
      AppDurations.stage4TransitionEnd,
      AppDurations.stage4End,
    );
    final envelope = Tween<double>(
      begin: amplitude,
      end: 0.0,
    ).transform(Curves.easeInOutCubic.transform(rawP));
    const cycles = 4;
    final oscillation = math.sin(rawP * cycles * 2 * math.pi);
    return envelope * oscillation;
  }

  double logoScaleY(double t) => 1.0;

  // ---------------------------------------------------------------------
  // Background decoration.
  // ---------------------------------------------------------------------

  BoxDecoration backgroundDecoration(double t) {
    const white = AppColors.splashWhite;
    const purple = AppColors.brandPurple;

    if (t < AppDurations.stage1End) {
      return const BoxDecoration(color: white);
    }

    if (t < AppDurations.stage2End) {
      final p = _stageProgress(
        t,
        AppDurations.stage2Start,
        AppDurations.stage2End,
      );
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

    if (t < AppDurations.stage3End) {
      final p = _stageProgress(
        t,
        AppDurations.stage3Start,
        AppDurations.stage3HoldStart,
      );
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

    if (t < AppDurations.stage4TransitionEnd) {
      final p = _stageProgress(
        t,
        AppDurations.stage4Start,
        AppDurations.stage4TransitionEnd,
      );
      final color = Color.lerp(purple, white, p)!;
      return BoxDecoration(color: color);
    }

    return const BoxDecoration(color: white);
  }
}
