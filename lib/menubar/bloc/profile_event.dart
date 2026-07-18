part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the Profile/Menu screen is first built.
class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

/// User tapped one of the menu rows (Availability, Clinic Info, etc.).
class ProfileMenuItemTapped extends ProfileEvent {
  final String itemId;
  const ProfileMenuItemTapped(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// User tapped the notification bell in the header.
class ProfileNotificationsTapped extends ProfileEvent {
  const ProfileNotificationsTapped();
}

/// User tapped the settings gear in the header.
class ProfileSettingsTapped extends ProfileEvent {
  const ProfileSettingsTapped();
}

/// Fired by the UI right after it has reacted to `navigationTarget`
/// (e.g. shown a snackbar or navigated), so the transient value is cleared
/// and doesn't re-trigger on the next rebuild.
class ProfileNavigationHandled extends ProfileEvent {
  const ProfileNavigationHandled();
}
