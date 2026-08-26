import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medicompare/features/notification/data/datasources/notification_local_data_source.dart';
import 'package:medicompare/features/notification/data/repositories/notification_repository.dart';
import 'package:medicompare/features/notification/domain/services/notification_service.dart';

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
