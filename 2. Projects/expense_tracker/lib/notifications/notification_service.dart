import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'spendwise_budget_alerts',
    'Budget Alerts',
    description:
        'Notifications for budget threshold alerts and spending updates',
    importance: Importance.high,
  );

  bool _initialized = false;
  double? _lastEvaluatedBudget;
  bool _hasNotified50Percent = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('FCM Permission Status: ${settings.authorizationStatus}');
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);

    final androidImplementation = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(_channel);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        showNotification(
          title: notification.title ?? 'SpendWise Alert',
          body: notification.body ?? '',
        );
      }
    });

    await syncFCMToken();
    _initialized = true;
  }

  Future<void> syncFCMToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // ignore: deprecated_member_use
      final token = await _fcm.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fcmToken': token,
          'tokenUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing FCM token: $e');
      }
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  void checkBudget50PercentThreshold({
    required double? budget,
    required double totalSpent,
  }) {
    if (budget == null || budget <= 0) {
      _hasNotified50Percent = false;
      return;
    }

    if (_lastEvaluatedBudget != budget) {
      _lastEvaluatedBudget = budget;
      _hasNotified50Percent = false;
    }

    final halfBudget = budget * 0.5;

    if (totalSpent >= halfBudget) {
      if (!_hasNotified50Percent) {
        _hasNotified50Percent = true;
        final remaining = budget - totalSpent;

        showNotification(
          title: '⚠️ Budget Alert!',
          body:
              '50% of your budget has been spent. PKR ${remaining > 0 ? remaining.toStringAsFixed(2) : "0.00"} remaining.',
        );
      }
    } else {
      _hasNotified50Percent = false;
    }
  }
}
