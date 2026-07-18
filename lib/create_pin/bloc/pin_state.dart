import 'package:equatable/equatable.dart';

class PinState extends Equatable {
  final String createPin;
  final String confirmPin;
  final bool showKeypad;

  /// false = Create PIN
  /// true = Confirm PIN
  final bool isConfirmStep;

  final bool loading;

  final bool success;

  final String error;

  const PinState({
    this.createPin = "",
    this.confirmPin = "",
    this.isConfirmStep = false,
    this.loading = false,
    this.success = false,
    this.error = "",
    this.showKeypad = false,
  });

  PinState copyWith({
    String? createPin,
    String? confirmPin,
    bool? isConfirmStep,
    bool? loading,
    bool? success,
    String? error,
    bool? showKeypad,
  }) {
    return PinState(
      createPin: createPin ?? this.createPin,
      confirmPin: confirmPin ?? this.confirmPin,
      isConfirmStep: isConfirmStep ?? this.isConfirmStep,
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error ?? this.error,
      showKeypad: showKeypad ?? this.showKeypad,
    );
  }

  @override
  List<Object?> get props => [
    createPin,
    confirmPin,
    isConfirmStep,
    loading,
    success,
    error,
    showKeypad,
  ];
}
