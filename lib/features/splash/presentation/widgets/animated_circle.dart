import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../controllers/splash_animation_controller.dart';

/// The white circle that slides in from the top, expands dramatically,
/// and finally fades away — driven entirely by [SplashAnimationController].
class AnimatedCircle extends StatelessWidget {
  const AnimatedCircle({
    super.key,
    required this.animations,
    required this.controller,
    required this.diameter,
  });

  final SplashAnimationController animations;
  final AnimationController controller;

  /// Base diameter of the circle at scale = 1.0 (before Stage 3 zoom).
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        final screenSize = MediaQuery.of(context).size;
        final screenHeight = screenSize.height;

        // Target scale = however much the base diameter needs to grow to
        // exactly span the screen's width. Computed live (not hardcoded)
        // so it stays correct across every device size.
        final targetScale = screenSize.width / diameter;

        final offsetY = animations.circleOffsetY(t); // fraction of screen height
        final scale = animations.circleScale(t, targetScale);
        final opacity = animations.circleOpacity(t);
        final shadowOpacity = animations.circleShadowOpacity(t);
        final glow = animations.glowOpacity(t);

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.translate(
            // Slides the whole circle (Stage 2); resolves to 0 afterward.
            offset: Offset(0, offsetY * screenHeight),
            child: Transform.scale(
              // Dramatic zoom-out effect (Stage 3).
              scale: scale,
              child: Container(
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.splashWhite,
                  boxShadow: [
                    // Soft glow behind the expanding circle.
                    BoxShadow(
                      color: AppColors.glowColor.withOpacity(glow.clamp(0.0, 1.0)),
                      blurRadius: diameter * 0.6,
                      spreadRadius: diameter * 0.1,
                    ),
                    // Standard drop shadow, lightening as the circle grows.
                    BoxShadow(
                      color: Colors.black.withOpacity(shadowOpacity.clamp(0.0, 1.0)),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
