import 'package:equatable/equatable.dart';

enum AppointmentStatus { confirmed, waiting, cancelled }

enum AppointmentType { online, inPerson }

class Appointment extends Equatable {
  final String id;
  final String patientName;
  final String time;
  final String avatarUrl;
  final AppointmentStatus status;
  final AppointmentType type;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.time,
    required this.avatarUrl,
    required this.status,
    required this.type,
  });

  @override
  List<Object?> get props => [id, patientName, time, avatarUrl, status, type];
}
