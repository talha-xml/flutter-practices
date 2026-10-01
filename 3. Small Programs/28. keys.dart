import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Languages")),
        body: ListView(
          children: [
            Text("Python", key: ValueKey("py")),
            Text("Java", key: ValueKey("java")),
            Text("Dart", key: ValueKey("dart")),
            Text("C++", key: ValueKey("cpp")),
          ],
        ),
      ),
    ),
  );
}
