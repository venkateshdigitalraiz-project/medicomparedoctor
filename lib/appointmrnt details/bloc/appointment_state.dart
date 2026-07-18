import 'package:equatable/equatable.dart';
import 'package:medicompare/appointmrnt%20details/model/appointment_model.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentLoading extends AppointmentState {
  const AppointmentLoading();
}

class AppointmentLoaded extends AppointmentState {
  final AppointmentModel appointment;
  final String? lastActionMessage;

  const AppointmentLoaded(this.appointment, {this.lastActionMessage});

  AppointmentLoaded copyWith({
    AppointmentModel? appointment,
    String? lastActionMessage,
  }) {
    return AppointmentLoaded(
      appointment ?? this.appointment,
      lastActionMessage: lastActionMessage,
    );
  }

  @override
  List<Object?> get props => [appointment, lastActionMessage];
}

class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}
