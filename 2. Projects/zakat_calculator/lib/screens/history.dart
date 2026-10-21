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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Zakat History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 56, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No calculations yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Your saved Zakat calculations will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshHistory,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final zakatDue = record['zakatDue'] as bool;
                final amount = _money(record, 'zakatAmount');

                return Card(
                  elevation: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: zakatDue
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFEEEEEE),
                      child: Icon(
                        zakatDue ? Icons.check_circle : Icons.info_outline,
                        color: zakatDue ? Colors.green[700] : Colors.grey[600],
                      ),
                    ),
                    title: Text(
                      'Zakat: PKR $amount',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      zakatDue ? 'Zakat is due' : 'Zakat is not due',
                      style: TextStyle(
                        color: zakatDue ? Colors.green[800] : Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
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
