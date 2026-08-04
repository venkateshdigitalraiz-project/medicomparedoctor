import 'package:equatable/equatable.dart';

/// Base class for all onboarding events.
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check the onboarding completion status.
class CheckOnboardingStatus extends OnboardingEvent {
  const CheckOnboardingStatus();
}

/// Event to mark onboarding as completed.
class CompleteOnboarding extends OnboardingEvent {
  const CompleteOnboarding();
}
