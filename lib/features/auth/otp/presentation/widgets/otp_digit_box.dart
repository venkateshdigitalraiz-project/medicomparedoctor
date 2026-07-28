import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpDigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;

  const OtpDigitBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.nextFocusNode,
    this.previousFocusNode,
    this.hasError = false,
  });

  static const _primaryPurple = Color(0xFF5B1A99);
  static const _darkTeal = Color(0xFF1B2E3C);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              controller.text.isEmpty &&
              previousFocusNode != null) {
            previousFocusNode!.requestFocus();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _darkTeal,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : _primaryPurple,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : _primaryPurple,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            onChanged(value);
            if (value.isNotEmpty && nextFocusNode != null) {
              nextFocusNode!.requestFocus();
            }
          },
        ),
      ),
    );
  }
}
