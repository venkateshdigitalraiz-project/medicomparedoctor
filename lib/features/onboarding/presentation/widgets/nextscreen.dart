import 'package:flutter/material.dart';
import 'package:medicompare/features/onboarding/presentation/widgets/ringaccentpaint.dart';

class NextMoveButton extends StatelessWidget {
  final Color color;
  final double sweep;
  const NextMoveButton({Key? key, required this.color, required this.sweep})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // outer partial ring accent
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(painter: RingAccentPainter(sweep: sweep)),
          ),
          // white circle button
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
