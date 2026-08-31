class TimelineEvent {
  final String title;
  final String time;
  final bool isPending;

  const TimelineEvent({
    required this.title,
    required this.time,
    this.isPending = false,
  });
}

class AppointmentModel {
  final String id;
  final String patientName;
  final String patientId;
  final String avatarUrl;
  final String type;
  final String appointmentTime;

  final String surgeryType;
  final String location;
  final String reasonForCheckup;
  final String appointmentType;
  final String duration;
  final List<String> clinicalNotes;
  final List<TimelineEvent> timeline;

  const AppointmentModel({
    this.id = '',
    required this.patientName,
    required this.patientId,
    required this.avatarUrl,
    required this.type,
    required this.appointmentTime,
    required this.surgeryType,
    required this.location,
    required this.reasonForCheckup,
    required this.appointmentType,
    required this.duration,
    required this.clinicalNotes,
    required this.timeline,
  });
}
