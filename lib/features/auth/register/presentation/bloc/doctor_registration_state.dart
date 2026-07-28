part of 'doctor_registration_bloc.dart';

enum DoctorRegistrationStatus { initial, submitting, success, failure, error }

class DoctorRegistrationState extends Equatable {
  final String fullName;
  final String gender;
  final String specialization;
  final String medicalRegNumber;
  final String clinicName;
  final String location;
  final DoctorRegistrationStatus status;
  final String? errorMessage;

  const DoctorRegistrationState({
    this.fullName = '',
    this.gender = '',
    this.specialization = '',
    this.medicalRegNumber = '',
    this.clinicName = '',
    this.location = '',
    this.status = DoctorRegistrationStatus.initial,
    this.errorMessage,
  });

  bool get isValid =>
      fullName.trim().isNotEmpty &&
      gender.trim().isNotEmpty &&
      specialization.trim().isNotEmpty &&
      medicalRegNumber.trim().isNotEmpty &&
      clinicName.trim().isNotEmpty &&
      location.trim().isNotEmpty;

  DoctorRegistrationState copyWith({
    String? fullName,
    String? gender,
    String? specialization,
    String? medicalRegNumber,
    String? clinicName,
    String? location,
    DoctorRegistrationStatus? status,
    String? errorMessage,
  }) {
    return DoctorRegistrationState(
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      specialization: specialization ?? this.specialization,
      medicalRegNumber: medicalRegNumber ?? this.medicalRegNumber,
      clinicName: clinicName ?? this.clinicName,
      location: location ?? this.location,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    gender,
    specialization,
    medicalRegNumber,
    clinicName,
    location,
    status,
    errorMessage,
  ];
}
