import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome back, Talha!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text("Your Dashboard"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text("View Profile"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Settings"),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
