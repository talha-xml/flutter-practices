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
    final primaryColor = Theme.of(context).colorScheme.primary;

    final nisabStandardText = result.nisabStandard == NisabStandard.silver
        ? "Silver"
        : result.nisabStandard == NisabStandard.gold
            ? "Gold"
            : "Not recorded";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Zakat Result",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Final Result Highlight Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: result.zakatDue ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Zakat Status',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: result.zakatDue ? primaryColor : Colors.grey[600],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            result.zakatDue ? 'ZAKAT DUE' : 'NOT DUE',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _itemRow('Zakat Rate', '2.5%'),
                    const SizedBox(height: 6),
                    _itemRow(
                      'Zakat Amount Payable',
                      'PKR ${result.zakatAmount}',
                      isBold: true,
                      fontSize: 16,
                      valueColor: result.zakatDue ? primaryColor : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Wealth Summary Card
            _buildSectionCard(
              title: "Wealth Summary",
              children: [
                _itemRow("Gross Wealth", "PKR ${result.grossWealth}"),
                _itemRow("Debt Deducted", "PKR ${result.debt}"),
                _itemRow("Net Wealth", "PKR ${result.netWealth}"),
                _itemRow("Nisab Standard", nisabStandardText),
                _itemRow("Nisab Threshold", "PKR ${result.nisab}"),
              ],
            ),

            const SizedBox(height: 16),

            // Asset Breakdown Card
            _buildSectionCard(
              title: "Asset Breakdown",
              children: [
                _itemRow("Cash", "${result.cash}"),
                _itemRow("Bank Balance", "${result.bankBalance}"),
                _itemRow("Investments", "${result.investments}"),
                _itemRow("Business Inventory", "${result.businessInventory}"),
                _itemRow("Good Receivables", "${result.goodReceivables}"),
                _itemRow(
                  "Doubtful Receivables",
                  "${result.doubtfulReceivables}",
                ),
                _itemRow("Gold Value", "PKR ${result.goldValue}"),
                _itemRow(
                  "Personal Gold Jewellery",
                  "PKR ${result.personalGoldJewelleryValue}",
                ),
                _itemRow("Silver Value", "PKR ${result.silverValue}"),
                _itemRow(
                  "Personal Silver Jewellery",
                  "PKR ${result.personalSilverJewelleryValue}",
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Export PDF Button
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _itemRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 13,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[800],
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
