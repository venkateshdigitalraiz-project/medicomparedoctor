import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  final double size;

  const AppLoader({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeInOut(color: color, size: size);
  }
}
