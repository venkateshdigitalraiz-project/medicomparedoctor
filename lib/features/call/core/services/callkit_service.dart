import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallKitService {
  Function(String callId, Map<String, dynamic>? extra)? onCallAccepted;
  Function(String callId, Map<String, dynamic>? extra)? onCallDeclined;
  Function(String callId, Map<String, dynamic>? extra)? onCallEnded;
  Function(String callId, Map<String, dynamic>? extra)? onCallTimeout;

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
            onCallDeclined?.call(callId, extra);
          } else if (event is CallEventActionCallEnded) {
            debugPrint('📞 CallKit: Call Ended: $callId');
            onCallEnded?.call(callId, extra);
          } else if (event is CallEventActionCallTimeout) {
            debugPrint('📞 CallKit: Call Timeout: $callId');
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
    try {
      final params = (event as dynamic).params;
      if (params != null) {
        if (params is Map) {
          return params['id']?.toString() ??
              params['extra']?['callId']?.toString() ??
              '';
        }
        return params.id?.toString() ??
            params.extra?['callId']?.toString() ??
            '';
      }
    } catch (_) {}
    try {
      final body = (event as dynamic).body;
      if (body != null) {
        if (body is Map) {
          return body['id']?.toString() ??
              body['extra']?['callId']?.toString() ??
              '';
        }
        return body.id?.toString() ?? '';
      }
    } catch (_) {}
    try {
      final data = (event as dynamic).data;
      if (data != null) {
        if (data is Map) {
          return data['id']?.toString() ??
              data['extra']?['callId']?.toString() ??
              '';
        }
        return data.id?.toString() ?? '';
      }
    } catch (_) {}
    try {
      return (event as dynamic).id?.toString() ?? '';
    } catch (_) {}
    return '';
  }

  Map<String, dynamic>? _extractExtra(dynamic event) {
    if (event == null) return null;
    try {
      final params = (event as dynamic).params;
      if (params != null) {
        if (params is Map && params['extra'] is Map) {
          return Map<String, dynamic>.from(params['extra']);
        }
        if (params.extra is Map) {
          return Map<String, dynamic>.from(params.extra);
        }
      }
    } catch (_) {}
    try {
      final body = (event as dynamic).body;
      if (body != null) {
        if (body is Map && body['extra'] is Map) {
          return Map<String, dynamic>.from(body['extra']);
        }
      }
    } catch (_) {}
    try {
      final data = (event as dynamic).data;
      if (data != null) {
        if (data is Map && data['extra'] is Map) {
          return Map<String, dynamic>.from(data['extra']);
        }
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
      avatar: (callerAvatar != null && callerAvatar.isNotEmpty) ? callerAvatar : '',
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
