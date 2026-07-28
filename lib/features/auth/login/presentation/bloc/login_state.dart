import 'package:equatable/equatable.dart';

enum LoginStatus { idle, submitting, success, failure }

class LoginState extends Equatable {
  final String phoneNumber;
  final String countryCode;
  final String flagEmoji;
  final LoginStatus status;
  final String? errorText;

  const LoginState({
    this.phoneNumber = '',
    this.countryCode = '+91',
    this.flagEmoji = '🇮🇳',
    this.status = LoginStatus.idle,
    this.errorText,
  });

  bool get isValid =>
      phoneNumber.trim().length == 10 && RegExp(r'^\d+$').hasMatch(phoneNumber.trim());

  LoginState copyWith({
    String? phoneNumber,
    String? countryCode,
    String? flagEmoji,
    LoginStatus? status,
    String? errorText,
    bool clearError = false,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      status: status ?? this.status,
      errorText: clearError ? null : (errorText ?? this.errorText),
    );
  }

  @override
  List<Object?> get props =>
      [phoneNumber, countryCode, flagEmoji, status, errorText];
}
