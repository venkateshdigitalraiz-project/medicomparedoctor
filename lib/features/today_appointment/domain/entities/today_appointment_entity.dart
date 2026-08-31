import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TodayAppointmentEntity extends Equatable {
  final String id;
  final String userId;
  final String patientId;
  final String name;
  final String phone;
  final String email;
  final String city;
  final int age;
  final String message;
  final String preferredTime;
  final String status;
  final String avatarUrl;
  final String notes;

  const TodayAppointmentEntity({
    required this.id,
    required this.userId,
    required this.patientId,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.age,
    required this.message,
    required this.preferredTime,
    required this.status,
    required this.avatarUrl,
    this.notes = '',
  });

  String get displayName {
    if (name.trim().isNotEmpty) return name.trim();
    if (email.trim().isNotEmpty) return email.split('@').first;
    if (phone.trim().isNotEmpty) return phone.trim();
    return 'Patient';
  }

  String get formattedTime {
    if (preferredTime.isEmpty) return '--:--';
    try {
      final dt = DateTime.parse(preferredTime).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return preferredTime;
    }
  }

  String get formattedDate {
    if (preferredTime.isEmpty) return '';
    try {
      final dt = DateTime.parse(preferredTime).toLocal();
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return '';
    }
  }

  bool get isConfirmed =>
      status.toLowerCase() == 'confirmed' ||
      status.toLowerCase() == 'completed';

  bool get isPending =>
      status.toLowerCase() == 'pending' ||
      status.toLowerCase() == 'waiting';

  bool get isCancelled => status.toLowerCase() == 'cancelled';

  @override
  List<Object?> get props => [
        id,
        userId,
        patientId,
        name,
        phone,
        email,
        city,
        age,
        message,
        preferredTime,
        status,
        avatarUrl,
        notes,
      ];
}
