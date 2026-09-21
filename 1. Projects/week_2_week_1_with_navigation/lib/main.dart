import 'package:flutter/material.dart';

import 'home.dart';
import 'details.dart';
import 'settings.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: HomeScreen(),
    ),
  );
}
