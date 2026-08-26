import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/core/constants/app_strings.dart';
import 'package:medicompare/core/network/global_client.dart';
import 'package:medicompare/core/network/network_exception.dart';

import 'package:medicompare/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:medicompare/features/auth/login/data/repositories/login_repository_impl.dart';
import 'package:medicompare/features/auth/login/domain/usecases/login_usecase.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_event.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({LoginUseCase? loginUseCase})
    : loginUseCase =
          loginUseCase ??
          LoginUseCase(
            LoginRepositoryImpl(
              remoteDataSource: LoginRemoteDataSourceImpl(
                client: AppHttpClient.dio,
              ),
            ),
          ),
      super(const LoginState()) {
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
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorText: AppStrings.enterValid10DigitPhone,
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, clearError: true));

    developer.log('=== LOGIN SUBMISSION START ===', name: 'LoginBloc');

    try {
      // Fetch FCM token to send with login request
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        developer.log('FCM Token: $fcmToken', name: 'LoginBloc');
      } catch (e) {
        developer.log('Failed to get FCM token: $e', name: 'LoginBloc');
      }

      developer.log('Calling loginUseCase...', name: 'LoginBloc');

      final response = await loginUseCase(
        state.phoneNumber.trim(),
        fcmToken: fcmToken,
      );

      developer.log('loginUseCase completed successfully.', name: 'LoginBloc');

      if (response.success) {
        emit(state.copyWith(status: LoginStatus.success, clearError: true));
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorText: response.message.isNotEmpty
                ? response.message
                : AppStrings.somethingWentWrong,
          ),
        );
      }
    } on DioException catch (e, stackTrace) {
      developer.log(
        'DioException caught during login.',
        name: 'LoginBloc',
        error: e,
        stackTrace: stackTrace,
      );

      String message = AppStrings.somethingWentWrong;

      if (e.error is NetworkException) {
        message = (e.error as NetworkException).message;
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }

      emit(state.copyWith(status: LoginStatus.failure, errorText: message));
    } catch (e, stackTrace) {
      developer.log(
        'Unexpected exception caught during login.',
        name: 'LoginBloc',
        error: e,
        stackTrace: stackTrace,
      );

      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorText: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
