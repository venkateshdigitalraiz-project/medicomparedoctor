import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/call_entity.dart';

abstract class CallRepository {
  Future<Either<Failure, CallEntity>> initiateCall({
    required String targetUserId,
    required CallType callType,
    required Map<String, dynamic> offer,
    required String callerName,
    String? callerAvatar,
  });

  Future<Either<Failure, Map<String, dynamic>>> getPendingCallOffer({
    required String callId,
  });

  Future<Either<Failure, void>> answerCall({
    required String callId,
    required Map<String, dynamic> answer,
  });

  Future<Either<Failure, void>> rejectCall({
    required String callId,
    required String reason,
  });

  Future<Either<Failure, void>> endCall({
    required String callId,
  });

  Future<Either<Failure, void>> sendIceCandidate({
    required String targetUserId,
    required String callId,
    required Map<String, dynamic> candidate,
  });
}
