part of 'doctor_registration_bloc.dart';

abstract class DoctorRegistrationEvent extends Equatable {
  const DoctorRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class FullNameChanged extends DoctorRegistrationEvent {
  final String fullName;
  const FullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class GenderChanged extends DoctorRegistrationEvent {
  final String gender;
  const GenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class SpecializationChanged extends DoctorRegistrationEvent {
  final String specialization;
  const SpecializationChanged(this.specialization);

  @override
  List<Object?> get props => [specialization];
}

class MedicalRegNumberChanged extends DoctorRegistrationEvent {
  final String regNumber;
  const MedicalRegNumberChanged(this.regNumber);

  @override
  List<Object?> get props => [regNumber];
}

class ClinicNameChanged extends DoctorRegistrationEvent {
  final String clinicName;
  const ClinicNameChanged(this.clinicName);

  @override
  List<Object?> get props => [clinicName];
}

class LocationChanged extends DoctorRegistrationEvent {
  final String location;
  const LocationChanged(this.location);

  @override
  List<Object?> get props => [location];
}

class LocationDetectRequested extends DoctorRegistrationEvent {
  const LocationDetectRequested();
}

class RegisterSubmitted extends DoctorRegistrationEvent {
  const RegisterSubmitted();
}
