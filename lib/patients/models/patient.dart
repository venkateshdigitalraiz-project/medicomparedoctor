enum PatientStatus { completed, waiting, cancelled }

class Patient {
  final String id;
  final String name;
  final String pid;
  final int age;
  final String gender;
  final String phone;
  final String lastVisit;
  final String avatarUrl;
  final PatientStatus status;

  const Patient({
    required this.id,
    required this.name,
    required this.pid,
    required this.age,
    required this.gender,
    required this.phone,
    required this.lastVisit,
    required this.avatarUrl,
    required this.status,
  });
}
