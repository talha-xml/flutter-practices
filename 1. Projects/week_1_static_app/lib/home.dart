import 'package:flutter/material.dart';

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
          Text("Muhammad Talha Faizan | Flutter Developer"),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text("Home Dashboard")),
                ListTile(title: Text("Details")),
                ListTile(title: Text("Settings")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
