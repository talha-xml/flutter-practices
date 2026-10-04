import 'package:flutter/material.dart';

class AssetEntryScreen extends StatefulWidget {
  const AssetEntryScreen({super.key});

  @override
  State<AssetEntryScreen> createState() => _AssetEntryScreenState();
}

class _AssetEntryScreenState extends State<AssetEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Asset Entry", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Enter Your Assets",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _cashController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Cash (PKR)"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Cash amount is required";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Asset data entered")),
                      );
                    }
                  },
                  child: Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }
}
