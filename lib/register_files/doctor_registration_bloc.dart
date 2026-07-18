import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_registration_event.dart';
part 'doctor_registration_state.dart';

class DoctorRegistrationBloc extends Bloc<DoctorRegistrationEvent, DoctorRegistrationState> {
  DoctorRegistrationBloc() : super(const DoctorRegistrationState()) {
    on<FullNameChanged>((event, emit) {
      emit(state.copyWith(fullName: event.fullName));
    });

    on<GenderChanged>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });

    on<SpecializationChanged>((event, emit) {
      emit(state.copyWith(specialization: event.specialization));
    });

    on<MedicalRegNumberChanged>((event, emit) {
      emit(state.copyWith(medicalRegNumber: event.regNumber));
    });

    on<ClinicNameChanged>((event, emit) {
      emit(state.copyWith(clinicName: event.clinicName));
    });

    on<LocationChanged>((event, emit) {
      emit(state.copyWith(location: event.location));
    });

    on<LocationDetectRequested>((event, emit) async {
      // Hook up geolocation/reverse-geocoding here (e.g. via `geolocator` +
      // `geocoding` packages). Left as a stub so this bloc has no
      // hard dependency on location plugins.
      emit(state.copyWith(location: state.location));
    });

    on<RegisterSubmitted>((event, emit) async {
      if (!state.isValid) {
        emit(state.copyWith(
          status: DoctorRegistrationStatus.failure,
          errorMessage: 'Please fill in all fields.',
        ));
        return;
      }

      emit(state.copyWith(status: DoctorRegistrationStatus.submitting));
      try {
        // Replace with a real API call, e.g. via a repository injected
        // into this bloc's constructor.
        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(status: DoctorRegistrationStatus.success));
      } catch (e) {
        emit(state.copyWith(
          status: DoctorRegistrationStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
