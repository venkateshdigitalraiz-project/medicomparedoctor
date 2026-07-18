import 'package:flutter/material.dart';

class TodayChip extends StatelessWidget {
  const TodayChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xff6C2BD9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          "Today",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
