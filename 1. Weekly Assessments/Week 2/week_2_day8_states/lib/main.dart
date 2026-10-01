import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lifting State Up'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CounterDisplay(counter: counter),
          const SizedBox(height: 20),
          CounterButton(onPressed: incrementCounter),
        ],
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  final int counter;
  const CounterDisplay({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Text('Counter: $counter', style: const TextStyle(fontSize: 30));
  }
}

class CounterButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CounterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('Increment'));
  }
}
