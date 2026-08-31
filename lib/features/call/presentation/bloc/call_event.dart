import 'package:equatable/equatable.dart';
import '../../domain/entities/call_entity.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCallServiceEvent extends CallEvent {
  final String serverUrl;
  final String userId;
  final String? token;

  const InitializeCallServiceEvent({
    required this.serverUrl,
    required this.userId,
    this.token,
  });

  @override
  List<Object?> get props => [serverUrl, userId, token];
}

class DisconnectCallServiceEvent extends CallEvent {
  const DisconnectCallServiceEvent();
}

class AutoConnectCallServiceEvent extends CallEvent {
  const AutoConnectCallServiceEvent();
}

class StartOutgoingCallEvent extends CallEvent {
  final String targetUserId;
  final String targetUserName;
  final String? targetUserAvatar;
  final String callerName;
  final String? callerAvatar;
  final CallType callType;
  final String targetUserType;
  final String? appointmentId;

  const StartOutgoingCallEvent({
    required this.targetUserId,
    required this.targetUserName,
    this.targetUserAvatar,
    this.callerName = 'Doctor',
    this.callerAvatar,
    required this.callType,
    this.targetUserType = 'user',
    this.appointmentId,
  });

  @override
  List<Object?> get props => [
    targetUserId,
    targetUserName,
    targetUserAvatar,
    callerName,
    callerAvatar,
    callType,
    targetUserType,
    appointmentId,
  ];
}

class IncomingCallDetectedEvent extends CallEvent {
  final Map<String, dynamic> data;

  const IncomingCallDetectedEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class AcceptCallEvent extends CallEvent {
  final String callId;

  const AcceptCallEvent({required this.callId});

  @override
  List<Object?> get props => [callId];
}

class RejectCallEvent extends CallEvent {
  final String callId;
  final String reason;

  const RejectCallEvent({required this.callId, this.reason = 'declined'});

  @override
  List<Object?> get props => [callId, reason];
}

class EndCallEvent extends CallEvent {
  const EndCallEvent();
}

class RemoteCallAnsweredEvent extends CallEvent {
  final Map<String, dynamic> answerData;

  const RemoteCallAnsweredEvent({required this.answerData});

  @override
  List<Object?> get props => [answerData];
}

class RemoteIceCandidateReceivedEvent extends CallEvent {
  final Map<String, dynamic> candidateData;

  const RemoteIceCandidateReceivedEvent({required this.candidateData});

  @override
  List<Object?> get props => [candidateData];
}

class RemoteCallEndedEvent extends CallEvent {
  final String reason;

  const RemoteCallEndedEvent({this.reason = 'Call ended by remote user'});

  @override
  List<Object?> get props => [reason];
}

class ToggleMicEvent extends CallEvent {
  const ToggleMicEvent();
}

class ToggleCameraEvent extends CallEvent {
  const ToggleCameraEvent();
}

class SwitchCameraEvent extends CallEvent {
  const SwitchCameraEvent();
}

class ToggleSpeakerEvent extends CallEvent {
  const ToggleSpeakerEvent();
}
