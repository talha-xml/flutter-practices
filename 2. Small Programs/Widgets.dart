import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome Talha"),
              Text("Muhammad Talha Faizan"),
              Text("BS Computer Science"),
              Text("Full Stack Developer"),
              Text("AI/ML Enthusiast"),
              Text("Welcome to my first Flutter app!"),
            ],
          ),
        ),
      ),
    ),
  );
}

------------------------------------------------------------

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 15),

              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {},
                child: Text("Login"),
              ),

              TextButton(
                onPressed: () {},
                child: Text("Sign Up"),
              ),
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