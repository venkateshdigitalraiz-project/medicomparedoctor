import 'package:flutter/material.dart';

class CallControls extends StatelessWidget {
  final bool isVideo;
  final bool isMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleCamera;
  final VoidCallback onSwitchCamera;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onEndCall;

  const CallControls({
    super.key,
    required this.isVideo,
    required this.isMuted,
    required this.isCameraOff,
    required this.isSpeakerOn,
    required this.onToggleMute,
    required this.onToggleCamera,
    required this.onSwitchCamera,
    required this.onToggleSpeaker,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mute Audio
          _buildControlButton(
            icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            isActive: isMuted,
            onTap: onToggleMute,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withValues(alpha: 0.2),
            iconColor: isMuted ? Colors.black : Colors.white,
          ),
          const SizedBox(width: 14),

          // Speaker Toggle
          _buildControlButton(
            icon:
                isSpeakerOn
                    ? Icons.volume_up_rounded
                    : Icons.volume_down_rounded,
            isActive: isSpeakerOn,
            onTap: onToggleSpeaker,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withValues(alpha: 0.2),
            iconColor: isSpeakerOn ? Colors.black : Colors.white,
          ),
          const SizedBox(width: 14),

          if (isVideo) ...[
            // Camera On/Off
            _buildControlButton(
              icon:
                  isCameraOff
                      ? Icons.videocam_off_rounded
                      : Icons.videocam_rounded,
              isActive: isCameraOff,
              onTap: onToggleCamera,
              activeColor: Colors.white,
              inactiveColor: Colors.white.withValues(alpha: 0.2),
              iconColor: isCameraOff ? Colors.black : Colors.white,
            ),
            const SizedBox(width: 14),

            // Flip Camera
            _buildControlButton(
              icon: Icons.flip_camera_ios_rounded,
              isActive: false,
              onTap: onSwitchCamera,
              activeColor: Colors.white,
              inactiveColor: Colors.white.withValues(alpha: 0.2),
              iconColor: Colors.white,
            ),
            const SizedBox(width: 14),
          ],

          // End Call Button
          _buildControlButton(
            icon: Icons.call_end_rounded,
            isActive: true,
            onTap: onEndCall,
            activeColor: const Color(0xFFFF3B30),
            inactiveColor: const Color(0xFFFF3B30),
            iconColor: Colors.white,
            size: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required Color activeColor,
    required Color inactiveColor,
    required Color iconColor,
    double size = 48,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          shape: BoxShape.circle,
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }
}
