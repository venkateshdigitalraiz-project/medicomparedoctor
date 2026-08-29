import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:medicompare/core/constants/app_constants.dart';

import 'package:medicompare/core/globals.dart';
import 'package:medicompare/core/services/session_manager.dart';

import 'package:medicompare/core/storage/local_storage_service.dart';
import '../pages/call_screen.dart';
import '../widgets/call_session_manager.dart';
import '../../core/services/call_signaling_service.dart';
import '../../core/services/callkit_service.dart';
import '../../core/services/webrtc_service.dart';
import '../../domain/entities/call_entity.dart';
import '../../domain/repositories/call_repository.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final WebRTCService webrtcService;
  final CallKitService callKitService;
  final CallSignalingService signalingService;
  final CallRepository callRepository;

  StreamSubscription? _incomingSub;
  StreamSubscription? _answeredSub;
  StreamSubscription? _iceSub;
  StreamSubscription? _rejectedSub;
  StreamSubscription? _endedSub;

  String? _currentCallId;
  String? _targetUserId;
  final List<RTCIceCandidate> _pendingOutgoingIceCandidates = [];
  Timer? _peerDisconnectTimer;

  CallBloc({
    required this.webrtcService,
    required this.callKitService,
    required this.signalingService,
    required this.callRepository,
  }) : super(const CallInitial()) {
    on<InitializeCallServiceEvent>(_onInitialize);
    on<DisconnectCallServiceEvent>(_onDisconnect);
    on<AutoConnectCallServiceEvent>(
      (event, emit) async => await _autoConnectSocket(),
    );
    on<StartOutgoingCallEvent>(_onStartOutgoingCall);
    on<IncomingCallDetectedEvent>(_onIncomingCallDetected);
    on<AcceptCallEvent>(_onAcceptCall);
    on<RejectCallEvent>(_onRejectCall);
    on<EndCallEvent>(_onEndCall);
    on<RemoteCallAnsweredEvent>(_onRemoteCallAnswered);
    on<RemoteIceCandidateReceivedEvent>(_onRemoteIceCandidate);
    on<RemoteCallEndedEvent>(_onRemoteCallEnded);
    on<ToggleMicEvent>(_onToggleMic);
    on<ToggleCameraEvent>(_onToggleCamera);
    on<SwitchCameraEvent>(_onSwitchCamera);
    on<ToggleSpeakerEvent>(_onToggleSpeaker);

    _bindWebRTCEvents();
    _bindCallKitEvents();
    _autoConnectSocket();
  }

  Future<void> _autoConnectSocket() async {
    try {
      final userId = await LocalStorageService().getUserId();
      final token = await LocalStorageService().getToken();
      if (userId != null && userId.isNotEmpty) {
        debugPrint(
          '🔌 [CallBloc] Auto-initializing signaling socket for user: $userId',
        );
        add(
          InitializeCallServiceEvent(
            serverUrl: AppConstants.socketUrl,
            userId: userId,
            token: token,
          ),
        );
      }
    } catch (e) {
      debugPrint('⚠️ [CallBloc] Error auto-connecting socket: $e');
    }
  }

  final List<Map<String, dynamic>> _localCandidatePayloads = [];

  void _bindWebRTCEvents() {
    webrtcService.onIceCandidate = (candidate) {
      final map = Map<String, dynamic>.from(candidate.toMap());
      _localCandidatePayloads.add(map);
      if (_currentCallId != null && _targetUserId != null) {
        callRepository.sendIceCandidate(
          targetUserId: _targetUserId!,
          callId: _currentCallId!,
          candidate: map,
        );
      } else {
        _pendingOutgoingIceCandidates.add(candidate);
      }
    };

    webrtcService.onConnectionStateChanged = (state) {
      debugPrint('📶 [CallBloc] WebRTC connection state: $state');
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        _peerDisconnectTimer?.cancel();
        add(const RemoteCallEndedEvent(reason: 'Peer disconnected'));
      } else if (state ==
              RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        _peerDisconnectTimer?.cancel();
        _peerDisconnectTimer = Timer(const Duration(seconds: 3), () {
          if (this.state is CallConnectedState) {
            debugPrint(
              '⚠️ [CallBloc] Peer disconnected for >3s, ending call session',
            );
            add(const RemoteCallEndedEvent(reason: 'Call connection lost'));
          }
        });
      } else if (state ==
          RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _peerDisconnectTimer?.cancel();
      }
    };

    webrtcService.onIceConnectionStateChanged = (state) {
      debugPrint('🧊 [CallBloc] WebRTC ICE connection state: $state');
      if (state == RTCIceConnectionState.RTCIceConnectionStateClosed) {
        _peerDisconnectTimer?.cancel();
        add(const RemoteCallEndedEvent(reason: 'ICE connection closed'));
      } else if (state ==
              RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        _peerDisconnectTimer?.cancel();
        _peerDisconnectTimer = Timer(const Duration(seconds: 3), () {
          if (this.state is CallConnectedState) {
            debugPrint(
              '⚠️ [CallBloc] ICE disconnected for >3s, ending call session',
            );
            add(const RemoteCallEndedEvent(reason: 'Call connection lost'));
          }
        });
      } else if (state ==
          RTCIceConnectionState.RTCIceConnectionStateConnected) {
        _peerDisconnectTimer?.cancel();
      }
    };
  }

  void _rebroadcastLocalCandidates() {
    if (_currentCallId == null ||
        _targetUserId == null ||
        _localCandidatePayloads.isEmpty) {
      return;
    }
    final payloads = List<Map<String, dynamic>>.from(_localCandidatePayloads);
    debugPrint(
      '🔄 [CallBloc] Rebroadcasting ${payloads.length} local ICE candidates',
    );
    for (final map in payloads) {
      callRepository.sendIceCandidate(
        targetUserId: _targetUserId!,
        callId: _currentCallId!,
        candidate: map,
      );
    }
  }

  void _flushPendingOutgoingIceCandidates() {
    if (_currentCallId == null ||
        _targetUserId == null ||
        _pendingOutgoingIceCandidates.isEmpty) {
      return;
    }
    final candidates = List<RTCIceCandidate>.from(
      _pendingOutgoingIceCandidates,
    );
    _pendingOutgoingIceCandidates.clear();
    for (final candidate in candidates) {
      callRepository.sendIceCandidate(
        targetUserId: _targetUserId!,
        callId: _currentCallId!,
        candidate: candidate.toMap(),
      );
    }
  }

  void _bindCallKitEvents() {
    callKitService.initCallKitListeners();

    callKitService.onCallAccepted = (callId, extra) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => CallScreen(callId: callId, isIncoming: true),
        ),
      );
    };

    callKitService.onCallDeclined = (callId, extra) {
      add(RejectCallEvent(callId: callId, reason: 'Declined via CallKit'));
    };

    callKitService.onCallEnded = (callId, extra) {
      add(const EndCallEvent());
    };
  }

  void _onInitialize(
    InitializeCallServiceEvent event,
    Emitter<CallState> emit,
  ) {
    signalingService.initialize(
      serverUrl: event.serverUrl,
      userId: event.userId,
      token: event.token,
    );

    _incomingSub?.cancel();
    _answeredSub?.cancel();
    _iceSub?.cancel();
    _rejectedSub?.cancel();
    _endedSub?.cancel();

    _incomingSub = signalingService.incomingCallStream.listen((data) {
      add(IncomingCallDetectedEvent(data: data));
    });

    _answeredSub = signalingService.callAnsweredStream.listen((data) {
      add(RemoteCallAnsweredEvent(answerData: data));
    });

    _iceSub = signalingService.iceCandidateStream.listen((data) {
      add(RemoteIceCandidateReceivedEvent(candidateData: data));
    });

    _rejectedSub = signalingService.callRejectedStream.listen((data) {
      add(RemoteCallEndedEvent(reason: data['reason'] ?? 'Call rejected'));
    });

    _endedSub = signalingService.callEndedStream.listen((data) {
      add(RemoteCallEndedEvent(reason: data['reason'] ?? 'Call ended'));
    });
  }

  void _onDisconnect(
    DisconnectCallServiceEvent event,
    Emitter<CallState> emit,
  ) {
    _incomingSub?.cancel();
    _answeredSub?.cancel();
    _iceSub?.cancel();
    _rejectedSub?.cancel();
    _endedSub?.cancel();
    signalingService.disconnect();
    emit(const CallInitial());
  }

  Future<void> _onStartOutgoingCall(
    StartOutgoingCallEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      _targetUserId = event.targetUserId;
      final isVideo = event.callType == CallType.video;

      // 1. Initialize local media
      await webrtcService.startLocalStream(isVideo: isVideo);

      // 2. Generate local SDP Offer
      final offer = await webrtcService.createOffer();

      // 3. Initiate call on server (offer is saved in PendingCall)
      String callerName = event.callerName;
      String? callerAvatar = event.callerAvatar;

      if (callerName == 'Doctor' ||
          callerName.isEmpty ||
          callerAvatar == null ||
          callerAvatar.isEmpty) {
        final userData = await SessionManager.getUserData();
        if (userData != null) {
          if (callerName == 'Doctor' || callerName.isEmpty) {
            final docName =
                userData['name']?.toString() ??
                '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                    .trim();
            if (docName.isNotEmpty) {
              callerName = docName;
            }
          }
          if (callerAvatar == null || callerAvatar.isEmpty) {
            final img =
                userData['profileImage'] ??
                userData['avatar'] ??
                userData['image'];
            if (img is List && img.isNotEmpty) {
              callerAvatar = img[0].toString();
            } else if (img is String && img.isNotEmpty) {
              callerAvatar = img;
            }
          }
        }
      }

      final result = await callRepository.initiateCall(
        targetUserId: event.targetUserId,
        callType: event.callType,
        callerName: callerName,
        callerAvatar: callerAvatar,
        offer: {'type': offer.type, 'sdp': offer.sdp},
        targetUserType: event.targetUserType,
      );

      result.fold(
        (failure) {
          emit(CallErrorState(message: failure.message));
        },
        (callEntity) {
          _currentCallId = callEntity.callId;
          _flushPendingOutgoingIceCandidates();
          emit(
            CallOutgoingState(
              callId: callEntity.callId,
              targetUserId: event.targetUserId,
              targetUserName: event.targetUserName,
              targetUserAvatar: event.targetUserAvatar,
              callType: event.callType,
            ),
          );
        },
      );
    } catch (e) {
      emit(CallErrorState(message: e.toString()));
    }
  }

  Future<void> _onIncomingCallDetected(
    IncomingCallDetectedEvent event,
    Emitter<CallState> emit,
  ) async {
    final data = event.data;
    final callId = data['callId'] as String? ?? '';
    final callerId = data['callerId'] as String? ?? '';
    final callerInfo = data['callerInfo'] as Map<String, dynamic>? ?? {};
    final callerName = callerInfo['name'] as String? ?? 'Incoming Call';
    final callerAvatar = callerInfo['avatar'] as String?;
    final callTypeStr = data['callType'] as String? ?? 'audio';
    final callType = callTypeStr == 'video' ? CallType.video : CallType.audio;

    _currentCallId = callId;
    _targetUserId = callerId;

    emit(
      CallIncomingState(
        callId: callId,
        callerId: callerId,
        callerName: callerName,
        callerAvatar: callerAvatar,
        callType: callType,
      ),
    );

    // Show native CallKit incoming call notification instead of navigating directly
    callKitService.showIncomingCall(
      callId: callId,
      callerName: callerName,
      callerId: callerId,
      callerAvatar: callerAvatar,
      isVideo: callType == CallType.video,
    );
  }

  Future<void> _onAcceptCall(
    AcceptCallEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      String callId = event.callId.trim();
      if (callId.isEmpty) {
        callId = _currentCallId ?? '';
      }
      if (callId.isEmpty) {
        final activeCalls = await callKitService.getActiveCalls();
        if (activeCalls is List && activeCalls.isNotEmpty) {
          final first = activeCalls.first;
          if (first is Map) {
            callId =
                first['id']?.toString() ?? first['callId']?.toString() ?? '';
          }
        }
      }

      if (callId.isEmpty) {
        emit(const CallErrorState(message: 'Call ID is missing or invalid.'));
        return;
      }

      _currentCallId = callId;

      // 1. Fetch the stored SDP Offer from PendingCall on the server
      final offerResult = await callRepository.getPendingCallOffer(
        callId: callId,
      );

      await offerResult.fold(
        (failure) async {
          emit(CallErrorState(message: failure.message));
        },
        (response) async {
          final offerData = response['offer'] as Map<String, dynamic>;
          final callTypeStr = response['callType'] as String? ?? 'audio';
          final callType =
              callTypeStr == 'video' ? CallType.video : CallType.audio;
          final callerInfo =
              response['callerInfo'] as Map<String, dynamic>? ?? {};
          final callerName = callerInfo['name'] as String? ?? 'Caller';
          final callerAvatar = callerInfo['avatar'] as String?;
          _targetUserId = response['callerId'] as String?;
          _flushPendingOutgoingIceCandidates();

          // 2. Start local stream
          await webrtcService.startLocalStream(
            isVideo: callType == CallType.video,
          );

          // 3. Set remote description (Offer)
          await webrtcService.setRemoteOffer(
            sdp: offerData['sdp'],
            type: offerData['type'],
          );

          // 4. Create local SDP Answer
          final answer = await webrtcService.createAnswer();

          // 5. Send Answer back to server
          await callRepository.answerCall(
            callId: callId,
            answer: {'type': answer.type, 'sdp': answer.sdp},
          );

          _rebroadcastLocalCandidates();

          emit(
            CallConnectedState(
              callId: callId,
              peerName: callerName,
              peerAvatar: callerAvatar,
              callType: callType,
            ),
          );
        },
      );
    } catch (e) {
      emit(CallErrorState(message: e.toString()));
    }
  }

  Future<void> _onRemoteCallAnswered(
    RemoteCallAnsweredEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      dynamic raw = event.answerData;
      dynamic ansRaw = raw is Map ? (raw['answer'] ?? raw) : raw;
      String? sdp;
      String? type;

      if (ansRaw is Map) {
        sdp = ansRaw['sdp']?.toString();
        type = ansRaw['type']?.toString();
      }

      if (sdp == null || type == null) {
        debugPrint('⚠️ [CallBloc] Invalid answer payload received: $raw');
        return;
      }

      debugPrint('📥 [CallBloc] Setting remote answer SDP...');
      await webrtcService.setRemoteAnswer(sdp: sdp, type: type);

      _rebroadcastLocalCandidates();

      if (state is CallOutgoingState) {
        final outgoing = state as CallOutgoingState;
        emit(
          CallConnectedState(
            callId: outgoing.callId,
            peerName: outgoing.targetUserName,
            peerAvatar: outgoing.targetUserAvatar,
            callType: outgoing.callType,
          ),
        );
      }
    } catch (e, st) {
      debugPrint('❌ [CallBloc] Error processing remote answer: $e\n$st');
    }
  }

  Future<void> _onRemoteIceCandidate(
    RemoteIceCandidateReceivedEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      dynamic raw = event.candidateData;
      dynamic candObj = raw is Map ? (raw['candidate'] ?? raw) : raw;

      String? cand;
      String? sdpMid;
      int? sdpMLineIndex;

      if (candObj is Map) {
        cand = candObj['candidate']?.toString();
        sdpMid = candObj['sdpMid']?.toString();
        final mLine = candObj['sdpMLineIndex'];
        sdpMLineIndex =
            mLine is int ? mLine : int.tryParse(mLine?.toString() ?? '');
      } else if (candObj is String && candObj.startsWith('candidate:')) {
        cand = candObj;
      }

      if (cand == null || cand.isEmpty) {
        debugPrint('⚠️ [CallBloc] Ignored empty remote ICE candidate: $raw');
        return;
      }

      final candidate = RTCIceCandidate(cand, sdpMid, sdpMLineIndex);
      await webrtcService.addIceCandidate(candidate);
      debugPrint(
        '📥 [CallBloc] Applied remote ICE candidate: ${cand.split(' ').take(4).join(' ')}',
      );
    } catch (e, st) {
      debugPrint('❌ [CallBloc] Error adding remote ICE candidate: $e\n$st');
    }
  }

  Future<void> _onRejectCall(
    RejectCallEvent event,
    Emitter<CallState> emit,
  ) async {
    await callRepository.rejectCall(callId: event.callId, reason: event.reason);
    await callKitService.endCall(event.callId);
    await _cleanupCall();
    emit(CallEndedState(reason: event.reason));
  }

  Future<void> _onEndCall(EndCallEvent event, Emitter<CallState> emit) async {
    if (_currentCallId != null) {
      await callRepository.endCall(
        callId: _currentCallId!,
        targetUserId: _targetUserId,
      );
      await callKitService.endCall(_currentCallId!);
    }
    await callKitService.endAllCalls();
    await _cleanupCall();
    emit(const CallEndedState(reason: 'Call ended'));
  }

  Future<void> _onRemoteCallEnded(
    RemoteCallEndedEvent event,
    Emitter<CallState> emit,
  ) async {
    if (_currentCallId != null) {
      await callKitService.endCall(_currentCallId!);
    }
    await callKitService.endAllCalls();
    await _cleanupCall();
    emit(CallEndedState(reason: event.reason));
  }

  void _onToggleMic(ToggleMicEvent event, Emitter<CallState> emit) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      final newMuted = !current.isMuted;
      webrtcService.toggleMic(isMuted: newMuted);
      emit(current.copyWith(isMuted: newMuted));
    }
  }

  void _onToggleCamera(ToggleCameraEvent event, Emitter<CallState> emit) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      final newOff = !current.isCameraOff;
      webrtcService.toggleCamera(isOff: newOff);
      emit(current.copyWith(isCameraOff: newOff));
    }
  }

  Future<void> _onSwitchCamera(
    SwitchCameraEvent event,
    Emitter<CallState> emit,
  ) async {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      await webrtcService.switchCamera();
      emit(current.copyWith(isFrontCamera: !current.isFrontCamera));
    }
  }

  void _onToggleSpeaker(ToggleSpeakerEvent event, Emitter<CallState> emit) {
    if (state is CallConnectedState) {
      final current = state as CallConnectedState;
      final newSpeaker = !current.isSpeakerOn;
      webrtcService.toggleSpeakerphone(enableSpeaker: newSpeaker);
      emit(current.copyWith(isSpeakerOn: newSpeaker));
    }
  }

  Future<void> _cleanupCall() async {
    _peerDisconnectTimer?.cancel();
    _peerDisconnectTimer = null;
    _currentCallId = null;
    _targetUserId = null;
    _localCandidatePayloads.clear();
    _pendingOutgoingIceCandidates.clear();
    CallSessionManager.dismiss();
    await webrtcService.dispose();
  }

  @override
  Future<void> close() async {
    _incomingSub?.cancel();
    _answeredSub?.cancel();
    _iceSub?.cancel();
    _rejectedSub?.cancel();
    _endedSub?.cancel();
    await _cleanupCall();
    signalingService.dispose();
    return super.close();
  }
}
