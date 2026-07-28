part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

class OtpDigitChanged extends OtpEvent {
  final int index;
  final String value;

  const OtpDigitChanged({required this.index, required this.value});

  @override
  List<Object?> get props => [index, value];
}

class OtpTimerTicked extends OtpEvent {
  final int secondsRemaining;

  const OtpTimerTicked(this.secondsRemaining);

  @override
  List<Object?> get props => [secondsRemaining];
}

class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}

class OtpVerifySubmitted extends OtpEvent {
  const OtpVerifySubmitted();
}

class OtpStarted extends OtpEvent {
  final String phoneNumber;

  const OtpStarted(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
