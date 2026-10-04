import 'package:flutter/material.dart';

import 'screens/registration.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: RegistrationScreen(),
    ),
  );
}
