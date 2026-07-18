import 'package:flutter/material.dart';

/// ---------------------------------------------------------------
/// CustomPainter that draws the top-right corner background exactly
/// as it appears in the source screen: a single smooth radial
/// gradient wash (light tint at the corner, fading fully to white/
/// transparent) — no dots, no texture, no blur blobs.
/// ---------------------------------------------------------------
class CornerGradientPainter extends CustomPainter {
  final Color color;

  CornerGradientPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final corner = Offset(size.width, 0);

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.5),
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.33, 0.66, 1.0],
      ).createShader(Rect.fromCircle(center: corner, radius: size.width));

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CornerGradientPainter oldDelegate) =>
      oldDelegate.color != color;
}
