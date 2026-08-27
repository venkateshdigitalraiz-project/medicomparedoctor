import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:medicompare/core/globals.dart' as globals;
import 'package:medicompare/core/routes/app_routes.dart';
import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/core/services/session_manager.dart';
import 'package:medicompare/core/network/toast_helper.dart';
import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:medicompare/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:medicompare/features/call/presentation/bloc/call_bloc.dart';
import 'package:medicompare/features/call/presentation/pages/call_screen.dart';
import 'package:medicompare/injection_container.dart' as di;
import 'package:medicompare/core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotificationManager.init();

  // Request notification permissions for incoming calls & messages
  try {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  } catch (e) {
    debugPrint('Firebase notification permission request error: $e');
  }

  // Check if app was launched directly by accepting CallKit while terminated
  String? initialCallId;
  try {
    final dynamic activeCalls = await FlutterCallkitIncoming.activeCalls();
    if (activeCalls is List && activeCalls.isNotEmpty) {
      final dynamic first = activeCalls.first;
      if (first != null) {
        final dynamic isAccepted =
            first is Map
                ? (first['isAccepted'] ?? first['accepted'])
                : (first as dynamic).isAccepted;
        if (isAccepted == true) {
          initialCallId =
              first is Map
                  ? (first['extra']?['callId']?.toString() ??
                      first['id']?.toString() ??
                      first['callId']?.toString())
                  : ((first as dynamic).extra?['callId']?.toString() ??
                      (first as dynamic).id?.toString());
          await FlutterCallkitIncoming.endAllCalls();
        }
      }
    }
  } catch (e) {
    debugPrint('Error checking active CallKit on startup: $e');
  }

  await di.init();

  runApp(MyApp(initialCallId: initialCallId));
}

class MyApp extends StatefulWidget {
  final String? initialCallId;
  const MyApp({super.key, this.initialCallId});

  static GlobalKey<NavigatorState> get navigatorKey => globals.navigatorKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (widget.initialCallId != null && widget.initialCallId!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        globals.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder:
                (_) =>
                    CallScreen(callId: widget.initialCallId, isIncoming: true),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingBloc>(create: (_) => OnboardingBloc()),
        BlocProvider<CallBloc>(lazy: false, create: (_) => di.sl<CallBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: globals.navigatorKey,
        scaffoldMessengerKey: ToastHelper.messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'MediCompare Doctor',
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
              final navigator = globals.navigatorKey.currentState;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                final bool loggedIn = await SessionManager.isLoggedIn();
                if (state is OnboardingChecked) {
                  if (state.isCompleted) {
                    log("completed Splash screen");
                    navigator?.pushNamedAndRemoveUntil(
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
