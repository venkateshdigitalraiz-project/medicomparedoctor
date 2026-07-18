part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

/// Fired whenever a digit box changes.
class OtpDigitChanged extends OtpEvent {
  final int index;
  final String value;

  const OtpDigitChanged({required this.index, required this.value});

  @override
  List<Object?> get props => [index, value];
}

/// Internal tick fired every second by the countdown timer.
class OtpTimerTicked extends OtpEvent {
  final int secondsRemaining;

  const OtpTimerTicked(this.secondsRemaining);

  @override
  List<Object?> get props => [secondsRemaining];
}

/// User tapped "Resend".
class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}

/// User tapped the "Verify" button.
class OtpVerifySubmitted extends OtpEvent {
  const OtpVerifySubmitted();
}

/// Start the whole flow (e.g. when the screen opens).
class OtpStarted extends OtpEvent {
  final String phoneNumber;

  const OtpStarted(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
