part of 'video_call_bloc.dart';

abstract class VideoCallEvent {}

class ToggleSpeaker extends VideoCallEvent {}

class ToggleMic extends VideoCallEvent {}

class ToggleCamera extends VideoCallEvent {}

class EndCall extends VideoCallEvent {}

class _TimerTicked extends VideoCallEvent {}
