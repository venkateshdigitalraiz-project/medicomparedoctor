import 'package:equatable/equatable.dart';

/// Base class for all onboarding states.
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any check has been performed.
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// Emitted after reading SharedPreferences.
///
/// [isCompleted] = `true`  → skip intro, go directly to Calendar.
/// [isCompleted] = `false` → show intro flow starting from Intro1.
class OnboardingChecked extends OnboardingState {
  const OnboardingChecked({required this.isCompleted});

  final bool isCompleted;

  @override
  List<Object?> get props => [isCompleted];
}

/// Emitted after the user finishes or skips onboarding and the flag has
/// been persisted to SharedPreferences.
class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}
