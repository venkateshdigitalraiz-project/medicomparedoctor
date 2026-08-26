import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/core/globals.dart';
import '../bloc/call_bloc.dart';
import '../bloc/call_event.dart';
import '../bloc/call_state.dart';
import '../pages/call_screen.dart';
import 'call_minimized_bubble.dart';

/// Manages the global floating call bubble shown when a call is minimized.
class CallSessionManager {
  CallSessionManager._();

  static OverlayEntry? _entry;
  static StreamSubscription<CallState>? _sub;
  static CallConnectedState? _lastConnectedState;

  static bool get isMinimized => _entry != null;

  static void minimize(
    BuildContext context, {
    required CallConnectedState state,
  }) {
    _lastConnectedState = state;
    final callBloc = context.read<CallBloc>();

    dismiss();

    _entry = OverlayEntry(
      builder:
          (_) => CallMinimizedBubble(
            state: state,
            onExpand: () => expand(context),
            onHangUp: () {
              callBloc.add(const EndCallEvent());
              dismiss();
            },
          ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);

    _sub?.cancel();
    _sub = callBloc.stream.listen((state) {
      if (state is CallEndedState ||
          state is CallErrorState ||
          state is CallInitial) {
        dismiss();
      }
    });
  }

  static void expand(BuildContext context) {
    dismiss();
    final targetCallId = _lastConnectedState?.callId;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => CallScreen(callId: targetCallId, isIncoming: false),
      ),
    );
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
    _sub?.cancel();
    _sub = null;
  }
}
