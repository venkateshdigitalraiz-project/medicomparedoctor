import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({EditProfileState? initialState})
      : super(initialState ?? const EditProfileState()) {
    on<ProfileLoaded>((event, emit) => emit(event.initialData));
    on<FullNameChanged>((event, emit) =>
        emit(state.copyWith(fullName: event.fullName)));
    on<GenderChanged>(
        (event, emit) => emit(state.copyWith(gender: event.gender)));
    on<SpecializationChanged>((event, emit) =>
        emit(state.copyWith(specialization: event.specialization)));
    on<MedicalRegNumberChanged>((event, emit) =>
        emit(state.copyWith(regNumber: event.regNumber)));
    on<ClinicNameChanged>((event, emit) =>
        emit(state.copyWith(clinicName: event.clinicName)));
    on<LocationChanged>(
        (event, emit) => emit(state.copyWith(location: event.location)));
    on<LocationPinTapped>((event, emit) {
      // Hook up a location picker / geolocation package here.
    });
    on<ApplyPressed>(_onApplyPressed);
  }

  Future<void> _onApplyPressed(
    ApplyPressed event,
    Emitter<EditProfileState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(
        status: FormStatus.failure,
        errorMessage: 'Please fill in name, gender and reg. number.',
      ));
      return;
    }

    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));
    try {
      // Replace with your actual repository/API call, e.g.:
      // await profileRepository.updateProfile(state);
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FormStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormStatus.failure,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }
}
