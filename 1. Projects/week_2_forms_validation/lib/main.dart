import 'package:flutter/material.dart';

import 'registration.dart';

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
