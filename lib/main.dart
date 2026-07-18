import 'package:flutter/material.dart';
import 'package:medicompare/core/routes/app_routes.dart';
import 'package:medicompare/core/routes/router_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medi Compares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5B2A8C),
        fontFamily: 'Roboto',
      ),

      initialRoute: RouteNames.homeBottomNav,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
