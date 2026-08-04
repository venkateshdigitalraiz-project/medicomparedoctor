import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/routes/app_routes.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/services/firebase_service.dart';
import 'package:medicompare/core/services/session_manager.dart';

import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseTokenService.init();
  runApp(
    // MyApp(initialRoute: loggedIn ? RouteNames.homeBottomNav : RouteNames.login),
    MyApp(),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Background message: ${message.messageId}");
}

// class MyApp extends StatelessWidget {
//   final String initialRoute;

//   const MyApp({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       scaffoldMessengerKey: ToastHelper.messengerKey,
//       title: 'Medi Compares',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF5B2A8C),
//         fontFamily: 'Roboto',
//       ),

//       initialRoute: initialRoute,
//       onGenerateRoute: AppRoutes.generate,
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Global navigator key to allow navigation from BlocListener before Navigator is built
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
      create: (_) => OnboardingBloc(),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'MediCompares',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: const Color(0xFF6A1FB2),
          useMaterial3: true,
        ),
        initialRoute: RouteNames.splash,
        onGenerateRoute: AppRoutes.generate,
        builder: (context, child) {
          return BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              final navigator = MyApp._navigatorKey.currentState;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final bool loggedIn = await SessionManager.isLoggedIn();
                if (state is OnboardingChecked) {
                  if (state.isCompleted) {
                    log("completed Splash screen");
                    navigator?.pushNamedAndRemoveUntil(
                      // RouteNames.calendar,
                      loggedIn ? RouteNames.homeBottomNav : RouteNames.login,
                      (_) => false,
                    );
                  } else {
                    navigator?.pushReplacementNamed(RouteNames.intro1);
                  }
                } else if (state is OnboardingCompleted) {
                  navigator?.pushNamedAndRemoveUntil(
                    loggedIn ? RouteNames.homeBottomNav : RouteNames.login,
                    (_) => false,
                  );
                }
              });
            },
            child: child!,
          );
        },
      ),
    );
  }
}
