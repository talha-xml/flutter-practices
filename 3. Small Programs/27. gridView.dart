import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Programming Languages")),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),

          children: [
            Text("Python"),
            Text("Java"),
            Text("C++"),
            Text("C"),
            Text("C#"),
            Text("JavaScript"),
            Text("TypeScript"),
            Text("Dart"),
            Text("Go"),
            Text("Rust"),
            Text("Swift"),
            Text("Kotlin"),
            Text("PHP"),
            Text("Ruby"),
            Text("Scala"),
            Text("R"),
            Text("Dart"),
            Text("Perl"),
            Text("Lua"),
            Text("Objective-C"),
            Text("Haskell"),
            Text("Fortran"),
            Text("COBOL"),
            Text("Assembly"),
            Text("MATLAB"),
            Text("SQL"),
            Text("Groovy"),
            Text("Elixir"),
            Text("F#"),
            Text("Visual Basic"),
          ],
        ),
      ),
    ),
  );
}
