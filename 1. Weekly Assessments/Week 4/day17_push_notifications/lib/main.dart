import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'screens/details_screen.dart';
import 'services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notifications = NotificationService();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    _notifications.addListener(_handleNavigation);
    _notifications.initialize();
  }

  void _handleNavigation() {
    if (_notifications.navigationTarget == 'details') {
      _notifications.navigationTarget = null;

      _navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const DetailsScreen()),
      );
    }
  }

  @override
  void dispose() {
    _notifications.removeListener(_handleNavigation);
    _notifications.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: AnimatedBuilder(
        animation: _notifications,
        builder: (context, _) {
          final message = _notifications.lastMessage;

          return Scaffold(
            appBar: AppBar(title: const Text('Push Notifications')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ElevatedButton(
                  onPressed: () {
                    _navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => const DetailsScreen()),
                    );
                  },
                  child: const Text('Open Details Screen'),
                ),
                const Divider(height: 32),
                const Text(
                  'Notification Permission',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(_notifications.permissionStatus),
                const Divider(height: 32),
                const Text(
                  'Firebase Installation ID',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _notifications.token ?? 'Retrieving identifier...',
                ),
                const Divider(height: 32),
                const Text(
                  'Latest Notification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (message == null)
                  const Text('No notifications received yet.')
                else ...[
                  Text(
                    message.notification?.title ?? 'No title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(message.notification?.body ?? 'No message body'),
                  if (message.data.isNotEmpty)
                    SelectableText('Data: ${message.data}'),
                ],
                if (_notifications.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _notifications.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
