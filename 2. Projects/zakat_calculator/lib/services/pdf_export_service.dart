import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/zakat_result.dart';
import '../models/zakat_settings.dart';

class PdfExportService {
  static Future<String> generateAndSavePdf(ZakatResult result) async {
    final pdf = pw.Document();

    final nisabStandardName = result.nisabStandard == NisabStandard.silver
        ? 'Silver'
        : result.nisabStandard == NisabStandard.gold
        ? 'Gold'
        : 'Not recorded';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            pw.Text(
              'Zakat Result',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 15),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 15),
            pw.Text(
              'Asset Breakdown',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            _buildRow('Cash', '${result.cash}'),
            _buildRow('Bank Balance', '${result.bankBalance}'),
            _buildRow('Investments', '${result.investments}'),
            _buildRow('Business Inventory', '${result.businessInventory}'),
            _buildRow('Good Receivables', '${result.goodReceivables}'),
            _buildRow(
              'Doubtful Receivables Included',
              '${result.doubtfulReceivables}',
            ),
            _buildRow('Gold', '${result.goldValue}'),
            _buildRow(
              'Personal Gold Jewellery',
              '${result.personalGoldJewelleryValue}',
            ),
            _buildRow('Silver', '${result.silverValue}'),
            _buildRow(
              'Personal Silver Jewellery',
              '${result.personalSilverJewelleryValue}',
            ),

            pw.SizedBox(height: 20),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 15),
            pw.Text(
              'Wealth Summary',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            _buildRow('Gross Wealth', '${result.grossWealth}'),
            _buildRow('Debt Deducted', '${result.debt}'),
            _buildRow('Net Wealth', '${result.netWealth}'),
            _buildRow('Nisab Standard', nisabStandardName),
            _buildRow('Nisab Threshold', 'PKR ${result.nisab}'),

            pw.SizedBox(height: 20),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 15),
            pw.Text(
              'Final Result',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            _buildRow('Zakat Due', result.zakatDue ? 'Yes' : 'No'),
            _buildRow('Zakat Rate', '2.5%'),
            _buildRow('Zakat Amount', '${result.zakatAmount}'),
          ];
        },
      ),
    );

    final directory = await _getStorageDirectory();
    final fileName =
        'zakat_result_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static pw.Widget _buildRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 11)),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static Future<Directory> _getStorageDirectory() async {
    try {
      if (Platform.isAndroid) {
        final publicDownloads = Directory('/storage/emulated/0/Download');
        if (await publicDownloads.exists()) {
          return publicDownloads;
        }

        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          return externalDir;
        }
      }

      return await getApplicationDocumentsDirectory();
    } catch (_) {
      return await getApplicationDocumentsDirectory();
    }
  }
}
