import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:medicompare/features/patients/data/models/patient_filter.dart';

abstract class PatientsEvent extends Equatable {
  const PatientsEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen loads or pull-to-refresh is executed to fetch the initial patient list.
class PatientsLoadRequested extends PatientsEvent {
  final Completer<void>? completer;
  const PatientsLoadRequested({this.completer});

  @override
  List<Object?> get props => [completer];
}

/// Fired when the user scrolls to the bottom of the screen to load the next page of patients.
class PatientsLoadMoreRequested extends PatientsEvent {
  const PatientsLoadMoreRequested();
}

/// Fired when the user taps a filter chip (All / Completed / Waiting / Cancel).
class PatientsFilterChanged extends PatientsEvent {
  final PatientFilter filter;
  const PatientsFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Fired when the user types in the search bar.
class PatientsSearchChanged extends PatientsEvent {
  final String query;
  const PatientsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
