import 'package:equatable/equatable.dart';
import 'package:medicompare/dup_profile/model/user_profile_model.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial / loading state while the profile is being fetched.
class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

/// Emitted if fetching the profile fails.
class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Main loaded state driving the whole screen.
class UserProfileLoaded extends UserProfileState {
  final UserProfileModel profile;
  final Set<UserProfileSection> expandedSections;
  final UserBottomNavItem selectedNavItem;

  const UserProfileLoaded({
    required this.profile,
    required this.expandedSections,
    required this.selectedNavItem,
  });

  bool isExpanded(UserProfileSection section) =>
      expandedSections.contains(section);

  UserProfileLoaded copyWith({
    UserProfileModel? profile,
    Set<UserProfileSection>? expandedSections,
    UserBottomNavItem? selectedNavItem,
  }) {
    return UserProfileLoaded(
      profile: profile ?? this.profile,
      expandedSections: expandedSections ?? this.expandedSections,
      selectedNavItem: selectedNavItem ?? this.selectedNavItem,
    );
  }

  @override
  List<Object?> get props => [profile, expandedSections, selectedNavItem];
}
