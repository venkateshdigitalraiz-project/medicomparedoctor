import '../../domain/entities/call_entity.dart';

class PendingCallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String? callerAvatar;
  final CallType callType;
  final ParticipantType callerType;
  final Map<String, dynamic> offer;

  PendingCallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    this.callerAvatar,
    required this.callType,
    this.callerType = ParticipantType.doctor,
    required this.offer,
  });

  factory PendingCallModel.fromJson(Map<String, dynamic> json) {
    final callerInfo = json['callerInfo'] as Map<String, dynamic>? ?? {};
    final callTypeStr = json['callType'] as String? ?? 'audio';

    return PendingCallModel(
      callId: json['callId']?.toString() ?? '',
      callerId: json['callerId']?.toString() ?? '',
      callerName: callerInfo['name']?.toString() ?? 'Caller',
      callerAvatar: callerInfo['avatar']?.toString(),
      callType: callTypeStr == 'video' ? CallType.video : CallType.audio,
      callerType: participantTypeFromString(json['callerType'] as String?),
      offer:
          json['offer'] is Map
              ? Map<String, dynamic>.from(json['offer'])
              : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerType': participantTypeToString(callerType),
      'callerInfo': {'name': callerName, 'avatar': callerAvatar},
      'callType': callType == CallType.video ? 'video' : 'audio',
      'offer': offer,
    };
  }
}

