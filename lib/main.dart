import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medicompare/core/routes/app_routes.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/services/firebase_service.dart';
import 'package:medicompare/core/services/session_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool loggedIn = await SessionManager.isLoggedIn();
  await Firebase.initializeApp();
  await FirebaseTokenService.init();
  runApp(
    MyApp(initialRoute: loggedIn ? RouteNames.homeBottomNav : RouteNames.login),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medi Compares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5B2A8C),
        fontFamily: 'Roboto',
      ),

      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
