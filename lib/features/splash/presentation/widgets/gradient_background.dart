import 'package:flutter/material.dart';

import '../controllers/splash_animation_controller.dart';

/// Renders the full-screen animated background.
///
/// Reads the current decoration straight from [SplashAnimationController],
/// so this widget stays a pure "dumb" presentation layer with zero
/// animation math of its own.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.animations,
    required this.controller,
  });

  final SplashAnimationController animations;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          decoration: animations.backgroundDecoration(controller.value),
        );
      },
    );
  }
}
