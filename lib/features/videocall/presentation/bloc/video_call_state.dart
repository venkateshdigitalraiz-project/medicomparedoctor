part of 'video_call_bloc.dart';

class VideoCallState {
  final String callerName;
  final Duration elapsed;
  final bool isSpeakerOn;
  final bool isMicOn;
  final bool isCameraOn;
  final bool callEnded;

  const VideoCallState({
    required this.callerName,
    required this.elapsed,
    required this.isSpeakerOn,
    required this.isMicOn,
    required this.isCameraOn,
    required this.callEnded,
  });

  factory VideoCallState.initial({String callerName = 'Dr. Sheila Lemke'}) {
    return VideoCallState(
      callerName: callerName,
      elapsed: Duration.zero,
      isSpeakerOn: true,
      isMicOn: true,
      isCameraOn: true,
      callEnded: false,
    );
  }

  String get formattedTime {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  VideoCallState copyWith({
    String? callerName,
    Duration? elapsed,
    bool? isSpeakerOn,
    bool? isMicOn,
    bool? isCameraOn,
    bool? callEnded,
  }) {
    return VideoCallState(
      callerName: callerName ?? this.callerName,
      elapsed: elapsed ?? this.elapsed,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isMicOn: isMicOn ?? this.isMicOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      callEnded: callEnded ?? this.callEnded,
    );
  }
}
