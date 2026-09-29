import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details Page", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "My Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    "I am Muhammad Talha Faizan, a passionate Flutter developer.",
                  ),
                ),
                ListTile(
                  title: Text(
                    "I am comfortable working with Dart/Flutter and even web technologies like JS and React.",
                  ),
                ),
                ListTile(
                  title: Text(
                    "Contact me at: mtalhafaizan30@gmail.com",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
