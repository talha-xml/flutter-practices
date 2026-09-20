import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              Container(width: 80, height: 80, color: Colors.red),
              Container(width: 80, height: 80, color: Colors.green)),
              Container(width: 80, height: 80, color: Colors.blue),
            ],
          ),
        ),
      ),
    ),
  );
}
