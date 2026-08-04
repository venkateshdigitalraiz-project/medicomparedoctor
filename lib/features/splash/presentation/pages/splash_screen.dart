import 'package:flutter/material.dart';

import '../../../../core/constants/app_durations.dart';
import '../controllers/splash_animation_controller.dart';
import '../widgets/animated_circle.dart';
import '../widgets/animated_logo.dart';
import '../widgets/gradient_background.dart';

/// Premium 4-stage animated splash screen for MediCompares.
///
/// Stage 1 (0-2s):  static logo on a pure white background.
/// Stage 2 (2-4s):  a white circle slides down from off-screen to center
///                  as the background eases from white to solid purple.
/// Stage 3 (4-6s):  the circle zooms outward (~8x) with a soft glow while
///                  the background eases into a purple/white gradient.
/// Stage 4 (6-8s):  the circle fades away, the background returns to pure
///                  white, and the logo performs a subtle horizontal
///                  shake that settles back to center.
///
/// After the full 8s sequence plus a 500ms pause, [onFinished] is invoked
/// so the caller can navigate to Home or Login depending on auth state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onFinished,
    this.logoAssetPath = 'assets/images/applogo.png',
  });

  /// Called once the splash sequence (including the trailing 500ms delay)
  /// has fully completed. Typically used to push the Home or Login route:
  ///
  /// ```dart
  /// SplashScreen(
  ///   onFinished: () {
  ///     Navigator.of(context).pushReplacement(
  ///       MaterialPageRoute(
  ///         builder: (_) => isAuthenticated ? const HomeScreen() : const LoginScreen(),
  ///       ),
  ///     );
  ///   },
  /// )
  /// ```
  final VoidCallback onFinished;

  /// Path to the MediCompares logo asset. Must be registered under
  /// `flutter: assets:` in pubspec.yaml.
  final String logoAssetPath;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashAnimationController _animations;

  @override
  void initState() {
    super.initState();
    _animations = SplashAnimationController(vsync: this);
    _runSequence();
  }

  Future<void> _runSequence() async {
    await _animations.play();
    if (!mounted) return;
    await Future.delayed(AppDurations.postAnimationDelay);
    if (!mounted) return;
    widget.onFinished();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive base circle diameter: roughly matches the logo's
          // footprint in the design (~34% of the shorter screen dimension)
          // so it looks correct on phones and tablets alike.
          final shortestSide = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;
          final circleDiameter = shortestSide * 0.34;
          final logoWidth = constraints.maxWidth * 0.56;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Stage-aware animated background (white -> purple -> gradient -> white).
              GradientBackground(
                animations: _animations,
                controller: _animations.controller,
              ),

              // Circle + logo positioned slightly below true center, matching
              // the reference design exactly.
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedCircle(
                      animations: _animations,
                      controller: _animations.controller,
                      diameter: circleDiameter,
                    ),
                    AnimatedLogo(
                      animations: _animations,
                      controller: _animations.controller,
                      width: logoWidth,
                      logoAssetPath: widget.logoAssetPath,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
