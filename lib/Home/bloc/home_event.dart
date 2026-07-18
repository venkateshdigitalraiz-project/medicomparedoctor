part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the Home screen is first built.
class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// Fired on pull-to-refresh.
class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

/// User typed into the search field.
class HomeSearchChanged extends HomeEvent {
  final String query;
  const HomeSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// User switched between Overview / Appointments / Actions tabs.
class HomeTabChanged extends HomeEvent {
  final HomeTab tab;
  const HomeTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

/// User tapped the bottom navigation bar.
class HomeBottomNavChanged extends HomeEvent {
  final int index;
  const HomeBottomNavChanged(this.index);

  @override
  List<Object?> get props => [index];
}
