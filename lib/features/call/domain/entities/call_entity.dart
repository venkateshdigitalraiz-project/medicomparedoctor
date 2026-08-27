import 'package:equatable/equatable.dart';

enum CallType { audio, video }

enum CallStatus { ringing, connected, ended, rejected, missed }

/// Identifies the type of participant in a call (user, doctor, or future types).
/// Used by the backend to resolve the correct model for FCM tokens, online status, etc.
enum ParticipantType { user, doctor }

class CallEntity extends Equatable {
  final String callId;
  final String callerId;
  final String callerName;
  final String? callerAvatar;
  final String calleeId;
  final CallType callType;
  final CallStatus status;
  final DateTime? startedAt;
  final ParticipantType callerType;
  final ParticipantType calleeType;

  const CallEntity({
    required this.callId,
    required this.callerId,
    required this.callerName,
    this.callerAvatar,
    required this.calleeId,
    required this.callType,
    this.status = CallStatus.ringing,
    this.startedAt,
    this.callerType = ParticipantType.doctor,
    this.calleeType = ParticipantType.user,
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
    callerType,
    calleeType,
  ];
}

/// Helper to convert string to ParticipantType
ParticipantType participantTypeFromString(String? value) {
  switch (value) {
    case 'doctor':
      return ParticipantType.doctor;
    case 'user':
    default:
      return ParticipantType.user;
  }
}

/// Helper to convert ParticipantType to string
String participantTypeToString(ParticipantType type) {
  switch (type) {
    case ParticipantType.doctor:
      return 'doctor';
    case ParticipantType.user:
      return 'user';
  }
}

