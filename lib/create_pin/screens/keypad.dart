import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pin_bloc.dart';
import '../bloc/pin_event.dart';

class Keypad extends StatelessWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      decoration: const BoxDecoration(
        color: Color(0xffF5F5F7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(context, ["1", "2", "3"]),

          const SizedBox(height: 20),

          _row(context, ["4", "5", "6"]),

          const SizedBox(height: 20),

          _row(context, ["7", "8", "9"]),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 80),

              _button(context, "0"),

              _backspace(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((e) => _button(context, e)).toList(),
    );
  }

  Widget _button(BuildContext context, String value) {
    return GestureDetector(
      onTap: () {
        context.read<PinBloc>().add(AddDigit(value));
      },
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xffECEEF6),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _backspace(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PinBloc>().add(RemoveDigit());
      },
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: Color(0xffECEEF6),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.backspace_outlined, size: 30),
      ),
    );
  }
}
