import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medicompare/features/notification/data/repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository repository;
  final FirebaseMessaging firebaseMessaging;

  NotificationService({
    required this.repository,
    FirebaseMessaging? firebaseMessaging,
  }) : firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  Future<void> init() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print("Notification Permission Status: ${settings.authorizationStatus}");

    String? token = await repository.getFCMToken();
    print("Firebase FCM Token: $token");

    firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      print("Firebase Token Refreshed: $newToken");
      await repository.saveFCMToken(newToken);
      await repository.syncFCMToken(newToken);
    });
  }
}
