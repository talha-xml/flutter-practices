import 'package:flutter/material.dart';

import '../models/zakat_settings.dart';
import '../models/zakat_result.dart';

class ResultScreen extends StatelessWidget {
  final ZakatResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zakat Result")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Asset Breakdown",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text("Cash: ${result.cash}"),
            Text("Bank Balance: ${result.bankBalance}"),
            Text("Investments: ${result.investments}"),
            Text("Business Inventory: ${result.businessInventory}"),
            Text("Good Receivables: ${result.goodReceivables}"),
            Text(
              "Doubtful Receivables Included: "
              "${result.doubtfulReceivables}",
            ),
            Text("Gold: ${result.goldValue}"),
            Text(
              "Personal Gold Jewellery: "
              "${result.personalGoldJewelleryValue}",
            ),
            Text("Silver: ${result.silverValue}"),
            Text(
              "Personal Silver Jewellery: "
              "${result.personalSilverJewelleryValue}",
            ),

            const SizedBox(height: 20),
            const Text(
              "Wealth Summary",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text("Gross Wealth: ${result.grossWealth}"),
            Text("Debt Deducted: ${result.debt}"),
            Text("Net Wealth: ${result.netWealth}"),

            Text(
              "Nisab Standard: ${result.nisabStandard == NisabStandard.silver
                  ? "Silver"
                  : result.nisabStandard == NisabStandard.gold
                  ? "Gold"
                  : "Not recorded"}",
            ),
            Text("Nisab Threshold: PKR ${result.nisab}"),

            const SizedBox(height: 20),
            const Text(
              "Final Result",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text("Zakat Due: ${result.zakatDue ? "Yes" : "No"}"),
            Text("Zakat Rate: 2.5%"),
            Text("Zakat Amount: ${result.zakatAmount}"),
          ],
        ),
      ),
    );
  }
}
