import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<String> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUser();
  }

  Future<String> getUser() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Muhammad Talha Faizan";
  }

  Future<String> getUserWithError() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception("Failed to load user");
  }

  void loadUser() {
    setState(() {
      userFuture = getUser();
    });
  }

  void loadError() {
    setState(() {
      userFuture = getUserWithError();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<String>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const Text(
                  "Failed to load user",
                  style: TextStyle(fontSize: 20),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text(
                  "No user found",
                  style: TextStyle(fontSize: 20),
                );
              }

              return Text(snapshot.data!, style: const TextStyle(fontSize: 24));
            },
          ),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: loadUser, child: const Text("Get User")),
          ElevatedButton(onPressed: loadError, child: const Text("Test Error")),
        ],
      ),
    );
  }
}
