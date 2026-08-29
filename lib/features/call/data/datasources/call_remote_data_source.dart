import 'package:dio/dio.dart';
import 'package:medicompare/core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

import '../models/pending_call_model.dart';

abstract class CallRemoteDataSource {
  Future<PendingCallModel> getPendingCallOffer(String callId);
  Future<void> rejectCall({required String callId, String reason});
  Future<void> endCall({required String callId, String? targetUserId});
}

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  final Dio dio;

  CallRemoteDataSourceImpl({required this.dio});

  @override
  Future<PendingCallModel> getPendingCallOffer(String callId) async {
    try {
      final url =
          '${AppConstants.baseUrl}${AppConstants.pendingCallOffer}$callId';
      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null && data is Map<String, dynamic>) {
          return PendingCallModel.fromJson(data);
        } else {
          throw ServerException('Invalid pending call response format');
        }
      } else {
        throw ServerException(
          response.data?['message'] ?? 'Call session not found or expired',
        );
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ??
          e.message ??
          'Failed to retrieve call offer';
      throw ServerException(msg);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> rejectCall({
    required String callId,
    String reason = 'Declined',
  }) async {
    try {
      await dio.post(
        '${AppConstants.baseUrl}/calls/reject',
        data: {'callId': callId, 'reason': reason},
      );
    } catch (e) {
      // Non-fatal if socket already handled
    }
  }

  @override
  Future<void> endCall({
    required String callId,
    String? targetUserId,
  }) async {
    try {
      await dio.post(
        '${AppConstants.baseUrl}/calls/end',
        data: {
          'callId': callId,
          if (targetUserId != null) 'targetUserId': targetUserId,
        },
      );
    } catch (e) {
      // Non-fatal if socket already handled
    }
  }
}
