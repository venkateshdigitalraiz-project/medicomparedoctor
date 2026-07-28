import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class PhoneNumberChanged extends LoginEvent {
  final String phoneNumber;
  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class CountryCodeChanged extends LoginEvent {
  final String countryCode;
  final String flagEmoji;
  const CountryCodeChanged(this.countryCode, this.flagEmoji);

  @override
  List<Object?> get props => [countryCode, flagEmoji];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
