import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/zakat_settings.dart';

class SettingsScreen extends StatefulWidget {
  final ZakatSettings settings;
  final String userId;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.userId,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Madhhab _madhhab;
  late NisabStandard _nisabStandard;
  late bool _includeDoubtfulReceivables;
  bool _isLoading = true;

  String get _madhhabKey => 'madhhab_${widget.userId}';
  String get _nisabKey => 'nisabStandard_${widget.userId}';
  String get _doubtfulKey => 'includeDoubtfulReceivables_${widget.userId}';

  @override
  void initState() {
    super.initState();

    _madhhab = widget.settings.madhhab;
    _nisabStandard = widget.settings.nisabStandard;
    _includeDoubtfulReceivables = widget.settings.includeDoubtfulReceivables;

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _madhhab = Madhhab.values.firstWhere(
        (value) => value.name == prefs.getString(_madhhabKey),
        orElse: () => widget.settings.madhhab,
      );

      _nisabStandard = NisabStandard.values.firstWhere(
        (value) => value.name == prefs.getString(_nisabKey),
        orElse: () => widget.settings.nisabStandard,
      );

      _includeDoubtfulReceivables =
          prefs.getBool(_doubtfulKey) ??
          widget.settings.includeDoubtfulReceivables;

      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_madhhabKey, _madhhab.name);
    await prefs.setString(_nisabKey, _nisabStandard.name);
    await prefs.setBool(_doubtfulKey, _includeDoubtfulReceivables);

    if (!mounted) return;

    Navigator.pop(
      context,
      ZakatSettings(
        madhhab: _madhhab,
        nisabStandard: _nisabStandard,
        includeDoubtfulReceivables: _includeDoubtfulReceivables,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Madhhab',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<Madhhab>(
                    value: _madhhab,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: Madhhab.hanafi,
                        child: Text('Hanafi'),
                      ),
                      DropdownMenuItem(
                        value: Madhhab.maliki,
                        child: Text('Maliki'),
                      ),
                      DropdownMenuItem(
                        value: Madhhab.shafii,
                        child: Text("Shafi'i"),
                      ),
                      DropdownMenuItem(
                        value: Madhhab.hanbali,
                        child: Text('Hanbali'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _madhhab = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nisab Standard',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<NisabStandard>(
                    value: _nisabStandard,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: NisabStandard.silver,
                        child: Text('Silver'),
                      ),
                      DropdownMenuItem(
                        value: NisabStandard.gold,
                        child: Text('Gold'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _nisabStandard = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Include Doubtful Receivables'),
                    value: _includeDoubtfulReceivables,
                    onChanged: (value) {
                      setState(() => _includeDoubtfulReceivables = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
