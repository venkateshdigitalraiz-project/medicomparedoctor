import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  Timer? _timer;

  VideoCallBloc() : super(VideoCallState.initial()) {
    on<ToggleSpeaker>((event, emit) {
      emit(state.copyWith(isSpeakerOn: !state.isSpeakerOn));
    });

    on<ToggleMic>((event, emit) {
      emit(state.copyWith(isMicOn: !state.isMicOn));
    });

    on<ToggleCamera>((event, emit) {
      emit(state.copyWith(isCameraOn: !state.isCameraOn));
    });

    on<EndCall>((event, emit) {
      _timer?.cancel();
      emit(state.copyWith(callEnded: true));
    });

    on<_TimerTicked>((event, emit) {
      emit(state.copyWith(elapsed: state.elapsed + const Duration(seconds: 1)));
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(_TimerTicked());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
