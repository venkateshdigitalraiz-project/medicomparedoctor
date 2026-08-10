import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/videocall/presentation/bloc/video_call_bloc.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoCallBloc(),
      child: const _VideoCallView(),
    );
  }
}

class _VideoCallView extends StatelessWidget {
  const _VideoCallView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<VideoCallBloc, VideoCallState>(
        listener: (context, state) {
          if (state.callEnded) {
            Navigator.of(context).maybePop();
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ---- Main remote video (full screen) ----
              _RemoteVideo(),

              // ---- Dark gradient for text legibility ----
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black45,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black26,
                    ],
                    stops: [0.0, 0.2, 0.6, 1.0],
                  ),
                ),
              ),

              // ---- Top bar ----
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Video Call',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // balances the back button
                    ],
                  ),
                ),
              ),

              // ---- Caller name + timer ----
              Align(
                alignment: const Alignment(0, -0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.callerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        state.formattedTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Local self-view thumbnail ----
              Positioned(
                right: 16,
                bottom: 140,
                child: _SelfView(isCameraOn: state.isCameraOn),
              ),

              // ---- Bottom control bar ----
              Align(
                alignment: Alignment.bottomCenter,
                child: _ControlBar(state: state),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Full-screen remote participant video.
/// Replace the DecorationImage with your actual video renderer / asset.
class _RemoteVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDBC3B4), Color(0xFFBFA290)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.person, size: 160, color: Colors.white54),
      ),
      // To use a real photo/video feed instead, swap this widget for:
      // Image.asset('assets/doctor.jpg', fit: BoxFit.cover)
      // or your RTCVideoRenderer / CameraPreview widget.
    );
  }
}

/// Small local self-view video, bottom right (picture-in-picture).
class _SelfView extends StatelessWidget {
  final bool isCameraOn;
  const _SelfView({required this.isCameraOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isCameraOn
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5E6D8), Color(0xFFD9BFA8)],
                ),
              ),
              child: const Center(
                child: Icon(Icons.person, size: 48, color: Colors.white70),
              ),
              // Replace with your own local camera preview widget.
            )
          : Container(
              color: Colors.black87,
              child: const Center(
                child: Icon(Icons.videocam_off, color: Colors.white54),
              ),
            ),
    );
  }
}

/// Bottom rounded control panel with speaker, mic, camera and end-call actions.
class _ControlBar extends StatelessWidget {
  final VideoCallState state;
  const _ControlBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<VideoCallBloc>();

    return Container(
      padding: const EdgeInsets.only(top: 22, bottom: 34, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CircleButton(
            icon: state.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
            background: Colors.black,
            iconColor: Colors.white,
            onTap: () => bloc.add(ToggleSpeaker()),
          ),
          _CircleButton(
            icon: state.isMicOn ? Icons.mic : Icons.mic_off,
            background: Colors.black,
            iconColor: Colors.white,
            onTap: () => bloc.add(ToggleMic()),
          ),
          _CircleButton(
            icon: state.isCameraOn ? Icons.videocam : Icons.videocam_off,
            background: Colors.black,
            iconColor: Colors.white,
            onTap: () => bloc.add(ToggleCamera()),
          ),
          _CircleButton(
            icon: Icons.call_end,
            background: const Color(0xFFFF5A5F),
            iconColor: Colors.white,
            size: 62,
            onTap: () => bloc.add(EndCall()),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final double size;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: size * 0.42),
      ),
    );
  }
}
