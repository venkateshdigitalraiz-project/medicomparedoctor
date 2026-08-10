part of 'edit_profile_bloc.dart';

enum FormStatus { initial, submitting, success, failure }

class EditProfileState extends Equatable {
  final String fullName;
  final String gender;
  final String specialization;
  final String regNumber;
  final String clinicName;
  final String location;
  final FormStatus status;
  final String? errorMessage;

  const EditProfileState({
    this.fullName = '',
    this.gender = '',
    this.specialization = '',
    this.regNumber = '',
    this.clinicName = '',
    this.location = '',
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  /// Simple validation gate — tweak rules as needed.
  bool get isValid =>
      fullName.trim().isNotEmpty &&
      gender.trim().isNotEmpty &&
      regNumber.trim().isNotEmpty;

  EditProfileState copyWith({
    String? fullName,
    String? gender,
    String? specialization,
    String? regNumber,
    String? clinicName,
    String? location,
    FormStatus? status,
    String? errorMessage,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      specialization: specialization ?? this.specialization,
      regNumber: regNumber ?? this.regNumber,
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
        regNumber,
        clinicName,
        location,
        status,
        errorMessage,
      ];
}
