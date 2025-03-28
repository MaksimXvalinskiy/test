import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationSettings {
  final _firebaseMessaging = FirebaseMessaging.instance;

  StreamSubscription? _firebaseMessagingListener;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool permission = false;

  static const _androidSilentChannel = AndroidNotificationChannel(
    'silent_channel',
    'Silent Notifications',
    playSound: false,
    enableVibration: false,
  );

  static const _androidHighImportanceChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  Future<void> initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [],
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidHighImportanceChannel);
    await platform?.createNotificationChannel(_androidSilentChannel);
  }

  Future<void> initNotifications() async {
    _firebaseMessagingListener = FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidSilentChannel.id,
            _androidSilentChannel.name,
            channelDescription: _androidSilentChannel.description,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<String> updateToken() async {
    try {
      permission =
          (await _firebaseMessaging.requestPermission()).authorizationStatus ==
              AuthorizationStatus.authorized;
      return (await _firebaseMessaging.getToken()) ?? '';
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return 'При обновлении токена произошла ошибка';
    }
  }
}
