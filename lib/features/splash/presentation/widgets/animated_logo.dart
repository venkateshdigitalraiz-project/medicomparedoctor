import 'package:flutter/material.dart';

import '../controllers/splash_animation_controller.dart';

/// Renders the MediCompares logo exactly as supplied (no color/shape
/// changes), applying only the Stage 4 subtle horizontal shake on top.
/// Logo art itself is untouched — swap [logoAssetPath] for your real asset.
class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required this.animations,
    required this.controller,
    this.width = 220,
    this.logoAssetPath = 'assets/images/applogo.png',
  });

  final SplashAnimationController animations;
  final AnimationController controller;
  final double width;
  final String logoAssetPath;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Amplitude scales with screen width so the shake reads as
        // "subtle" consistently across phones and tablets.
        final amplitude = MediaQuery.of(context).size.width * 0.012;
        final shakeX = animations.logoShakeOffset(controller.value, amplitude);

        return Transform.translate(
          offset: Offset(shakeX, 0),
          child: Image.asset(logoAssetPath, width: width, fit: BoxFit.contain),
        );
      },
    );
  }
}
