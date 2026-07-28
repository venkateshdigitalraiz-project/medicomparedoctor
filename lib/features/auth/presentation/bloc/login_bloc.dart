import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:medicompare/core/constants/app_constants.dart';
import 'package:medicompare/core/constants/app_strings.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_event.dart';
import 'package:medicompare/features/auth/login/presentation/bloc/login_state.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc({AuthRepository? repository})
    : repository =
          repository ??
          AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
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

  Future<bool> _checkInternetReachability() async {
    try {
      final lookup = await InternetAddress.lookup(
        'google.com',
      ).timeout(AppConstants.internetCheckTimeout);
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(errorText: AppStrings.enterValid10DigitPhone));
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, clearError: true));

    developer.log('=== CONNECTIVITY DIAGNOSTICS START ===', name: 'LoginBloc');
    bool hasConnectivity = await _checkInternetReachability();
    developer.log(
      'Connectivity pre-check state: ${hasConnectivity ? "ONLINE" : "OFFLINE"}',
      name: 'LoginBloc',
    );

    try {
      developer.log(
        'Attempting repository.login() API method call...',
        name: 'LoginBloc',
      );
      final response = await repository.login(state.phoneNumber.trim());
      developer.log(
        'repository.login() completed successfully.',
        name: 'LoginBloc',
      );

      if (response.success) {
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorText: response.message,
          ),
        );
      }
    } on SocketException catch (e, stacktrace) {
      developer.log(
        'SocketException caught in LoginBloc submission!',
        name: 'LoginBloc',
        error: e,
        stackTrace: stacktrace,
      );
      final isInternetAvailable = await _checkInternetReachability();
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorText: isInternetAvailable
              ? AppStrings.serverUnreachable
              : AppStrings.noInternetConnection,
        ),
      );
    } on TimeoutException catch (e, stacktrace) {
      developer.log(
        'TimeoutException caught in LoginBloc submission!',
        name: 'LoginBloc',
        error: e,
        stackTrace: stacktrace,
      );
      final isInternetAvailable = await _checkInternetReachability();
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorText: isInternetAvailable
              ? AppStrings.requestTimeout
              : AppStrings.noInternetConnection,
        ),
      );
    } catch (e, stacktrace) {
      developer.log(
        'Unexpected Exception caught in LoginBloc submission!',
        name: 'LoginBloc',
        error: e,
        stackTrace: stacktrace,
      );
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      final isInternetAvailable = await _checkInternetReachability();

      if (errorMsg.contains('SocketException') ||
          errorMsg.contains('Failed host lookup') ||
          errorMsg.contains('HandshakeException') ||
          errorMsg.contains('Network is unreachable') ||
          errorMsg.contains('Connection refused') ||
          e is http.ClientException) {
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorText: isInternetAvailable
                ? AppStrings.serverUnreachable
                : AppStrings.noInternetConnection,
          ),
        );
      } else {
        emit(state.copyWith(status: LoginStatus.failure, errorText: errorMsg));
      }
    }
  }
}
