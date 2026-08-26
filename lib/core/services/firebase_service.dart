import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medicompare/features/notification/data/datasources/notification_local_data_source.dart';
import 'package:medicompare/features/notification/data/repositories/notification_repository.dart';
import 'package:medicompare/features/notification/domain/services/notification_service.dart';

import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

/// Top-level background message handler.
///
/// Must be a top-level function (not a class method) because it runs
/// in its own isolate when the app is killed / in the background.
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log(
    'Background message received: ${message.messageId}',
    name: 'FirebaseService',
  );

  final type = message.data['type'];
  if (type == 'INCOMING_CALL' || type == 'CALL_OFFER') {
    final callId = message.data['callId']?.toString() ?? '';
    final callerId = message.data['callerId']?.toString() ?? '';
    final callerName =
        message.data['callerName']?.toString() ?? 'Incoming Call';
    final callerAvatar = message.data['callerAvatar']?.toString();
    final callType = message.data['callType']?.toString() ?? 'audio';
    final isVideo = callType == 'video';

    final params = CallKitParams(
      id: callId.isNotEmpty ? callId : const Uuid().v4(),
      nameCaller: callerName,
      appName: 'MediCompare Doctor',
      avatar: callerAvatar ?? '',
      handle: isVideo ? 'Incoming Video Call...' : 'Incoming Audio Call...',
      type: isVideo ? 1 : 0,
      duration: 45000,
      extra: <String, dynamic>{
        'callId': callId,
        'callerId': callerId,
        'callerName': callerName,
        'callerAvatar': callerAvatar,
        'callType': callType,
      },
      android: const AndroidParams(
        isCustomNotification: false,
        isShowFullLockedScreen: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#8059CA',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        textAccept: 'Accept',
        textDecline: 'Decline',
      ),
      ios: const IOSParams(
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'videoChat',
        audioSessionActive: true,
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  } else if (type == 'CALL_ENDED' || type == 'CALL_CANCEL') {
    final callId = message.data['callId']?.toString();
    if (callId != null && callId.isNotEmpty) {
      await FlutterCallkitIncoming.endCall(callId);
    } else {
      await FlutterCallkitIncoming.endAllCalls();
    }
  }
}

/// Centralised entry-point for all Firebase / push-notification setup.
///
/// Call [PushNotificationManager.init] once in `main()` after
/// `Firebase.initializeApp()` completes.
class PushNotificationManager {
  PushNotificationManager._();

  static NotificationService? _notificationService;

  /// Returns the [NotificationService] instance created during [init].
  ///
  /// Throws a [StateError] if accessed before [init] has been called.
  static NotificationService get notificationService {
    if (_notificationService == null) {
      throw StateError(
        'PushNotificationManager has not been initialised. '
        'Call PushNotificationManager.init() first.',
      );
    }
    return _notificationService!;
  }

  /// Initialises Firebase Messaging, registers the background handler,
  /// and sets up the [NotificationService].
  static Future<void> init() async {
    // Register the background handler (must be set before any other
    // FirebaseMessaging interaction).
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Build the notification dependency graph.
    final localDataSource = NotificationLocalDataSourceImpl();
    final repository = NotificationRepositoryImpl(
      localDataSource: localDataSource,
    );

    _notificationService = NotificationService(repository: repository);
    await _notificationService!.init();

    developer.log(
      'PushNotificationManager initialised successfully.',
      name: 'PushNotificationManager',
    );
  }
}
