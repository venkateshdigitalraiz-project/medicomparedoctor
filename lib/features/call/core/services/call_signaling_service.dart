import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class CallSignalingService {
  io.Socket? _socket;
  bool _isConnected = false;

  final _incomingCallController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _callAnsweredController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _iceCandidateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _callRejectedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _callEndedController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get incomingCallStream =>
      _incomingCallController.stream;
  Stream<Map<String, dynamic>> get callAnsweredStream =>
      _callAnsweredController.stream;
  Stream<Map<String, dynamic>> get iceCandidateStream =>
      _iceCandidateController.stream;
  Stream<Map<String, dynamic>> get callRejectedStream =>
      _callRejectedController.stream;
  Stream<Map<String, dynamic>> get callEndedStream =>
      _callEndedController.stream;

  bool get isConnected => _isConnected;

  void initialize({
    required String serverUrl,
    required String userId,
    String? token,
  }) {
    if (_socket != null && _isConnected) return;

    _socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(2000)
          .setAuth({
            if (token != null) 'token': token,
            'userId': userId,
          })
          .setExtraHeaders({
            if (token != null) 'Authorization': 'Bearer $token',
          })
          .build(),
    );

    _socket!.onConnect((_) {
      _isConnected = true;
      debugPrint(
        '🟢 Signaling Socket Connected [ID: ${_socket!.id}] for user: $userId',
      );
      _socket!.emit('call:register', {'userId': userId});
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      debugPrint('🔴 Signaling Socket Disconnected');
    });

    _socket!.onConnectError((err) {
      debugPrint('⚠️ Signaling Socket Connect Error: $err');
    });

    // ─── Incoming Call Listeners ───────────────────────────────────────────────
    _socket!.on('call:incoming', (data) {
      debugPrint('📞 Signaling Event: call:incoming -> $data');
      if (data is Map) {
        _incomingCallController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('call:answered', (data) {
      debugPrint('📞 Signaling Event: call:answered -> $data');
      if (data is Map) {
        _callAnsweredController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('call:ice_candidate', (data) {
      if (data is Map) {
        _iceCandidateController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('call:rejected', (data) {
      debugPrint('📞 Signaling Event: call:rejected -> $data');
      if (data is Map) {
        _callRejectedController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket!.on('call:ended', (data) {
      debugPrint('📞 Signaling Event: call:ended -> $data');
      if (data is Map) {
        _callEndedController.add(Map<String, dynamic>.from(data));
      }
    });
  }

  // ─── Emitter Methods ────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> initiateCall({
    required String targetUserId,
    required String callType,
    required String callerName,
    String? callerAvatar,
    required Map<String, dynamic> offer,
  }) async {
    final completer = Completer<Map<String, dynamic>>();

    final payload = {
      'targetUserId': targetUserId,
      'callType': callType,
      'callerInfo': {'name': callerName, 'avatar': callerAvatar},
      'offer': offer,
    };

    if (_socket != null && _socket!.connected) {
      _socket!.emitWithAck(
        'call:initiate',
        payload,
        ack: (response) {
          if (response is Map) {
            completer.complete(Map<String, dynamic>.from(response));
          } else {
            completer.complete({'success': true});
          }
        },
      );
    } else {
      completer.completeError('Socket not connected');
    }

    return completer.future;
  }

  void sendAnswer({
    required String callId,
    required Map<String, dynamic> answer,
  }) {
    _socket?.emit('call:answer', {'callId': callId, 'answer': answer});
  }

  void sendIceCandidate({
    required String targetUserId,
    required String callId,
    required Map<String, dynamic> candidate,
  }) {
    _socket?.emit('call:ice_candidate', {
      'targetUserId': targetUserId,
      'callId': callId,
      'candidate': candidate,
    });
  }

  void rejectCall({required String callId, required String reason}) {
    _socket?.emit('call:reject', {'callId': callId, 'reason': reason});
  }

  void endCall({required String callId}) {
    _socket?.emit('call:end', {'callId': callId});
  }

  void dispose() {
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;

    _incomingCallController.close();
    _callAnsweredController.close();
    _iceCandidateController.close();
    _callRejectedController.close();
    _callEndedController.close();
  }
}
