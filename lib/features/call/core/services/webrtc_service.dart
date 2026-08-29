import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;

  bool _isRenderersInitialized = false;
  final List<RTCIceCandidate> _queuedIceCandidates = [];

  Function(RTCIceCandidate candidate)? onIceCandidate;
  Function(MediaStream stream)? onRemoteStream;
  Function(RTCPeerConnectionState state)? onConnectionStateChanged;
  Function(RTCIceConnectionState state)? onIceConnectionStateChanged;

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {
        'urls': [
          'stun:62.72.12.50:3478',
          'stun:stun.l.google.com:19302',
          'stun:stun1.l.google.com:19302',
        ],
      },
      {
        'urls': [
          'turn:62.72.12.50:3478',
          'turn:62.72.12.50:3478?transport=udp',
          'turn:62.72.12.50:3478?transport=tcp',
          'turn:62.72.12.50:80?transport=tcp',
          'turn:62.72.12.50:443?transport=tcp',
          'turns:62.72.12.50:5349?transport=tcp',
        ],
        'username': 'solohearts_media_relay',
        'credential': 'SoloHeartsLiveRelay99#Secure2026',
      },
    ],
    'sdpSemantics': 'unified-plan',
  };

  /// Public getters — null when not initialized (between calls)
  RTCVideoRenderer? get localRenderer => _localRenderer;
  RTCVideoRenderer? get remoteRenderer => _remoteRenderer;

  /// Creates fresh renderer instances per call session.
  /// Safe to call repeatedly — disposes stale renderers before re-creating.
  Future<void> initializeRenderers() async {
    // If renderers from a previous call are still around, dispose them first
    if (_isRenderersInitialized) {
      await _disposeRenderers();
    }

    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    await _localRenderer!.initialize();
    await _remoteRenderer!.initialize();
    _isRenderersInitialized = true;
    debugPrint('🎬 Renderers initialized (fresh instances)');
  }

  Future<MediaStream> startLocalStream({required bool isVideo}) async {
    await initializeRenderers();

    // If local stream is already active with requested video capability, reuse it!
    if (_localStream != null) {
      final hasVideo = _localStream!.getVideoTracks().isNotEmpty;
      if (hasVideo == isVideo) {
        _localRenderer?.srcObject = _localStream;
        await _addLocalTracksToPeerConnection();
        return _localStream!;
      }
    }

    final Map<String, dynamic> mediaConstraints = {
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'autoGainControl': true,
        'highpassFilter': true,
      },
      'video':
          isVideo
              ? {
                'facingMode': 'user',
                'width': {'ideal': 1080, 'min': 720, 'max': 1920},
                'height': {'ideal': 1920, 'min': 1280, 'max': 1920},
                'frameRate': {'ideal': 30, 'min': 24, 'max': 30},
              }
              : false,
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer?.srcObject = _localStream;

    // Ensure tracks are added if peer connection is already created
    await _addLocalTracksToPeerConnection();

    return _localStream!;
  }

  Future<void> _optimizeSenderParameters() async {
    if (_peerConnection == null) return;
    try {
      final senders = await _peerConnection!.getSenders();
      for (final sender in senders) {
        if (sender.track?.kind == 'video') {
          final params = sender.parameters;
          if (params.encodings != null && params.encodings!.isNotEmpty) {
            for (final encoding in params.encodings!) {
              encoding.maxBitrate = 3200000;
              encoding.minBitrate = 500000;
              encoding.maxFramerate = 30;
            }
            await sender.setParameters(params);
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Could not set sender bitrate parameters: $e');
    }
  }

  /// Prefer H.264 hardware codec (High Profile preferred) for sharper video and lower battery usage.
  String _preferH264(String sdp) {
    try {
      final lines = sdp.split('\r\n');
      final result = <String>[];
      bool inVideo = false;
      String? h264PayloadType;
      String? h264HighPayloadType;

      // First pass: find all H.264 payload types in video section
      final h264Pts = <String>[];
      for (final line in lines) {
        if (line.startsWith('m=video')) inVideo = true;
        if (line.startsWith('m=audio')) inVideo = false;
        if (inVideo && line.startsWith('a=rtpmap:') && line.contains('H264/')) {
          final pt = line.split(':')[1].split(' ')[0];
          h264Pts.add(pt);
          h264PayloadType ??= pt;
        }
      }

      // Check for High Profile (6400...)
      for (final line in lines) {
        if (line.startsWith('a=fmtp:')) {
          for (final pt in h264Pts) {
            if (line.startsWith('a=fmtp:$pt ') &&
                line.contains('profile-level-id=6400')) {
              h264HighPayloadType = pt;
              break;
            }
          }
        }
      }

      final chosenPt = h264HighPayloadType ?? h264PayloadType;
      if (chosenPt == null) return sdp;

      // Second pass: move chosen H.264 to first position in m=video line
      for (final line in lines) {
        if (line.startsWith('m=video')) {
          final parts = line.split(' ');
          // parts[0]=m=video, [1]=port, [2]=proto, [3..]=payload types
          if (parts.length > 3) {
            final payloads = parts.sublist(3);
            payloads.remove(chosenPt);
            payloads.insert(0, chosenPt);
            result.add('${parts.sublist(0, 3).join(' ')} ${payloads.join(' ')}');
            continue;
          }
        }
        result.add(line);
      }
      return result.join('\r\n');
    } catch (_) {
      return sdp;
    }
  }

  String _setSdpBitrate(
    String sdp, {
    int videoBitrateKbps = 3200,
    int audioBitrateKbps = 128,
  }) {
    try {
      final lines = sdp.split('\r\n');
      final result = <String>[];
      String? currentMedia;

      for (final line in lines) {
        if (line.startsWith('m=')) {
          currentMedia =
              line.startsWith('m=video')
                  ? 'video'
                  : (line.startsWith('m=audio') ? 'audio' : null);
          result.add(line);
          continue;
        }

        if (line.startsWith('b=AS:') || line.startsWith('b=TIAS:')) {
          continue;
        }

        if (line.startsWith('c=IN ') && currentMedia != null) {
          result.add(line);
          if (currentMedia == 'video') {
            result.add('b=AS:$videoBitrateKbps');
            result.add('b=TIAS:${videoBitrateKbps * 1000}');
          } else if (currentMedia == 'audio') {
            result.add('b=AS:$audioBitrateKbps');
            result.add('b=TIAS:${audioBitrateKbps * 1000}');
          }
          continue;
        }

        result.add(line);
      }
      return result.join('\r\n');
    } catch (_) {
      return sdp;
    }
  }

  Future<void> _addLocalTracksToPeerConnection() async {
    if (_peerConnection == null || _localStream == null) return;

    // Guard against operating on a closed connection
    if (_peerConnection!.signalingState ==
        RTCSignalingState.RTCSignalingStateClosed) {
      return;
    }

    try {
      final senders = await _peerConnection!.getSenders();
      final attachedTrackIds =
          senders.map((s) => s.track?.id).whereType<String>().toSet();

      for (final track in _localStream!.getTracks()) {
        if (attachedTrackIds.contains(track.id)) {
          continue;
        }

        // Check if there is an unassigned sender (created by setRemoteDescription)
        RTCRtpSender? emptySender;
        for (final sender in senders) {
          if (sender.track == null) {
            emptySender = sender;
            break;
          }
        }

        if (emptySender != null) {
          await emptySender.replaceTrack(track);
        } else {
          await _peerConnection!.addTrack(track, _localStream!);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error adding local tracks to peer connection: $e');
    }
  }

  Future<void> createPeerConnectionInstance() async {
    _peerConnection = await createPeerConnection(_iceServers);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        onIceCandidate?.call(candidate);
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) async {
      debugPrint(
        '🎬 [WebRTC] onTrack: kind=${event.track.kind}, id=${event.track.id}, streams=${event.streams.length}',
      );
      if (event.track.kind == 'audio') {
        event.track.enabled = true;
      }

      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        if (_remoteRenderer != null) {
          _remoteRenderer!.srcObject = _remoteStream;
        }
        onRemoteStream?.call(_remoteStream!);
        return;
      }

      _remoteStream ??= await createLocalMediaStream('remote_stream');
      final hasTrack = _remoteStream!.getTracks().any(
        (t) => t.id == event.track.id,
      );
      if (!hasTrack) {
        _remoteStream!.addTrack(event.track);
      }

      if (_remoteRenderer != null) {
        _remoteRenderer!.srcObject = _remoteStream;
      }

      onRemoteStream?.call(_remoteStream!);
    };

    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      onConnectionStateChanged?.call(state);
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _optimizeSenderParameters();
      }
    };

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      onIceConnectionStateChanged?.call(state);
      if (state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
        _optimizeSenderParameters();
      }
    };

    await _addLocalTracksToPeerConnection();
  }

  Future<RTCSessionDescription> createOffer() async {
    if (_peerConnection == null) await createPeerConnectionInstance();
    await _addLocalTracksToPeerConnection();

    final isVideo = _localStream?.getVideoTracks().isNotEmpty ?? false;

    final rawOffer = await _peerConnection!.createOffer({
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': isVideo,
      },
      'optional': [],
    });

    String optimizedSdp = rawOffer.sdp ?? '';
    if (isVideo) {
      optimizedSdp = _preferH264(optimizedSdp);
      optimizedSdp = _setSdpBitrate(
        optimizedSdp,
        videoBitrateKbps: 3200,
        audioBitrateKbps: 128,
      );
    } else {
      optimizedSdp = _setSdpBitrate(
        optimizedSdp,
        videoBitrateKbps: 0,
        audioBitrateKbps: 128,
      );
    }
    final offer = RTCSessionDescription(optimizedSdp, rawOffer.type);

    await _peerConnection!.setLocalDescription(offer);
    await _optimizeSenderParameters();

    return offer;
  }

  Future<void> setRemoteOffer({
    required String sdp,
    required String type,
  }) async {
    if (_peerConnection == null) await createPeerConnectionInstance();

    final RTCSessionDescription description = RTCSessionDescription(sdp, type);
    await _peerConnection!.setRemoteDescription(description);

    // Flush any ICE candidates received before remote description was set
    final queued = List<RTCIceCandidate>.from(_queuedIceCandidates);
    _queuedIceCandidates.clear();
    for (final candidate in queued) {
      try {
        await _peerConnection!.addCandidate(candidate);
      } catch (e) {
        debugPrint('⚠️ Error adding queued candidate: $e');
      }
    }
  }

  Future<RTCSessionDescription> createAnswer() async {
    if (_peerConnection == null) {
      throw Exception('PeerConnection is not initialized');
    }

    await _addLocalTracksToPeerConnection();

    final isVideo = _localStream?.getVideoTracks().isNotEmpty ?? false;

    final rawAnswer = await _peerConnection!.createAnswer({
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': isVideo,
      },
      'optional': [],
    });

    String optimizedSdp = rawAnswer.sdp ?? '';
    if (isVideo) {
      optimizedSdp = _preferH264(optimizedSdp);
      optimizedSdp = _setSdpBitrate(
        optimizedSdp,
        videoBitrateKbps: 3200,
        audioBitrateKbps: 128,
      );
    } else {
      optimizedSdp = _setSdpBitrate(
        optimizedSdp,
        videoBitrateKbps: 0,
        audioBitrateKbps: 128,
      );
    }
    final answer = RTCSessionDescription(optimizedSdp, rawAnswer.type);

    await _peerConnection!.setLocalDescription(answer);
    await _optimizeSenderParameters();

    return answer;
  }

  Future<void> setRemoteAnswer({
    required String sdp,
    required String type,
  }) async {
    if (_peerConnection == null) {
      throw Exception('PeerConnection is not initialized');
    }

    final RTCSessionDescription description = RTCSessionDescription(sdp, type);
    await _peerConnection!.setRemoteDescription(description);

    // Flush any queued ICE candidates
    final queued = List<RTCIceCandidate>.from(_queuedIceCandidates);
    _queuedIceCandidates.clear();
    for (final candidate in queued) {
      try {
        await _peerConnection!.addCandidate(candidate);
      } catch (e) {
        debugPrint('⚠️ Error adding queued candidate: $e');
      }
    }
  }

  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    if (_peerConnection != null &&
        _peerConnection!.signalingState !=
            RTCSignalingState.RTCSignalingStateClosed) {
      final remoteDescription = await _peerConnection!.getRemoteDescription();
      if (remoteDescription != null) {
        try {
          await _peerConnection!.addCandidate(candidate);
        } catch (e) {
          debugPrint('⚠️ Error adding candidate: $e');
        }
      } else {
        _queuedIceCandidates.add(candidate);
      }
    } else {
      _queuedIceCandidates.add(candidate);
    }
  }

  void toggleMic({required bool isMuted}) {
    if (_localStream != null) {
      for (var track in _localStream!.getAudioTracks()) {
        track.enabled = !isMuted;
      }
    }
  }

  void toggleCamera({required bool isOff}) {
    if (_localStream != null) {
      for (var track in _localStream!.getVideoTracks()) {
        track.enabled = !isOff;
      }
    }
  }

  Future<void> switchCamera() async {
    if (_localStream != null && _localStream!.getVideoTracks().isNotEmpty) {
      final videoTrack = _localStream!.getVideoTracks().first;
      await Helper.switchCamera(videoTrack);
    }
  }

  void toggleSpeakerphone({required bool enableSpeaker}) {
    if (_localStream != null) {
      Helper.setSpeakerphoneOn(enableSpeaker);
    }
  }

  MediaStream? get localStream => _localStream;
  MediaStream? get remoteStream => _remoteStream;

  Future<void> dispose() async {
    try {
      _queuedIceCandidates.clear();
      _localStream?.getTracks().forEach((track) {
        track.stop();
      });
      await _localStream?.dispose();
      _localStream = null;

      await _remoteStream?.dispose();
      _remoteStream = null;

      await _peerConnection?.close();
      await _peerConnection?.dispose();
      _peerConnection = null;

      await _disposeRenderers();
    } catch (e) {
      debugPrint('Error disposing WebRTCService: $e');
    }
  }

  /// Safely tears down renderers and nulls them out.
  /// Guards against double-dispose.
  Future<void> _disposeRenderers() async {
    if (!_isRenderersInitialized) return;

    try {
      _localRenderer?.srcObject = null;
      _remoteRenderer?.srcObject = null;
      await _localRenderer?.dispose();
      await _remoteRenderer?.dispose();
    } catch (e) {
      debugPrint('Error disposing renderers: $e');
    } finally {
      _localRenderer = null;
      _remoteRenderer = null;
      _isRenderersInitialized = false;
      debugPrint('🎬 Renderers disposed, ready for next call');
    }
  }
}
