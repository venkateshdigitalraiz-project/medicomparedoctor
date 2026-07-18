import 'package:equatable/equatable.dart';

/// A single "blocked slot" entry, e.g. Lunch Break, Hospital Meeting.
class BlockedSlot extends Equatable {
  final String id;
  final String title;
  final String subtitle; // e.g. "Daily • 01:00 PM - 02:00 PM"

  const BlockedSlot({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, title, subtitle];
}

/// A single holiday / leave entry, e.g. Christmas Break.
class Holiday extends Equatable {
  final String id;
  final String day; // "25"
  final String month; // "Dec"
  final String title; // "Christmas Break"
  final String duration; // "Duration: 3 Days"

  const Holiday({
    required this.id,
    required this.day,
    required this.month,
    required this.title,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, day, month, title, duration];
}

/// Which consultation type is being toggled.
enum ConsultationType { inPerson, videoCall, homeVisit }

/// Which appointment rule is being toggled.
enum AppointmentRule { autoAccept, sameDayBooking, reschedulingAllowed }

/// Which time field is being changed.
enum TimeField { morningStart, morningEnd, eveningStart, eveningEnd }
