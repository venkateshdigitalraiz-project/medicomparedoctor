import 'package:equatable/equatable.dart';

class PinState extends Equatable {
  static const int pinLength = 4;

  final String pin;

  const PinState({this.pin = ''});

  bool get isComplete => pin.length == pinLength;

  /// Returns the digit at [index], or null if not yet typed.
  String? digitAt(int index) => index < pin.length ? pin[index] : null;

  PinState copyWith({String? pin}) => PinState(pin: pin ?? this.pin);

  @override
  List<Object?> get props => [pin];
}
