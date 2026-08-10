import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loggingOut, loggedOut, navigating }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final String? activeItemKey;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.activeItemKey,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    String? activeItemKey,
  }) {
    return SettingsState(
      status: status ?? this.status,
      activeItemKey: activeItemKey ?? this.activeItemKey,
    );
  }

  @override
  List<Object?> get props => [status, activeItemKey];
}
