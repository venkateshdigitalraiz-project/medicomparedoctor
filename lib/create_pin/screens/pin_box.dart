import 'package:flutter/material.dart';

class PinBox extends StatelessWidget {
  final String pin;

  const PinBox({super.key, required this.pin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        final bool filled = index < pin.length;

        return SizedBox(
          width: 55,
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  filled ? pin[index] : "0",
                  key: ValueKey(filled ? pin[index] : "$index"),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff083B4C),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(width: 70, height: 2, color: const Color(0xff6C2BD9)),
            ],
          ),
        );
      }),
    );
  }
}
