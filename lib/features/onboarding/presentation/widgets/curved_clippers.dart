import 'package:flutter/material.dart';

/// Smooth, symmetric hill curve — the purple footer rises gently toward
/// the middle of the screen, as seen on the first intro page.
class HillClipper extends CustomClipper<Path> {
  const HillClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final crestHeight = size.height * 0.12;

    path.lineTo(0, crestHeight * 1.6);
    path.quadraticBezierTo(
      size.width * 0.5,
      -crestHeight * 0.6, // pulls the crest above the footer's top edge
      size.width,
      crestHeight * 1.6,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Diagonal wave curve rising from the bottom-left toward the top-right —
/// used on the second and third intro pages.
class WaveClipper extends CustomClipper<Path> {
  const WaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.22);
    path.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.02,
      size.width,
      0,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
