import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medicompare/features/notification/data/datasources/notification_local_data_source.dart';

abstract class NotificationRepository {
  Future<String?> getFCMToken();
  Future<void> saveFCMToken(String token);
  Future<void> syncFCMToken(String token);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;
  final FirebaseMessaging firebaseMessaging;

  NotificationRepositoryImpl({
    required this.localDataSource,
    FirebaseMessaging? firebaseMessaging,
  }) : firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  @override
  Future<String?> getFCMToken() async {
    String? cachedToken = await localDataSource.getFCMToken();
    if (cachedToken != null && cachedToken.isNotEmpty) {
      return cachedToken;
    }

    String? freshToken = await firebaseMessaging.getToken();
    if (freshToken != null) {
      await localDataSource.saveFCMToken(freshToken);
    }
    return freshToken;
  }

  @override
  Future<void> saveFCMToken(String token) async {
    await localDataSource.saveFCMToken(token);
  }

  @override
  Future<void> syncFCMToken(String token) async {
    // Sync with backend API placeholder if required
    print("Syncing FCM Token with backend: $token");
  }
}
