import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              Container(width: 80, height: 80, color: Colors.red),
              Expanded(child: Container(height: 80, color: Colors.green)),
              Container(width: 80, height: 80, color: Colors.blue),
            ],
          ),
        ),
      ),
    ),
  );
}

----------------------

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Container(width: 80, height: 80, color: Colors.red),
              Container(width: 80, height: 80, color: Colors.green),
              Container(width: 80, height: 80, color: Colors.blue),
            ],
          ),
        ),
      ),
    ),
  );
}
--------------------------
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

---------------------------

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 250, height: 250, color: Colors.blue),
              Container(width: 180, height: 180, color: Colors.red),
              Text(
                "Hello",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
