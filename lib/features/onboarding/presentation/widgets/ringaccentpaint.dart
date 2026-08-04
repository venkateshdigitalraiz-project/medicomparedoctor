import 'package:flutter/material.dart';

class RingAccentPainter extends CustomPainter {
  final double sweep;
  RingAccentPainter({required this.sweep});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);

    canvas.drawArc(
      rect,
      -1.2, // Start angle
      sweep, // Sweep angle (~200°)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
