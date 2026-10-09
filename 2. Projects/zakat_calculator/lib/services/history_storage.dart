import 'package:hive_flutter/hive_flutter.dart';

import '../models/zakat_result.dart';

class HistoryStorage {
  static const String _boxName = 'zakat_history';

  Future<void> saveResult({
    required String userId,
    required ZakatResult result,
  }) async {
    final box = await Hive.openBox(_boxName);

    final id = DateTime.now().microsecondsSinceEpoch.toString();

    await box.put(id, {
      'id': id,
      'userId': userId,
      'date': DateTime.now().toIso8601String(),

      'cash': result.cash.toString(),
      'bankBalance': result.bankBalance.toString(),
      'investments': result.investments.toString(),
      'businessInventory': result.businessInventory.toString(),
      'goodReceivables': result.goodReceivables.toString(),
      'doubtfulReceivables': result.doubtfulReceivables.toString(),

      'goldValue': result.goldValue.toString(),
      'personalGoldJewelleryValue': result.personalGoldJewelleryValue
          .toString(),
      'silverValue': result.silverValue.toString(),
      'personalSilverJewelleryValue': result.personalSilverJewelleryValue
          .toString(),

      'grossWealth': result.grossWealth.toString(),
      'debt': result.debt.toString(),
      'netWealth': result.netWealth.toString(),
      'nisab': result.nisab.toString(),
      'zakatAmount': result.zakatAmount.toString(),
      'zakatDue': result.zakatDue,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory(String userId) async {
    final box = await Hive.openBox(_boxName);

    final records = box.values
        .where((record) => record['userId'] == userId)
        .map((record) => Map<String, dynamic>.from(record as Map))
        .toList();

    records.sort(
      (a, b) => (b['date'] as String).compareTo(a['date'] as String),
    );

    return records;
  }
}
