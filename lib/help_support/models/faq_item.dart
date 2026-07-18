import 'package:flutter/material.dart';

class FaqItem {
  final String question;
  final String answer;
  final IconData icon;
  final bool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    required this.icon,
    this.isExpanded = false,
  });

  FaqItem copyWith({bool? isExpanded}) {
    return FaqItem(
      question: question,
      answer: answer,
      icon: icon,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
