import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/dup_profile/model/user_profile_model.dart';
import 'package:medicompare/dup_profile/bloc/user_profile_state.dart';
import 'user_profile_event.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(const UserProfileLoading()) {
    on<UserProfileStarted>(_onStarted);
    on<UserProfileSectionToggled>(_onSectionToggled);
    on<UserBottomNavTapped>(_onBottomNavTapped);
    on<UserProfileEditRequested>(_onEditRequested);
  }

  Future<void> _onStarted(
    UserProfileStarted event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(const UserProfileLoading());
    try {
      // Simulated network/repository call.
      await Future.delayed(const Duration(milliseconds: 300));
      final profile = UserProfileModel.mock();
      emit(
        UserProfileLoaded(
          profile: profile,
          // Personal Information starts expanded, matching the design.
          expandedSections: const {UserProfileSection.personalInformation},
          selectedNavItem: UserBottomNavItem.profile,
        ),
      );
    } catch (e) {
      emit(UserProfileError('Failed to load profile: $e'));
    }
  }

  void _onSectionToggled(
    UserProfileSectionToggled event,
    Emitter<UserProfileState> emit,
  ) {
    final current = state;
    if (current is! UserProfileLoaded) return;

    final expanded = Set<UserProfileSection>.from(current.expandedSections);
    if (expanded.contains(event.section)) {
      expanded.remove(event.section);
    } else {
      expanded.add(event.section);
    }
    emit(current.copyWith(expandedSections: expanded));
  }

  void _onBottomNavTapped(
    UserBottomNavTapped event,
    Emitter<UserProfileState> emit,
  ) {
    final current = state;
    if (current is! UserProfileLoaded) return;
    emit(current.copyWith(selectedNavItem: event.item));
  }

  void _onEditRequested(
    UserProfileEditRequested event,
    Emitter<UserProfileState> emit,
  ) {
    // Hook point for navigating to an "Edit Profile" screen.
    // Left as a no-op here since it's outside the scope of this screen.
  }
}
