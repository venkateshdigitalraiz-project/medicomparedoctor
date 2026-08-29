import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../core/services/call_signaling_service.dart';
import '../../domain/entities/call_entity.dart';
import '../../domain/repositories/call_repository.dart';
import '../datasources/call_remote_data_source.dart';

class CallRepositoryImpl implements CallRepository {
  final CallSignalingService signalingService;
  final CallRemoteDataSource remoteDataSource;

  CallRepositoryImpl({
    required this.signalingService,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, CallEntity>> initiateCall({
    required String targetUserId,
    required CallType callType,
    required Map<String, dynamic> offer,
    required String callerName,
    String? callerAvatar,
    String targetUserType = 'user',
  }) async {
    try {
      final response = await signalingService.initiateCall(
        targetUserId: targetUserId,
        callType: callType == CallType.video ? 'video' : 'audio',
        callerName: callerName,
        callerAvatar: callerAvatar,
        offer: offer,
        callerType: 'doctor',
        targetUserType: targetUserType,
      );

      final callId =
          response['callId'] as String? ??
          'call_${DateTime.now().millisecondsSinceEpoch}';

      final entity = CallEntity(
        callId: callId,
        callerId: response['callerId'] ?? '',
        callerName: callerName,
        callerAvatar: callerAvatar,
        calleeId: targetUserId,
        callType: callType,
        status: CallStatus.ringing,
      );

      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPendingCallOffer({
    required String callId,
  }) async {
    try {
      final model = await remoteDataSource.getPendingCallOffer(callId);
      return Right({
        'success': true,
        'callId': model.callId,
        'callerId': model.callerId,
        'callerInfo': {
          'name': model.callerName,
          'avatar': model.callerAvatar,
        },
        'callType': model.callType == CallType.video ? 'video' : 'audio',
        'offer': model.offer,
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> answerCall({
    required String callId,
    required Map<String, dynamic> answer,
  }) async {
    try {
      signalingService.sendAnswer(callId: callId, answer: answer);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectCall({
    required String callId,
    required String reason,
  }) async {
    try {
      // 1. Socket emit (fast foreground path)
      signalingService.rejectCall(callId: callId, reason: reason);
      // 2. REST API fallback (guaranteed background path)
      await remoteDataSource.rejectCall(callId: callId, reason: reason);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> endCall({
    required String callId,
    String? targetUserId,
  }) async {
    try {
      // 1. Socket emit (fast foreground path)
      signalingService.endCall(callId: callId, targetUserId: targetUserId);
      // 2. REST API fallback (guaranteed background path)
      await remoteDataSource.endCall(callId: callId, targetUserId: targetUserId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendIceCandidate({
    required String targetUserId,
    required String callId,
    required Map<String, dynamic> candidate,
  }) async {
    try {
      signalingService.sendIceCandidate(
        targetUserId: targetUserId,
        callId: callId,
        candidate: candidate,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
