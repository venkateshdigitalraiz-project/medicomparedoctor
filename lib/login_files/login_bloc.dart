import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/login_files/login_state.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<PhoneNumberChanged>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phoneNumber, clearError: true));
    });

    on<CountryCodeChanged>((event, emit) {
      emit(
        state.copyWith(
          countryCode: event.countryCode,
          flagEmoji: event.flagEmoji,
        ),
      );
    });

    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(errorText: 'Enter a valid phone number'));
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, clearError: true));

    // Simulate sending OTP / authenticating. Replace with real API call.
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(status: LoginStatus.success));
  }
}
