import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String permissionStatus = 'Not requested';
  String? token;
  String? error;
  RemoteMessage? lastMessage;
  String? navigationTarget;
  bool initialized = false;

  Future<void> initialize() async {
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const settings = InitializationSettings(android: androidSettings);

      await _localNotifications.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          if (response.payload == 'details') {
            navigationTarget = 'details';
            notifyListeners();
          }
        },
      );

      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'Important Notifications',
        description: 'Notifications received while the app is open',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      final permissionSettings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      permissionStatus = permissionSettings.authorizationStatus.name;

      _messaging.onRegistered.listen((registrationId) {
        token = registrationId;
        notifyListeners();
      });

      await _messaging.register();

      FirebaseMessaging.onMessage.listen((message) async {
        lastMessage = message;

        final notification = message.notification;

        if (notification != null) {
          await _localNotifications.show(
            id: notification.hashCode,
            title: notification.title ?? 'New Notification',
            body: notification.body ?? '',
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'Important Notifications',
                channelDescription:
                    'Notifications received while the app is open',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
            payload: message.data['screen'] == 'details' ? 'details' : null,
          );
        }

        notifyListeners();
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        lastMessage = message;

        if (message.data['screen'] == 'details') {
          navigationTarget = 'details';
        }

        notifyListeners();
      });

      final initialMessage = await _messaging.getInitialMessage();

      if (initialMessage != null) {
        lastMessage = initialMessage;

        if (initialMessage.data['screen'] == 'details') {
          navigationTarget = 'details';
        }
      }

      initialized = true;
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();
  }
}
