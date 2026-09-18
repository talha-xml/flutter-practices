import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Welcome to ur profile"), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 65, color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 15),
              Text("Muhammad Talha Faizan"),
              SizedBox(height: 5),
              Text("Full Stack Developer"),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.blue[100]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("24"),
                        SizedBox(height: 5),
                        Text("Projects"),
                      ],
                    ),

                    Column(
                      children: [
                        Text("1.2K"),
                        SizedBox(height: 5),
                        Text("Followers"),
                      ],
                    ),
                    
                     Column(
                      children: [
                        Text("36"),
                        SizedBox(height: 5),
                        Text("Posts"),
                      ],
                    ),

                    Column(
                      children: [
                        Text("350"),
                        SizedBox(height: 5),
                        Text("Following"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Edit Profile"),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Share"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("About Me"),
                    SizedBox(height: 10),
                    Text(
                      "BS Computer Science graduate and "
                      "Full Stack Developer interested in "
                      "AI/ML and Flutter development.",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),
              Align(alignment: Alignment.centerLeft, child: Text("Skills")),

              SizedBox(height: 10),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Center(child: Text("Flutter")),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Center(child: Text("React")),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Center(child: Text("Python")),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.white),
                      child: Center(child: Text("Node.js")),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
  );
}
