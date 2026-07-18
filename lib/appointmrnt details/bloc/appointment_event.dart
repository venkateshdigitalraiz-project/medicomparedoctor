import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the details screen first loads and needs data.
class LoadAppointmentDetails extends AppointmentEvent {
  final String appointmentId;

  const LoadAppointmentDetails(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Fired when the user taps Call / Video / Chat.
class ContactActionPressed extends AppointmentEvent {
  final ContactAction action;

  const ContactActionPressed(this.action);

  @override
  List<Object?> get props => [action];
}

enum ContactAction { call, video, chat }
