part of 'otp_bloc.dart';

enum OtpSubmissionStatus { idle, submitting, success, failure }

class OtpState extends Equatable {
  final String phoneNumber;
  final List<String> digits;
  final int secondsRemaining;
  final bool canResend;
  final OtpSubmissionStatus status;
  final String? errorMessage;

  const OtpState({
    required this.phoneNumber,
    required this.digits,
    required this.secondsRemaining,
    required this.canResend,
    required this.status,
    this.errorMessage,
  });

  factory OtpState.initial({String phoneNumber = ''}) => OtpState(
        phoneNumber: phoneNumber,
        digits: const ['', '', '', ''],
        secondsRemaining: 24,
        canResend: false,
        status: OtpSubmissionStatus.idle,
      );

  bool get isComplete => digits.every((d) => d.isNotEmpty);

  String get code => digits.join();

  String get formattedTimer {
    final m = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final s = (secondsRemaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  OtpState copyWith({
    String? phoneNumber,
    List<String>? digits,
    int? secondsRemaining,
    bool? canResend,
    OtpSubmissionStatus? status,
    String? errorMessage,
  }) {
    return OtpState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      digits: digits ?? this.digits,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      canResend: canResend ?? this.canResend,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [phoneNumber, digits, secondsRemaining, canResend, status, errorMessage];
}
