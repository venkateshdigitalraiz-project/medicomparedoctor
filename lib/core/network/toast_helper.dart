import 'package:flutter/material.dart';

class ToastHelper {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();
  static DateTime? _lastToastTime;
  static const Duration _toastThrottleDuration = Duration(seconds: 5);

  static void showNoInternetToast() {
    final now = DateTime.now();
    if (_lastToastTime != null && now.difference(_lastToastTime!) < _toastThrottleDuration) {
      // Avoid duplicate toasts during concurrent requests
      return;
    }
    _lastToastTime = now;

    messengerKey.currentState?.clearSnackBars();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: const Text(
          "No Internet Connection. Please check your network and try again.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
