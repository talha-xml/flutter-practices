import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/zakat_input.dart';
import '../models/zakat_settings.dart';
import '../services/auth_service.dart';
import '../services/zakat_calculator.dart';
import '../services/history_storage.dart';

import 'registration.dart';
import 'result.dart';
import 'settings.dart';
import 'history.dart';

class AssetEntryScreen extends StatefulWidget {
  final User user;

  const AssetEntryScreen({super.key, required this.user});

  @override
  State<AssetEntryScreen> createState() => _AssetEntryScreenState();
}

class _AssetEntryScreenState extends State<AssetEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  ZakatSettings _zakatSettings = ZakatSettings();

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

  final _personalGoldJewelleryWeightController = TextEditingController();
  final _personalGoldJewelleryPurityController = TextEditingController();

  final _silverWeightController = TextEditingController();
  final _silverPurityController = TextEditingController();
  final _silverPriceController = TextEditingController();

  final _personalSilverJewelleryWeightController = TextEditingController();
  final _personalSilverJewelleryPurityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = widget.user.id;

    final settings = ZakatSettings(
      madhhab: Madhhab.values.firstWhere(
        (value) => value.name == prefs.getString('madhhab_$userId'),
        orElse: () => Madhhab.hanafi,
      ),
      nisabStandard: NisabStandard.values.firstWhere(
        (value) => value.name == prefs.getString('nisabStandard_$userId'),
        orElse: () => NisabStandard.silver,
      ),
      includeDoubtfulReceivables:
          prefs.getBool('includeDoubtfulReceivables_$userId') ?? false,
    );

    if (!mounted) return;

    setState(() {
      _zakatSettings = settings;
    });
  }

  Decimal _parseMoney(String value) {
    if (value.trim().isEmpty) return Decimal.zero;
    return Decimal.parse(value.trim());
  }

  double _parseWeight(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }

  bool _hasAnyAssetInput() {
    final controllers = [
      _cashController,
      _bankController,
      _investmentController,
      _inventoryController,
      _goodReceivableController,
      _doubtfulReceivableController,
      _goldWeightController,
      _goldPurityController,
      _goldPriceController,
      _personalGoldJewelleryWeightController,
      _personalGoldJewelleryPurityController,
      _silverWeightController,
      _silverPurityController,
      _silverPriceController,
      _personalSilverJewelleryWeightController,
      _personalSilverJewelleryPurityController,
    ];

    return controllers.any((controller) => controller.text.trim().isNotEmpty);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _continueToResult() {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasAnyAssetInput()) {
      _showMessage('Enter available assets');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Assets'),
          content: const Text('Are your entered assets accurate?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final zakatInput = ZakatInput(
                  cash: _parseMoney(_cashController.text),
                  bankBalance: _parseMoney(_bankController.text),
                  investments: _parseMoney(_investmentController.text),
                  businessInventory: _parseMoney(_inventoryController.text),
                  goodReceivables: _parseMoney(_goodReceivableController.text),
                  doubtfulReceivables: _parseMoney(
                    _doubtfulReceivableController.text,
                  ),
                  debt: _parseMoney(_debtController.text),

                  goldWeight: _parseWeight(_goldWeightController.text),
                  goldPurity: _parseWeight(_goldPurityController.text),
                  goldPrice: _parseMoney(_goldPriceController.text),

                  personalGoldJewelleryWeight: _parseWeight(
                    _personalGoldJewelleryWeightController.text,
                  ),
                  personalGoldJewelleryPurity: _parseWeight(
                    _personalGoldJewelleryPurityController.text,
                  ),

                  silverWeight: _parseWeight(_silverWeightController.text),
                  silverPurity: _parseWeight(_silverPurityController.text),
                  silverPrice: _parseMoney(_silverPriceController.text),

                  personalSilverJewelleryWeight: _parseWeight(
                    _personalSilverJewelleryWeightController.text,
                  ),
                  personalSilverJewelleryPurity: _parseWeight(
                    _personalSilverJewelleryPurityController.text,
                  ),
                );

                final result = ZakatCalculator.calculateResult(
                  zakatInput,
                  _zakatSettings,
                );

                try {
                  await HistoryStorage().saveResult(
                    userId: widget.user.id,
                    result: result,
                  );

                  if (!mounted || !dialogContext.mounted) return;

                  Navigator.pop(dialogContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(result: result),
                    ),
                  );
                } catch (error) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not save calculation to history.'),
                    ),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openSettings() async {
    final settings = await Navigator.push<ZakatSettings>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SettingsScreen(settings: _zakatSettings, userId: widget.user.id),
      ),
    );

    if (!mounted || settings == null) return;

    setState(() {
      _zakatSettings = settings;
    });
  }

  Future<void> _logout() async {
    await AuthService().logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Asset Entry', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(userId: widget.user.id),
                ),
              );
            },
            tooltip: 'Zakat History',
            icon: const Icon(Icons.history, color: Colors.white),
          ),
          IconButton(
            onPressed: _openSettings,
            tooltip: 'Settings',
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
          IconButton(
            onPressed: _logout,
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Welcome, ${widget.user.name}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter Your Assets',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                _sectionTitle('Financial'),
                _moneyField(_cashController, 'Cash (PKR)'),
                _moneyField(_bankController, 'Bank Balance (PKR)'),
                _moneyField(_investmentController, 'Investments (PKR)'),
                _moneyField(_inventoryController, 'Business Inventory (PKR)'),
                _moneyField(
                  _goodReceivableController,
                  'Good Receivables (PKR)',
                ),
                _moneyField(
                  _doubtfulReceivableController,
                  'Doubtful Receivables (PKR)',
                ),
                _moneyField(_debtController, 'Debts (PKR)'),

                const SizedBox(height: 30),
                _sectionTitle('Gold'),
                _decimalField(_goldWeightController, 'Gold Weight (grams)'),
                _decimalField(
                  _goldPurityController,
                  'Gold Purity (Karat)',
                  validator: _validateGoldPurity,
                ),
                _decimalField(
                  _goldPriceController,
                  'Gold Price per gram (PKR)',
                  validator: _validateGoldPrice,
                ),

                if (_zakatSettings.madhhab == Madhhab.hanafi) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('Personal Gold Jewellery'),
                  _decimalField(
                    _personalGoldJewelleryWeightController,
                    'Jewellery Weight (grams)',
                  ),
                  _decimalField(
                    _personalGoldJewelleryPurityController,
                    'Jewellery Purity (Karat)',
                    validator: _validateGoldPurity,
                  ),
                ],

                const SizedBox(height: 30),
                _sectionTitle('Silver'),
                _decimalField(_silverWeightController, 'Silver Weight (grams)'),
                _decimalField(
                  _silverPurityController,
                  'Silver Purity',
                  validator: _validateSilverPurity,
                ),
                _decimalField(
                  _silverPriceController,
                  'Silver Price per gram (PKR)',
                  validator: _validateSilverPrice,
                ),

                if (_zakatSettings.madhhab == Madhhab.hanafi) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('Personal Silver Jewellery'),
                  _decimalField(
                    _personalSilverJewelleryWeightController,
                    'Jewellery Weight (grams)',
                  ),
                  _decimalField(
                    _personalSilverJewelleryPurityController,
                    'Jewellery Purity',
                    validator: _validateSilverPurity,
                  ),
                ],

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _continueToResult,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _moneyField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: _validateAmount,
    );
  }

  Widget _decimalField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: validator ?? _validateAmount,
    );
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    try {
      final amount = Decimal.parse(value.trim());
      if (amount < Decimal.zero) return 'Amount cannot be negative';
    } catch (_) {
      return 'Please enter a valid amount';
    }

    return null;
  }

  String? _validateGoldPrice(String? value) {
    if (_zakatSettings.nisabStandard != NisabStandard.gold) {
      return _validateAmount(value);
    }

    if (value == null || value.trim().isEmpty) {
      return 'Gold price is required for Gold Nisab';
    }

    return _validatePositivePrice(value);
  }

  String? _validateSilverPrice(String? value) {
    if (_zakatSettings.nisabStandard != NisabStandard.silver) {
      return _validateAmount(value);
    }

    if (value == null || value.trim().isEmpty) {
      return 'Silver price is required for Silver Nisab';
    }

    return _validatePositivePrice(value);
  }

  String? _validatePositivePrice(String value) {
    final error = _validateAmount(value);
    if (error != null) return error;

    if (_parseMoney(value) <= Decimal.zero) {
      return 'Price must be greater than zero';
    }

    return null;
  }

  String? _validateGoldPurity(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final purity = double.tryParse(value.trim());

    if (purity == null) return 'Please enter a valid purity';
    if (purity <= 0 || purity > 24) {
      return 'Purity must be greater than 0 and at most 24';
    }

    return null;
  }

  String? _validateSilverPurity(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final purity = double.tryParse(value.trim());

    if (purity == null) return 'Please enter a valid purity';
    if (purity <= 0 || purity > 24) {
      return 'Purity must be greater than 0 and at most 24';
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
    _personalGoldJewelleryWeightController.dispose();
    _personalGoldJewelleryPurityController.dispose();

    _silverWeightController.dispose();
    _silverPurityController.dispose();
    _silverPriceController.dispose();
    _personalSilverJewelleryWeightController.dispose();
    _personalSilverJewelleryPurityController.dispose();

    super.dispose();
  }
}
