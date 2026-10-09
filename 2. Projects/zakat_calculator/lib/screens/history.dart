import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

import '../models/zakat_result.dart';
import '../services/history_storage.dart';
import 'result.dart';

class HistoryScreen extends StatefulWidget {
  final String userId;

  const HistoryScreen({super.key, required this.userId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryStorage _historyStorage = HistoryStorage();

  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _historyFuture = _historyStorage.getHistory(widget.userId);
  }

  Decimal _money(Map<String, dynamic> record, String key) {
    return Decimal.parse(record[key] as String);
  }

  ZakatResult _createResult(Map<String, dynamic> record) {
    return ZakatResult(
      cash: _money(record, 'cash'),
      bankBalance: _money(record, 'bankBalance'),
      investments: _money(record, 'investments'),
      businessInventory: _money(record, 'businessInventory'),
      goodReceivables: _money(record, 'goodReceivables'),
      doubtfulReceivables: _money(record, 'doubtfulReceivables'),
      goldValue: _money(record, 'goldValue'),
      personalGoldJewelleryValue: _money(record, 'personalGoldJewelleryValue'),
      silverValue: _money(record, 'silverValue'),
      personalSilverJewelleryValue: _money(
        record,
        'personalSilverJewelleryValue',
      ),
      grossWealth: _money(record, 'grossWealth'),
      debt: _money(record, 'debt'),
      netWealth: _money(record, 'netWealth'),
      nisab: _money(record, 'nisab'),
      zakatAmount: _money(record, 'zakatAmount'),
      zakatDue: record['zakatDue'] as bool,
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}  '
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _refreshHistory() async {
    setState(_loadHistory);
    await _historyFuture;
  }

  void _openResult(Map<String, dynamic> record) {
    final result = _createResult(record);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not load Zakat history.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshHistory,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 50),
                  SizedBox(height: 12),
                  Text('No calculations yet', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Your saved Zakat calculations will appear here.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshHistory,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final zakatDue = record['zakatDue'] as bool;
                final amount = _money(record, 'zakatAmount');

                return Card(
                  child: ListTile(
                    leading: Icon(
                      zakatDue ? Icons.check_circle : Icons.info_outline,
                      color: zakatDue ? Colors.green : Colors.grey,
                    ),
                    title: Text('Zakat: PKR $amount'),
                    subtitle: Text(
                      '${_formatDate(record['date'] as String)}\n'
                      '${zakatDue ? 'Zakat is due' : 'Zakat is not due'}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openResult(record),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
