import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 100, height: 100, color: Colors.red),
              SizedBox(height: 50),
              Container(width: 100, height: 100, color: Colors.blue),
            ],
          ),
        ),
      ),
    ),
  );
}
