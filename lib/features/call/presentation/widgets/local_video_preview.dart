import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class LocalVideoPreview extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool isCameraOff;

  const LocalVideoPreview({
    super.key,
    required this.renderer,
    required this.isCameraOff,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 110,
        height: 155,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child:
            isCameraOff
                ? const Center(
                  child: Icon(
                    Icons.videocam_off_rounded,
                    color: Colors.white70,
                    size: 32,
                  ),
                )
                : RTCVideoView(
                  renderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
      ),
    );
  }
}
