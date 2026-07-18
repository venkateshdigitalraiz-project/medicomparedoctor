import 'package:equatable/equatable.dart';

/// Status of an appointment, drives the color + label shown on each card.
enum AppointmentStatus { confirmed, waiting, cancelled }

extension AppointmentStatusX on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.waiting:
        return 'Waiting';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// How the appointment takes place.
enum AppointmentMode { inPerson, online, linkExpired }

class Appointment extends Equatable {
  final String id;
  final String patientName;
  final String avatarUrl;
  final String time; // e.g. "09:00 AM"
  final AppointmentMode mode;
  final AppointmentStatus status;
  final String? meetingLink; // only for online appointments

  const Appointment({
    required this.id,
    required this.patientName,
    required this.avatarUrl,
    required this.time,
    required this.mode,
    required this.status,
    this.meetingLink,
  });

  bool get isCancelled => status == AppointmentStatus.cancelled;

  @override
  List<Object?> get props =>
      [id, patientName, avatarUrl, time, mode, status, meetingLink];
}

/// Aggregate counts shown in the four stat cards at the top of the screen.
class ScheduleStats extends Equatable {
  final int total;
  final int confirmed;
  final int waiting;
  final int cancelled;

  const ScheduleStats({
    required this.total,
    required this.confirmed,
    required this.waiting,
    required this.cancelled,
  });

  @override
  List<Object?> get props => [total, confirmed, waiting, cancelled];
}
