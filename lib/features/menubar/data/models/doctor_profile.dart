import 'package:equatable/equatable.dart';

class DoctorProfile extends Equatable {
  final String name;
  final String qualification;
  final String specialty;
  final String id;
  final String avatarUrl;

  const DoctorProfile({
    required this.name,
    required this.qualification,
    required this.specialty,
    required this.id,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, qualification, specialty, id, avatarUrl];
}
