import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen is first built.
class LoadNotifications extends NotificationEvent {
  const LoadNotifications();
}

/// Fired on pull-to-refresh.
class RefreshNotifications extends NotificationEvent {
  const RefreshNotifications();
}

/// Fired when the user taps the overflow (⋮) menu -> "Remove".
class DismissNotification extends NotificationEvent {
  final String id;
  const DismissNotification(this.id);

  @override
  List<Object?> get props => [id];
}
