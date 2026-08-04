import 'package:flutter/material.dart';

/// Centralised color palette for the MediCompares splash experience.
///
/// Keeping colors here (rather than scattered as magic hex values across
/// widgets) means the exact brand palette from the design files is defined
/// once and reused everywhere — nothing about the logo/brand colors is
/// altered anywhere else in the codebase.
class AppColors {
  const AppColors._();

  /// Pure white background used in Stage 1 and Stage 4.
  static const Color splashWhite = Colors.white;

  /// Brand purple used across Stage 2's gradient, Stage 3's solid
  /// background, and the Stage 4 fade-back-to-white (#601CA3 exactly).
  static const Color brandPurple = Color(0xFF601CA3);

  /// Color of the glow rendered behind the expanding circle in Stage 3.
  static const Color glowColor = Color(0xFF8B5CF6);
}
