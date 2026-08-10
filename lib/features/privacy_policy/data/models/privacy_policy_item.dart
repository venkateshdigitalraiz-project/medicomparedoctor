import 'package:flutter/material.dart';

/// Simple data model describing one card in the Privacy Policy list.
class PrivacyPolicyItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String description;

  const PrivacyPolicyItem({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
  });
}
