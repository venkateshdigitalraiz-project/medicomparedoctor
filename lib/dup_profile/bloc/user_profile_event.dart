import 'package:equatable/equatable.dart';
import 'package:medicompare/dup_profile/model/user_profile_model.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen first loads, to fetch the profile.
class UserProfileStarted extends UserProfileEvent {
  const UserProfileStarted();
}

/// Expands/collapses one of the collapsible sections.
class UserProfileSectionToggled extends UserProfileEvent {
  final UserProfileSection section;

  const UserProfileSectionToggled(this.section);

  @override
  List<Object?> get props => [section];
}

/// Fired when the user taps a bottom navigation item.
class UserBottomNavTapped extends UserProfileEvent {
  final UserBottomNavItem item;

  const UserBottomNavTapped(this.item);

  @override
  List<Object?> get props => [item];
}

/// Fired when the user taps the edit (pencil) icon in the app bar.
class UserProfileEditRequested extends UserProfileEvent {
  const UserProfileEditRequested();
}
