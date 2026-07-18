import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final bool showChevron;

  const MenuItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.showChevron = false,
  });

  @override
  List<Object?> get props => [id, label, icon, iconColor, iconBg, showChevron];
}
