import 'package:flutter/material.dart';

import '../models/zakat_settings.dart';
import '../models/zakat_result.dart';
import '../services/pdf_export_service.dart';

class ResultScreen extends StatefulWidget {
  final ZakatResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isExporting = false;

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);

    try {
      final path = await PdfExportService.generateAndSavePdf(widget.result);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved successfully to:\n$path'),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;

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

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: _isExporting ? null : _exportPdf,
                icon: _isExporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(_isExporting ? "Exporting..." : "Export PDF"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
