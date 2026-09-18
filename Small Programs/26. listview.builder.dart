import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Programming Languages"),
        ),
        body: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            return Text(languages[index]);
          },
        ),
      ),
    ),
  );
}

List<String> languages = [
  "Python",
  "Java",
  "C++",
  "C",
  "C#",
  "JavaScript",
  "TypeScript",
  "Dart",
  "Go",
  "Rust",
  "Swift",
  "Kotlin",
  "PHP",
  "Ruby",
  "Scala",
  "R",
  "Perl",
  "React",
  "Objective-C",
  "LISP",
  "Fortran",
  "COBOL",
  "Assembly",
  "MATLAB",
  "SQL",
  "Flutter",
  "Elixir",
  "F#",
  "Visual Basic",
  "Delphi",
];