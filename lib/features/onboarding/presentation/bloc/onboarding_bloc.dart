import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/onboarding/data/onboarding_preferences.dart';
import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_state.dart';

/// Bloc handling onboarding flow.
///
/// It checks whether onboarding has been completed and persists the
/// completion flag. The UI reacts to the emitted states via a
/// [BlocListener] in `main.dart`.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingPreferences _preferences = OnboardingPreferences();

  OnboardingBloc() : super(const OnboardingInitial()) {
    on<CheckOnboardingStatus>(_onCheckStatus);
    on<CompleteOnboarding>(_onComplete);
  }

  Future<void> _onCheckStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    final completed = await _preferences.hasCompletedOnboarding();
    emit(OnboardingChecked(isCompleted: completed));
  }

  Future<void> _onComplete(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await _preferences.markOnboardingCompleted();
    emit(const OnboardingCompleted());
  }
}
