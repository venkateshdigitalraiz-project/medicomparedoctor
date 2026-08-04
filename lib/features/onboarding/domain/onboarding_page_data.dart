/// Which purple curve shape a page's footer uses. Kept as an enum so the
/// widget layer can pick the right [CustomClipper] without hardcoding
/// per-index logic all over the place.
enum OnboardingCurveStyle {
  /// Smooth symmetric hill — used by the first intro page.
  hill,

  /// Diagonal wave rising from bottom-left to top-right — used by the
  /// following intro pages.
  wave,
}

/// Immutable content for a single onboarding/intro page.
class OnboardingPageData {
  const OnboardingPageData({
    required this.illustrationAsset,
    required this.title,
    required this.description,
    required this.curveStyle,
    required this.showSkip,
  });

  /// Path to the page's hero illustration (doctor + phone mockup art).
  final String illustrationAsset;

  final String title;
  final String description;
  final OnboardingCurveStyle curveStyle;

  /// Whether the "Skip" text button is shown on this page (per the
  /// reference design, the first page has no Skip button; the following
  /// pages do).
  final bool showSkip;
}

/// The 3 intro pages, in order, matching the reference designs exactly.
const List<OnboardingPageData> kOnboardingPages = [
  OnboardingPageData(
    illustrationAsset: 'assets/images/applogo.png',
    title: 'Measure, Analyze, Improve',
    description:
        'Access real-time insights on appointments, patient engagement, '
        'and clinic performance anytime.',
    curveStyle: OnboardingCurveStyle.hill,
    showSkip: false,
  ),
  OnboardingPageData(
    illustrationAsset: 'assets/images/applogo.png',
    title: 'Smart Scheduling for Busy Doctors',
    description:
        'Customize availability, block holidays, and organize '
        'consultations with an intelligent calendar.',
    curveStyle: OnboardingCurveStyle.wave,
    showSkip: true,
  ),
  OnboardingPageData(
    illustrationAsset: 'assets/images/applogo.png',
    title: 'Your Practice, Simplified',
    description:
        'Manage appointments, patient visits, and daily schedules '
        'effortlessly from a single App.',
    curveStyle: OnboardingCurveStyle.wave,
    showSkip: true,
  ),
];
