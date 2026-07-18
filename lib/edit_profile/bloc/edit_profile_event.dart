part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class FullNameChanged extends EditProfileEvent {
  final String fullName;
  const FullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class GenderChanged extends EditProfileEvent {
  final String gender;
  const GenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class SpecializationChanged extends EditProfileEvent {
  final String specialization;
  const SpecializationChanged(this.specialization);

  @override
  List<Object?> get props => [specialization];
}

class MedicalRegNumberChanged extends EditProfileEvent {
  final String regNumber;
  const MedicalRegNumberChanged(this.regNumber);

  @override
  List<Object?> get props => [regNumber];
}

class ClinicNameChanged extends EditProfileEvent {
  final String clinicName;
  const ClinicNameChanged(this.clinicName);

  @override
  List<Object?> get props => [clinicName];
}

class LocationChanged extends EditProfileEvent {
  final String location;
  const LocationChanged(this.location);

  @override
  List<Object?> get props => [location];
}

/// Fired when the user taps the location pin icon (e.g. to open a picker).
class LocationPinTapped extends EditProfileEvent {
  const LocationPinTapped();
}

class ProfileLoaded extends EditProfileEvent {
  final EditProfileState initialData;
  const ProfileLoaded(this.initialData);

  @override
  List<Object?> get props => [initialData];
}

class ApplyPressed extends EditProfileEvent {
  const ApplyPressed();
}
