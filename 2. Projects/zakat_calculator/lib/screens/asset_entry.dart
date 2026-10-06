import 'package:flutter/material.dart';

class AssetEntryScreen extends StatefulWidget {
  const AssetEntryScreen({super.key});

  @override
  State<AssetEntryScreen> createState() => _AssetEntryScreenState();
}

class _AssetEntryScreenState extends State<AssetEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cashController = TextEditingController();
  final _bankController = TextEditingController();
  final _investmentController = TextEditingController();
  final _inventoryController = TextEditingController();
  final _goodReceivableController = TextEditingController();
  final _doubtfulReceivableController = TextEditingController();
  final _debtController = TextEditingController();

  final _goldWeightController = TextEditingController();
  final _goldPurityController = TextEditingController();
  final _goldPriceController = TextEditingController();

  final _silverWeightController = TextEditingController();
  final _silverPurityController = TextEditingController();
  final _silverPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Asset Entry", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Enter Your Assets",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Cash & Financial Assets",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                TextFormField(
                  controller: _cashController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Cash (PKR)"),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _bankController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Bank Balance (PKR)",
                  ),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _investmentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Investments (PKR)",
                  ),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _inventoryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Business Inventory (PKR)",
                  ),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _goodReceivableController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Good Receivables (PKR)",
                  ),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _doubtfulReceivableController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Doubtful Receivables (PKR)",
                  ),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _debtController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Debts (PKR)"),
                  validator: _validateAmount,
                ),

                const SizedBox(height: 30),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Gold",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                TextFormField(
                  controller: _goldWeightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Gold Weight (grams)",
                  ),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _goldPurityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Gold Purity (Karat)",
                  ),
                  validator: _validateGoldPurity,
                ),

                TextFormField(
                  controller: _goldPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Gold Price per gram (PKR)",
                  ),
                  validator: _validateAmount,
                ),

                const SizedBox(height: 30),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Silver",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                TextFormField(
                  controller: _silverWeightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Silver Weight (grams)",
                  ),
                  validator: _validateAmount,
                ),

                TextFormField(
                  controller: _silverPurityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: "Silver Purity"),
                  validator: _validateSilverPurity,
                ),

                TextFormField(
                  controller: _silverPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Silver Price per gram (PKR)",
                  ),
                  validator: _validateAmount,
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    if (!_hasAnyAsset()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter available assets")),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirm Assets"),
                            content: const Text(
                              "Are your entered assets accurate?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasAnyAsset() {
    return _cashController.text.trim().isNotEmpty ||
        _bankController.text.trim().isNotEmpty ||
        _investmentController.text.trim().isNotEmpty ||
        _inventoryController.text.trim().isNotEmpty ||
        _goodReceivableController.text.trim().isNotEmpty ||
        _doubtfulReceivableController.text.trim().isNotEmpty ||
        _debtController.text.trim().isNotEmpty ||
        _goldWeightController.text.trim().isNotEmpty ||
        _goldPurityController.text.trim().isNotEmpty ||
        _goldPriceController.text.trim().isNotEmpty ||
        _silverWeightController.text.trim().isNotEmpty ||
        _silverPurityController.text.trim().isNotEmpty ||
        _silverPriceController.text.trim().isNotEmpty;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (double.tryParse(value.trim()) == null) {
      return "Please enter a valid amount";
    }

    if (double.parse(value.trim()) < 0) {
      return "Amount cannot be negative";
    }

    return null;
  }

  String? _validateGoldPurity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final purity = double.tryParse(value.trim());

    if (purity == null) {
      return "Please enter a valid purity";
    }

    if (purity < 0 || purity > 24) {
      return "Purity must be between 0 and 24";
    }

    return null;
  }

  String? _validateSilverPurity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final purity = double.tryParse(value.trim());

    if (purity == null) {
      return "Please enter a valid purity";
    }

    if (purity < 0 || purity > 24) {
      return "Purity must be between 0 and 24";
    }

    return null;
  }

  @override
  void dispose() {
    _cashController.dispose();
    _bankController.dispose();
    _investmentController.dispose();
    _inventoryController.dispose();
    _goodReceivableController.dispose();
    _doubtfulReceivableController.dispose();
    _debtController.dispose();

    _goldWeightController.dispose();
    _goldPurityController.dispose();
    _goldPriceController.dispose();

    _silverWeightController.dispose();
    _silverPurityController.dispose();
    _silverPriceController.dispose();

    super.dispose();
  }
}
