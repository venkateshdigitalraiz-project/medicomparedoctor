class WorkingHour {
  final String day;
  final String hours;
  final bool isClosed;

  const WorkingHour({
    required this.day,
    required this.hours,
    this.isClosed = false,
  });
}

class ClinicModel {
  final String name;
  final String tagline;
  final String phone;
  final String email;
  final String address;
  final String clinicType;
  final String registrationNo;
  final String gstNumber;
  final List<WorkingHour> workingHours;

  const ClinicModel({
    required this.name,
    required this.tagline,
    required this.phone,
    required this.email,
    required this.address,
    required this.clinicType,
    required this.registrationNo,
    required this.gstNumber,
    required this.workingHours,
  });
}
