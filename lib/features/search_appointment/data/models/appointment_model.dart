/// Simple data model representing a single appointment entry
/// shown in the "Today's Appointments" search screen.
class Appointment {
  final String id;
  final String name;
  final String phone;
  final String avatarUrl;

  const Appointment({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
  });
}
