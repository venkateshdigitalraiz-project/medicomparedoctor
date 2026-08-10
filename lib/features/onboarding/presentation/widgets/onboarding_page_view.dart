import 'package:flutter/material.dart';

import 'package:medicompare/core/constants/app_colors.dart';
import 'package:medicompare/features/onboarding/domain/onboarding_page_data.dart';
import 'package:medicompare/features/onboarding/presentation/widgets/curved_clippers.dart';

/// A single onboarding/intro page: hero illustration up top on white,
/// a curved purple footer with title + description below, an optional
/// "Skip" text button, and the circular "next" arrow button.
///
/// Content animates into position **sequentially** whenever the page
/// appears: illustration first, then the title, then the description,
/// then the Skip/Next controls — each fading + sliding up into place with
/// a staggered start, all driven by one [AnimationController] so it stays
/// smooth and easy to reason about.
///
/// Page-to-page *navigation* still lives in `OnboardingScreen`, which owns
/// the [PageController]; this widget only owns its own entrance animation.
class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({
    super.key,
    required this.data,
    required this.onBack,
    required this.onSkip,
    required this.onNext,
  });

  final OnboardingPageData data;
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  // Staggered start/end points (as fractions of the entrance duration)
  // for each element — each interval overlaps the next slightly so the
  // sequence reads as one continuous flow rather than four separate hops.
  static const _illustrationInterval = Interval(0.0, 0.55, curve: Curves.easeInOutCubic);
  static const _titleInterval = Interval(0.2, 0.7, curve: Curves.easeInOutCubic);
  static const _descriptionInterval = Interval(0.35, 0.85, curve: Curves.easeInOutCubic);
  static const _footerInterval = Interval(0.55, 1.0, curve: Curves.easeInOutCubic);

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  /// Builds a fade + slide-up entrance for [child], staggered by [interval].
  Widget _staggered(Widget child, Interval interval) {
    final fade = CurvedAnimation(parent: _entrance, curve: interval);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(fade);

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final clipper = data.curveStyle == OnboardingCurveStyle.hill
        ? const HillClipper()
        : const WaveClipper();

    return Scaffold(
      backgroundColor: AppColors.splashWhite,
      body: Column(
        children: [
          // ---- Top: illustration + back arrow -------------------------
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
                    child: _staggered(
                      Image.asset(
                        data.illustrationAsset,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                      _illustrationInterval,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 8,
                  child: SafeArea(
                    bottom: false,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: widget.onBack,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---- Bottom: curved purple footer with copy + controls ------
          Expanded(
            flex: 5,
            child: ClipPath(
              clipper: clipper,
              child: Container(
                width: double.infinity,
                color: AppColors.brandPurple,
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _staggered(
                          Text(
                            data.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          _titleInterval,
                        ),
                        const SizedBox(height: 16),
                        _staggered(
                          Text(
                            data.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          _descriptionInterval,
                        ),
                      ],
                    ),
                    _staggered(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (data.showSkip)
                            TextButton(
                              onPressed: widget.onSkip,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          _NextButton(onPressed: widget.onNext),
                        ],
                      ),
                      _footerInterval,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular outlined "next" button matching the reference design.
class _NextButton extends StatelessWidget {
  const _NextButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
      ),
    );
  }
}
