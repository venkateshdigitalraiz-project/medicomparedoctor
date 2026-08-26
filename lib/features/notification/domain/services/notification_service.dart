import 'dart:developer' as developer;

import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicompare/features/notification/data/repositories/notification_repository.dart';

/// Handles all Firebase Cloud Messaging (FCM) lifecycle events:
/// - Permission requests
/// - Token retrieval & refresh
/// - Foreground, background, and terminated-state message handling
/// - Local notification display for foreground messages
class NotificationService {
  final NotificationRepository repository;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  /// High-importance Android notification channel.
  /// Must match the `default_notification_channel_id` in AndroidManifest.xml.
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  NotificationService({
    required this.repository,
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
  })  : _messaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotificationsPlugin ?? FlutterLocalNotificationsPlugin();

  // ──────────────────────────────────────────────────────────────────────────
  // Initialisation
  // ──────────────────────────────────────────────────────────────────────────

  /// Call once during app startup (after `Firebase.initializeApp()`).
  Future<void> init() async {
    await _requestPermission();
    await _setupLocalNotifications();
    _listenToTokenRefresh();
    _listenToForegroundMessages();
    _handleInitialMessage();

    developer.log(
      'NotificationService initialised successfully.',
      name: 'NotificationService',
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Permission
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> _requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    developer.log(
      'Notification permission status: ${settings.authorizationStatus}',
      name: 'NotificationService',
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Local Notifications Setup (for foreground display)
  // ──────────────────────────────────────────────────────────────────────────

  Future<void> _setupLocalNotifications() async {
    // Create the Android notification channel.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Initialise the plugin.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    developer.log(
      'Local notifications initialised.',
      name: 'NotificationService',
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // FCM Token Management
  // ──────────────────────────────────────────────────────────────────────────



  void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen(
      (String newToken) async {
        developer.log(
          'FCM Token refreshed: ${newToken.substring(0, 20)}...',
          name: 'NotificationService',
        );
        await repository.saveFCMToken(newToken);
        await repository.syncFCMToken(newToken);
      },
      onError: (Object error) {
        developer.log(
          'Error listening to FCM token refresh.',
          name: 'NotificationService',
          error: error,
        );
      },
    );
  }

  /// Deletes the FCM token from the device and cache on user logout.
  Future<void> deleteFCMToken() async {
    await repository.deleteFCMToken();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Foreground Messages
  // ──────────────────────────────────────────────────────────────────────────

  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        developer.log(
          'Foreground message received: ${message.messageId}',
          name: 'NotificationService',
        );
        _showLocalNotification(message);
      },
      onError: (Object error) {
        developer.log(
          'Error receiving foreground message.',
          name: 'NotificationService',
          error: error,
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Background / Terminated → Opened Messages
  // ──────────────────────────────────────────────────────────────────────────

  /// Called when the app is opened from a terminated state via a notification.
  void _handleInitialMessage() {
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        developer.log(
          'App opened from terminated state via notification: ${message.messageId}',
          name: 'NotificationService',
        );
        _handleNotificationNavigation(message.data);
      }
    });

    // Called when the app is in background and user taps the notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log(
        'App opened from background via notification: ${message.messageId}',
        name: 'NotificationService',
      );
      _handleNotificationNavigation(message.data);
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Local Notification Display
  // ──────────────────────────────────────────────────────────────────────────

  /// Shows a heads-up notification using flutter_local_notifications.
  void _showLocalNotification(RemoteMessage message) {
    final RemoteNotification? notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'MediCompares',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6A1FB2), // Deep purple theme color
          playSound: true,
          enableVibration: true,
          styleInformation: BigTextStyleInformation(
            notification.body ?? '',
            contentTitle: notification.title,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true,
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
        ),
      ),
      payload: message.data['route'],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Navigation Handler
  // ──────────────────────────────────────────────────────────────────────────

  /// Handles navigation when a notification is tapped (from local or FCM).
  void _onNotificationTapped(NotificationResponse response) {
    final String? route = response.payload;
    if (route != null && route.isNotEmpty) {
      developer.log(
        'Local notification tapped. Route: $route',
        name: 'NotificationService',
      );
      _handleNotificationNavigation({'route': route});
    }
  }

  /// Centralised navigation logic based on notification payload.
  ///
  /// Extend this method to navigate to specific screens based on the
  /// `data['route']` or `data['type']` received from the push notification.
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final String? route = data['route'] as String?;
    if (route == null || route.isEmpty) return;

    developer.log(
      'Navigating to route: $route',
      name: 'NotificationService',
    );

    // TODO: Use MyApp.navigatorKey.currentState?.pushNamed(route)
    // once deep-link routes are defined.
  }
}
