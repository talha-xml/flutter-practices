import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/user.dart';
import 'screens/asset_entry.dart';
import 'screens/registration.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SessionGate(),
    ),
  );
}

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late final Future<User?> _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loggedInUser = AuthService().getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _loggedInUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user != null) {
          return AssetEntryScreen(user: user);
        }

        return const RegistrationScreen();
      },
    );
  }
}
