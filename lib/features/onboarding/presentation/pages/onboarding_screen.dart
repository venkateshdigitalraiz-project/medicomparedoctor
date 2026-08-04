import 'package:flutter/material.dart';

import '../../domain/onboarding_page_data.dart';
import '../widgets/onboarding_page_view.dart';

/// The 3-page intro/onboarding flow shown right after the splash screen.
///
/// Page-to-page transitions use [PageView]'s own built-in animation
/// (driven by [PageController.nextPage] / `previousPage`), eased with
/// `Curves.easeInOutCubic` — still 100% native Flutter, no packages.
///
/// The *entrance* of this whole screen (sliding down from off-screen right
/// after the splash finishes) is handled one level up, by the custom
/// `PageRouteBuilder` used to push [OnboardingScreen] — see `main.dart`.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  /// Called when the user finishes the intro flow — either by tapping
  /// "Skip" on any page that shows it, or by tapping the next arrow on
  /// the final page.
  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pageTransitionDuration = Duration(milliseconds: 450);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: _pageTransitionDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  void _handleBack() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    } else {
      Navigator.maybePop(context);
    }
  }

  void _handleNext() {
    if (_currentPage < kOnboardingPages.length - 1) {
      _goToPage(_currentPage + 1);
    } else {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      itemCount: kOnboardingPages.length,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemBuilder: (context, index) {
        final data = kOnboardingPages[index];
        return OnboardingPageView(
          data: data,
          onBack: _handleBack,
          onSkip: widget.onFinished,
          onNext: _handleNext,
        );
      },
    );
  }
}
