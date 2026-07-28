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

  factory Appointment.fromJson(Map<String, dynamic> json) {
    AppointmentStatus status;
    switch ((json['status'] as String? ?? '').toLowerCase()) {
      case 'confirmed':
        status = AppointmentStatus.confirmed;
        break;
      case 'cancelled':
        status = AppointmentStatus.cancelled;
        break;
      default:
        status = AppointmentStatus.waiting;
    }

    AppointmentType type;
    switch ((json['type'] as String? ?? '').toLowerCase()) {
      case 'online':
        type = AppointmentType.online;
        break;
      default:
        type = AppointmentType.inPerson;
    }

    return Appointment(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString() ??
          json['name']?.toString() ??
          'Unknown',
      time: json['time']?.toString() ??
          json['appointmentTime']?.toString() ??
          '',
      avatarUrl: json['avatarUrl']?.toString() ??
          json['profileImage']?.toString() ??
          'https://i.pravatar.cc/150',
      status: status,
      type: type,
    );
  }

  @override
  List<Object?> get props => [id, patientName, time, avatarUrl, status, type];
}

