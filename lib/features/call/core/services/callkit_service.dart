import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import '../../../../core/constants/app_constants.dart';

class CallKitService {
  Function(String callId, Map<String, dynamic>? extra)? onCallAccepted;
  Function(String callId, Map<String, dynamic>? extra)? onCallDeclined;
  Function(String callId, Map<String, dynamic>? extra)? onCallEnded;
  Function(String callId, Map<String, dynamic>? extra)? onCallTimeout;

  static Future<void> sendHttpReject({
    required String callId,
    String reason = 'Declined via CallKit',
  }) async {
    if (callId.isEmpty) return;
    try {
      final client = HttpClient();
      final url = '${AppConstants.baseUrl}/calls/reject';
      final request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/json');
      request.write(jsonEncode({'callId': callId, 'reason': reason}));
      final response = await request.close();
      debugPrint(
        '📞 [CallKitService] Background HTTP Reject dispatched for $callId (status: ${response.statusCode})',
      );
    } catch (e) {
      debugPrint('⚠️ [CallKitService] HTTP Reject error: $e');
    }
  }

  void initCallKitListeners() {
    try {
      FlutterCallkitIncoming.onEvent.listen((dynamic event) {
        if (event == null) return;

        try {
          final callId = _extractCallId(event);
          final extra = _extractExtra(event);

          if (event is CallEventActionCallAccept) {
            debugPrint('📞 CallKit: Call Accepted: $callId');
            onCallAccepted?.call(callId, extra);
          } else if (event is CallEventActionCallDecline) {
            debugPrint('📞 CallKit: Call Declined: $callId');
            sendHttpReject(callId: callId, reason: 'Declined via CallKit');
            onCallDeclined?.call(callId, extra);
          } else if (event is CallEventActionCallEnded) {
            debugPrint('📞 CallKit: Call Ended: $callId');
            onCallEnded?.call(callId, extra);
          } else if (event is CallEventActionCallTimeout) {
            debugPrint('📞 CallKit: Call Timeout: $callId');
            sendHttpReject(callId: callId, reason: 'Call timed out');
            onCallTimeout?.call(callId, extra);
          }
        } catch (e) {
          debugPrint('Error parsing CallKit event: $e');
        }
      });
    } catch (e) {
      debugPrint('Error initializing CallKit listener: $e');
    }
  }

  String _extractCallId(dynamic event) {
    if (event == null) return '';

    String? findId(dynamic target) {
      if (target == null) return null;
      if (target is String && target.trim().isNotEmpty) {
        if (target.contains('{')) {
          try {
            final decoded = jsonDecode(target);
            return findId(decoded);
          } catch (_) {}
        }
        return target.trim();
      }
      if (target is Map) {
        final id =
            target['id']?.toString() ??
            target['callId']?.toString() ??
            target['call_id']?.toString();
        if (id != null && id.trim().isNotEmpty) return id.trim();

        final extra = target['extra'];
        if (extra != null) {
          final extraId = findId(extra);
          if (extraId != null && extraId.trim().isNotEmpty)
            return extraId.trim();
        }
      }
      return null;
    }

    try {
      final body = (event as dynamic).body;
      final id = findId(body);
      if (id != null && id.isNotEmpty) return id;
    } catch (_) {}

    try {
      final params = (event as dynamic).params;
      final id = findId(params);
      if (id != null && id.isNotEmpty) return id;
    } catch (_) {}

    try {
      final data = (event as dynamic).data;
      final id = findId(data);
      if (id != null && id.isNotEmpty) return id;
    } catch (_) {}

    try {
      final id = (event as dynamic).id?.toString();
      if (id != null && id.trim().isNotEmpty) return id.trim();
    } catch (_) {}

    return '';
  }

  Map<String, dynamic>? _extractExtra(dynamic event) {
    if (event == null) return null;

    Map<String, dynamic>? parseExtra(dynamic extra) {
      if (extra == null) return null;
      if (extra is Map) {
        return Map<String, dynamic>.from(extra);
      }
      if (extra is String && extra.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(extra);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded);
          }
        } catch (_) {}
      }
      return null;
    }

    try {
      final body = (event as dynamic).body;
      if (body is Map) {
        final res = parseExtra(body['extra']);
        if (res != null) return res;
      }
    } catch (_) {}

    try {
      final params = (event as dynamic).params;
      if (params is Map) {
        final res = parseExtra(params['extra']);
        if (res != null) return res;
      }
    } catch (_) {}

    return null;
  }

  Future<void> showIncomingCall({
    required String callId,
    required String callerName,
    required String callerId,
    String? callerAvatar,
    required bool isVideo,
  }) async {
    final CallKitParams callKitParams = CallKitParams(
      id: callId,
      nameCaller: callerName,
      appName: 'MediCompare Doctor',
      avatar:
          (callerAvatar != null && callerAvatar.isNotEmpty) ? callerAvatar : '',
      handle: isVideo ? 'Incoming Video Call' : 'Incoming Audio Call',
      type: isVideo ? 1 : 0, // 0 - Audio, 1 - Video
      duration: 45000, // 45 seconds ringing timeout
      extra: <String, dynamic>{
        'callId': callId,
        'callerId': callerId,
        'callerName': callerName,
        'isVideo': isVideo,
      },
      headers: <String, dynamic>{'apiKey': 'medicompares_call'},
      android: const AndroidParams(
        isCustomNotification: false,
        isShowLogo: false,
        isShowFullLockedScreen: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#8059CA',
        actionColor: '#4CAF50',
        textColor: '#FFFFFF',
        incomingCallNotificationChannelName: 'Incoming Video & Audio Calls',
        missedCallNotificationChannelName: 'Missed Calls',
      ),
      ios: const IOSParams(
        iconName: 'AppIcon',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'videoChat',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  Future<void> endCall(String callId) async {
    await FlutterCallkitIncoming.endCall(callId);
  }

  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  Future<dynamic> getActiveCalls() async {
    return await FlutterCallkitIncoming.activeCalls();
  }
}
