import 'package:equatable/equatable.dart';

abstract class PinEvent extends Equatable {
  const PinEvent();

  @override
  List<Object?> get props => [];
}

/// Fired whenever the hidden text field's value changes.
/// We pass the *whole* raw text rather than a single digit so the bloc
/// can figure out additions vs. deletions (backspace) itself.
class PinChanged extends PinEvent {
  final String rawText;

  const PinChanged(this.rawText);

  @override
  List<Object?> get props => [rawText];
}

/// Clears the pin, e.g. after a failed "Continue" attempt.
class PinCleared extends PinEvent {
  const PinCleared();
}
