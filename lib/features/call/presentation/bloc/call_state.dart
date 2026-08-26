import 'package:equatable/equatable.dart';
import '../../domain/entities/call_entity.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object?> get props => [];
}

class CallInitial extends CallState {
  const CallInitial();
}

class CallOutgoingState extends CallState {
  final String callId;
  final String targetUserId;
  final String targetUserName;
  final String? targetUserAvatar;
  final CallType callType;

  const CallOutgoingState({
    required this.callId,
    required this.targetUserId,
    required this.targetUserName,
    this.targetUserAvatar,
    required this.callType,
  });

  @override
  List<Object?> get props => [
    callId,
    targetUserId,
    targetUserName,
    targetUserAvatar,
    callType,
  ];
}

class CallIncomingState extends CallState {
  final String callId;
  final String callerId;
  final String callerName;
  final String? callerAvatar;
  final CallType callType;

  const CallIncomingState({
    required this.callId,
    required this.callerId,
    required this.callerName,
    this.callerAvatar,
    required this.callType,
  });

  @override
  List<Object?> get props => [
    callId,
    callerId,
    callerName,
    callerAvatar,
    callType,
  ];
}

class CallConnectedState extends CallState {
  final String callId;
  final String peerName;
  final String? peerAvatar;
  final CallType callType;
  final bool isMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final bool isFrontCamera;

  const CallConnectedState({
    required this.callId,
    required this.peerName,
    this.peerAvatar,
    required this.callType,
    this.isMuted = false,
    this.isCameraOff = false,
    this.isSpeakerOn = false,
    this.isFrontCamera = true,
  });

  CallConnectedState copyWith({
    String? callId,
    String? peerName,
    String? peerAvatar,
    CallType? callType,
    bool? isMuted,
    bool? isCameraOff,
    bool? isSpeakerOn,
    bool? isFrontCamera,
  }) {
    return CallConnectedState(
      callId: callId ?? this.callId,
      peerName: peerName ?? this.peerName,
      peerAvatar: peerAvatar ?? this.peerAvatar,
      callType: callType ?? this.callType,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
    );
  }

  @override
  List<Object?> get props => [
    callId,
    peerName,
    peerAvatar,
    callType,
    isMuted,
    isCameraOff,
    isSpeakerOn,
    isFrontCamera,
  ];
}

class CallEndedState extends CallState {
  final String reason;

  const CallEndedState({this.reason = 'Call ended'});

  @override
  List<Object?> get props => [reason];
}

class CallErrorState extends CallState {
  final String message;

  const CallErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
