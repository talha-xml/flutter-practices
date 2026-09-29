import 'package:flutter/material.dart';

import 'details.dart';
import 'settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Muhammad Talha Faizan | Flutter Developer",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text("Home Dashboard")),
                ListTile(
                  title: Text(
                    "View Details Screen",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "View Settings Screen",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
