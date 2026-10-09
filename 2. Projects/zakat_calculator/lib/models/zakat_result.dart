import 'package:decimal/decimal.dart';

import 'zakat_settings.dart';

class ZakatResult {
  final Decimal cash;
  final Decimal bankBalance;
  final Decimal investments;
  final Decimal businessInventory;
  final Decimal goodReceivables;
  final Decimal doubtfulReceivables;
  final Decimal goldValue;
  final Decimal personalGoldJewelleryValue;
  final Decimal silverValue;
  final Decimal personalSilverJewelleryValue;
  final Decimal grossWealth;
  final Decimal debt;
  final Decimal netWealth;
  final Decimal nisab;
  final NisabStandard? nisabStandard;
  final bool zakatDue;
  final Decimal zakatAmount;

  ZakatResult({
    required this.cash,
    required this.bankBalance,
    required this.investments,
    required this.businessInventory,
    required this.goodReceivables,
    required this.doubtfulReceivables,
    required this.goldValue,
    required this.personalGoldJewelleryValue,
    required this.silverValue,
    required this.personalSilverJewelleryValue,
    required this.grossWealth,
    required this.debt,
    required this.netWealth,
    required this.nisab,
    this.nisabStandard,
    required this.zakatDue,
    required this.zakatAmount,
  });
}
