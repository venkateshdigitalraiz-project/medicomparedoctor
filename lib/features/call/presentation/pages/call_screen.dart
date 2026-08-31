import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:medicompare/core/routes/router_name.dart';
import 'package:medicompare/features/appointment_notes/presentation/widgets/appointment_notes_bottom_sheet.dart';
import '../../core/services/webrtc_service.dart';
import '../../domain/entities/call_entity.dart';
import '../bloc/call_bloc.dart';
import '../bloc/call_event.dart';
import '../bloc/call_state.dart';
import '../widgets/call_controls.dart';
import '../widgets/local_video_preview.dart';
import '../widgets/call_session_manager.dart';
import '../widgets/call_timer_text.dart';

class CallScreen extends StatefulWidget {
  final String? callId;
  final bool isIncoming;

  const CallScreen({super.key, this.callId, this.isIncoming = false});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    if (widget.callId != null && widget.isIncoming) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = context.read<CallBloc>().state;
        if (state is! CallConnectedState) {
          context.read<CallBloc>().add(AcceptCallEvent(callId: widget.callId!));
        }
      });
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final webrtc = context.read<CallBloc>().webrtcService;

    return BlocConsumer<CallBloc, CallState>(
      listener: (context, state) {
        if (state is CallEndedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.reason),
              backgroundColor: Colors.black87,
              duration: const Duration(seconds: 2),
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(
              context,
            ).pushReplacementNamed(RouteNames.homeBottomNav);
          }
        } else if (state is CallErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(
              context,
            ).pushReplacementNamed(RouteNames.homeBottomNav);
          }
        }
      },
      builder: (context, state) {
        if (state is CallOutgoingState) {
          return _buildOutgoingRingingView(context, state);
        }

        if (state is CallConnectedState) {
          return _buildActiveSessionView(context, state, webrtc);
        }

        return const Scaffold(
          backgroundColor: Color(0xFF14121E),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF8059CA)),
          ),
        );
      },
    );
  }

  // ─── 1. Outgoing Ringing View (Caller waiting for Callee to answer) ───────
  Widget _buildOutgoingRingingView(
    BuildContext context,
    CallOutgoingState state,
  ) {
    final isVideo = state.callType == CallType.video;

    return Scaffold(
      backgroundColor: const Color(0xFF12101A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8059CA).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVideo
                          ? Icons.videocam_rounded
                          : Icons.phone_forwarded_rounded,
                      color: const Color(0xFF8059CA),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Calling ${isVideo ? "Video" : "Audio"}...',
                      style: const TextStyle(
                        color: Color(0xFF8059CA),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: _rippleController,
                builder: (context, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 174,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140 + (_rippleController.value * 34),
                          height: 140 + (_rippleController.value * 34),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF8059CA).withValues(
                              alpha: 0.25 * (1.0 - _rippleController.value),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(
                            0xFF8059CA,
                          ).withValues(alpha: 0.3),
                          backgroundImage:
                              state.targetUserAvatar != null
                                  ? NetworkImage(state.targetUserAvatar!)
                                  : null,
                          child:
                              state.targetUserAvatar == null
                                  ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              Text(
                state.targetUserName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ringing...',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.read<CallBloc>().add(const EndCallEvent());
                },
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3B30),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x66FF3B30),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.call_end_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 2. Active Connected Call Session View (Live Audio / Video P2P) ─────────
  Widget _buildActiveSessionView(
    BuildContext context,
    CallConnectedState state,
    WebRTCService webrtc,
  ) {
    final isVideo = state.callType == CallType.video;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        CallSessionManager.minimize(context, state: state);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacementNamed(RouteNames.homeBottomNav);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Remote Video or Audio Gradient
            if (isVideo)
              Positioned.fill(
                child:
                    webrtc.remoteRenderer != null
                        ? RTCVideoView(
                          webrtc.remoteRenderer!,
                          objectFit:
                              RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        )
                        : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF8059CA),
                          ),
                        ),
              )
            else
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1F1235), Color(0xFF0D0A14)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: const Color(
                          0xFF8059CA,
                        ).withValues(alpha: 0.25),
                        backgroundImage:
                            state.peerAvatar != null
                                ? NetworkImage(state.peerAvatar!)
                                : null,
                        child:
                            state.peerAvatar == null
                                ? const Icon(
                                  Icons.person,
                                  size: 64,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        state.peerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Color(0xFF34C759),
                            ),
                            const SizedBox(width: 6),
                            CallTimerText(
                              connectedAt: state.connectedAt,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Header with Connected Status & Minimize Button
            Positioned(
              top: 48,
              left: 20,
              right: 20,
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            CallSessionManager.minimize(context, state: state);
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(RouteNames.homeBottomNav);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.fullscreen_exit_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.peerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(color: Colors.black54, blurRadius: 6),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF34C759),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Connected',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            final apptId =
                                state.appointmentId ?? state.callId;
                            showAppointmentNotesBottomSheet(
                              context,
                              appointmentId: apptId,
                              patientName: state.peerName,
                              subtitle: 'Active Call',
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C4CF1).withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.edit_note_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Notes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Floating PIP Local Camera Preview (For Video Calls)
            if (isVideo && webrtc.localRenderer != null)
              Positioned(
                top: 52,
                right: 16,
                child: LocalVideoPreview(
                  renderer: webrtc.localRenderer!,
                  isCameraOff: state.isCameraOff,
                ),
              ),

            // Tactile Call Controls
            Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(
                child: CallControls(
                  isVideo: isVideo,
                  isMuted: state.isMuted,
                  isCameraOff: state.isCameraOff,
                  isSpeakerOn: state.isSpeakerOn,
                  onToggleMute:
                      () =>
                          context.read<CallBloc>().add(const ToggleMicEvent()),
                  onToggleCamera:
                      () => context.read<CallBloc>().add(
                        const ToggleCameraEvent(),
                      ),
                  onSwitchCamera:
                      () => context.read<CallBloc>().add(
                        const SwitchCameraEvent(),
                      ),
                  onToggleSpeaker:
                      () => context.read<CallBloc>().add(
                        const ToggleSpeakerEvent(),
                      ),
                  onEndCall:
                      () => context.read<CallBloc>().add(const EndCallEvent()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
