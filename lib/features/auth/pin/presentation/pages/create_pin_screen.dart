import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicompare/features/auth/pin/presentation/bloc/pin_bloc.dart';
import 'package:medicompare/features/auth/pin/presentation/bloc/pin_event.dart';
import 'package:medicompare/features/auth/pin/presentation/bloc/pin_state.dart';
import 'package:flutter/services.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  static const Color _darkTeal = Color(0xFF123B3D);
  static const Color _purple = Color(0xFF6A1B9A);
  static const Color _purpleBorder = Color(0xFFC9A6E8);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Tapping the pin row is the only way the keyboard appears.
  /// There is no custom on-screen keypad built into the layout at all -
  /// the OS keyboard is requested on demand and dismissed once the
  /// user taps elsewhere or the pin is complete.
  void _showKeyboard() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _hideKeyboard() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PinBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            // Tapping outside the pin boxes dismisses the keyboard.
            onTap: _hideKeyboard,
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  const Text(
                    'Add a PIN number to make your account more secure',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildPinRow(),
                  const Spacer(),
                  _buildContinueButton(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
        ),
        const SizedBox(width: 40),
        const Text(
          'Set You PIN',
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: _darkTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildPinRow() {
    return BlocBuilder<PinBloc, PinState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _showKeyboard,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(PinState.pinLength, (index) {
                  final digit = state.digitAt(index);
                  final isActive =
                      _focusNode.hasFocus && index == state.pin.length;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == PinState.pinLength - 1 ? 0 : 14,
                    ),
                    child: _PinBox(
                      digit: digit,
                      isActive: isActive,
                      borderColor: _purpleBorder,
                    ),
                  );
                }),
              ),
              // The actual keyboard trigger: an invisible text field laid
              // exactly over the pin boxes. No visible keypad is ever
              // built by us - this simply requests the native keyboard
              // when focused, and Flutter/OS shows and hides it for us.
              Opacity(
                opacity: 0,
                child: SizedBox(
                  width: 4 * 68 + 3 * 14, // matches the row's width
                  height: 76,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: false,
                    showCursor: false,
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(PinState.pinLength),
                    ],
                    maxLength: PinState.pinLength,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      context.read<PinBloc>().add(PinChanged(value));
                      if (value.length == PinState.pinLength) {
                        _hideKeyboard();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return BlocBuilder<PinBloc, PinState>(
      builder: (context, state) {
        final enabled = state.isComplete;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: enabled
                ? () {
                    _hideKeyboard();
                    // TODO: handle submit, e.g. navigate to confirm screen.
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _purple,
              disabledBackgroundColor: _purple.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PinBox extends StatelessWidget {
  final String? digit;
  final bool isActive;
  final Color borderColor;

  const _PinBox({
    required this.digit,
    required this.isActive,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 68,
      height: 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? borderColor : borderColor.withOpacity(0.7),
          width: isActive ? 2 : 1.4,
        ),
      ),
      child: Text(
        digit ?? '',
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
