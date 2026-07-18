import 'package:equatable/equatable.dart';

abstract class PinEvent extends Equatable {
  const PinEvent();

  @override
  List<Object?> get props => [];
}

/// User pressed a number
class AddDigit extends PinEvent {
  final String digit;

  const AddDigit(this.digit);

  @override
  List<Object?> get props => [digit];
}

/// User pressed backspace
class RemoveDigit extends PinEvent {}

/// Continue button pressed
class ContinuePressed extends PinEvent {}

/// Reset PIN
class ResetPin extends PinEvent {}

/// Verify both PINs
class VerifyPin extends PinEvent {}

/// NEW EVENTS
class ShowKeypad extends PinEvent {}

class HideKeypad extends PinEvent {}
