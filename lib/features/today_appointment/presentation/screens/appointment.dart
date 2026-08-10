enum AppointmentStatus { confirmed, waiting }

enum AppointmentType { online, inPerson }

class Appointment {
  final String id;
  final String time;
  final String name;
  final String avatarUrl;
  final AppointmentStatus status;
  final AppointmentType type;

  const Appointment({
    required this.id,
    required this.time,
    required this.name,
    required this.avatarUrl,
    required this.status,
    required this.type,
  });
}
