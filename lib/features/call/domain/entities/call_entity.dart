import 'package:equatable/equatable.dart';

enum CallType { audio, video }

enum CallStatus { ringing, connected, ended, rejected, missed }

class CallEntity extends Equatable {
  final String callId;
  final String callerId;
  final String callerName;
  final String? callerAvatar;
  final String calleeId;
  final CallType callType;
  final CallStatus status;
  final DateTime? startedAt;

  const CallEntity({
    required this.callId,
    required this.callerId,
    required this.callerName,
    this.callerAvatar,
    required this.calleeId,
    required this.callType,
    this.status = CallStatus.ringing,
    this.startedAt,
  });

  @override
  List<Object?> get props => [
    callId,
    callerId,
    callerName,
    callerAvatar,
    calleeId,
    callType,
    status,
    startedAt,
  ];
}
