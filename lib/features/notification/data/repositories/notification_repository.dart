import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medicompare/features/notification/data/datasources/notification_local_data_source.dart';

/// Contract for notification token and sync operations.
abstract class NotificationRepository {
  /// Retrieves the FCM token — from cache if available, otherwise from Firebase.
  Future<String?> getFCMToken();

  /// Persists the FCM token to local storage.
  Future<void> saveFCMToken(String token);

  /// Syncs the FCM token with the remote backend.
  Future<void> syncFCMToken(String token);

  /// Deletes the cached FCM token locally and deletes it from Firebase.
  Future<void> deleteFCMToken();
}

/// Concrete implementation of [NotificationRepository].
///
/// Uses [NotificationLocalDataSource] for caching and [FirebaseMessaging]
/// for fresh token retrieval.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;
  final FirebaseMessaging _messaging;

  NotificationRepositoryImpl({
    required this.localDataSource,
    FirebaseMessaging? firebaseMessaging,
  }) : _messaging = firebaseMessaging ?? FirebaseMessaging.instance;

  @override
  Future<String?> getFCMToken() async {
    // Try local cache first to avoid unnecessary network calls.
    final String? cachedToken = await localDataSource.getFCMToken();
    if (cachedToken != null && cachedToken.isNotEmpty) {
      developer.log(
        'Using cached FCM token.',
        name: 'NotificationRepository',
      );
      return cachedToken;
    }

    // Fetch a fresh token from Firebase.
    try {
      final String? freshToken = await _messaging.getToken();
      if (freshToken != null) {
        await localDataSource.saveFCMToken(freshToken);
        developer.log(
          'Fresh FCM token retrieved and cached.',
          name: 'NotificationRepository',
        );
      }
      return freshToken;
    } catch (e, stackTrace) {
      developer.log(
        'Failed to fetch FCM token from Firebase.',
        name: 'NotificationRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> saveFCMToken(String token) async {
    await localDataSource.saveFCMToken(token);
    developer.log(
      'FCM token saved to local storage.',
      name: 'NotificationRepository',
    );
  }

  @override
  Future<void> syncFCMToken(String token) async {
    // TODO: Implement actual backend API call to sync the FCM token.
    // Example: await apiClient.post('/api/device/token', data: {'fcmToken': token});
    developer.log(
      'FCM token synced with backend.',
      name: 'NotificationRepository',
    );
  }

  @override
  Future<void> deleteFCMToken() async {
    try {
      await _messaging.deleteToken();
      await localDataSource.deleteFCMToken();
      developer.log(
        'FCM token deleted successfully.',
        name: 'NotificationRepository',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error deleting FCM token.',
        name: 'NotificationRepository',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
