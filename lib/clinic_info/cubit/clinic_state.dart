part of 'clinic_cubit.dart';

abstract class ClinicState {
  const ClinicState();
}

class ClinicLoading extends ClinicState {
  const ClinicLoading();
}

class ClinicLoaded extends ClinicState {
  final ClinicModel clinic;
  const ClinicLoaded(this.clinic);
}

class ClinicError extends ClinicState {
  final String message;
  const ClinicError(this.message);
}
