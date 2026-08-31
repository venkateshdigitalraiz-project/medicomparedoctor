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
  final String? appointmentId;

  const CallOutgoingState({
    required this.callId,
    required this.targetUserId,
    required this.targetUserName,
    this.targetUserAvatar,
    required this.callType,
    this.appointmentId,
  });

  @override
  List<Object?> get props => [
    callId,
    targetUserId,
    targetUserName,
    targetUserAvatar,
    callType,
    appointmentId,
  ];
}

class CallIncomingState extends CallState {
  final String callId;
  final String callerId;
  final String callerName;
  final String? callerAvatar;
  final CallType callType;
  final String? appointmentId;

  const CallIncomingState({
    required this.callId,
    required this.callerId,
    required this.callerName,
    this.callerAvatar,
    required this.callType,
    this.appointmentId,
  });

  @override
  List<Object?> get props => [
    callId,
    callerId,
    callerName,
    callerAvatar,
    callType,
    appointmentId,
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
  final DateTime connectedAt;
  final String? appointmentId;

  CallConnectedState({
    required this.callId,
    required this.peerName,
    this.peerAvatar,
    required this.callType,
    this.isMuted = false,
    this.isCameraOff = false,
    this.isSpeakerOn = false,
    this.isFrontCamera = true,
    DateTime? connectedAt,
    this.appointmentId,
  }) : connectedAt = connectedAt ?? DateTime.now();

  CallConnectedState copyWith({
    String? callId,
    String? peerName,
    String? peerAvatar,
    CallType? callType,
    bool? isMuted,
    bool? isCameraOff,
    bool? isSpeakerOn,
    bool? isFrontCamera,
    DateTime? connectedAt,
    String? appointmentId,
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
      connectedAt: connectedAt ?? this.connectedAt,
      appointmentId: appointmentId ?? this.appointmentId,
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
    connectedAt,
    appointmentId,
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
