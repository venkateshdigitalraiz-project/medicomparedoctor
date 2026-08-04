import 'package:flutter/material.dart';

class BackScreenButton extends StatelessWidget {
  final Color color;
  const BackScreenButton({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // white circle button
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_rounded, color: color, size: 20),
          ),
        ],
      ),
    );
  }
}
