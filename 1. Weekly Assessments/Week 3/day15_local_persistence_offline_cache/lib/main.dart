import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('details');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = Hive.box('details');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  String message = '';

  void submitDetails() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        noteController.text.trim().isEmpty) {
      setState(() {
        message = 'Please fill all fields.';
      });
      return;
    }

    box.put('name', nameController.text.trim());
    box.put('email', emailController.text.trim());
    box.put('note', noteController.text.trim());

    setState(() {
      message = 'Details have been submitted.';
    });
  }

  void retrieveDetails() {
    final name = box.get('name');
    final email = box.get('email');
    final note = box.get('note');

    setState(() {
      message = ''' Name: $name Email: $email Note: $note ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Storage')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: submitDetails,
                    child: const Text('Submit'),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: retrieveDetails,
                    child: const Text('Retrieve'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
