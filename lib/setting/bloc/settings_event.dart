import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps the "Log Out" button.
class LogoutRequested extends SettingsEvent {
  const LogoutRequested();
}

/// Fired when the user taps a settings row (Privacy Policy, Language, Help & Support).
class SettingsItemTapped extends SettingsEvent {
  final String itemKey;

  const SettingsItemTapped(this.itemKey);

  @override
  List<Object?> get props => [itemKey];
}

/// Resets the status back to initial, e.g. after a snackbar/dialog is dismissed.
class SettingsStatusReset extends SettingsEvent {
  const SettingsStatusReset();
}
