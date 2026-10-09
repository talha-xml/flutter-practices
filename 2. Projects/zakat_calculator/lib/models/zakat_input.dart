import 'package:decimal/decimal.dart';

class ZakatInput {
  final Decimal cash;
  final Decimal bankBalance;
  final Decimal investments;
  final Decimal businessInventory;
  final Decimal goodReceivables;
  final Decimal doubtfulReceivables;
  final Decimal debt;
  final double goldWeight;
  final double goldPurity;
  final Decimal goldPrice;
  final double personalGoldJewelleryWeight;
  final double personalGoldJewelleryPurity;
  final double silverWeight;
  final double silverPurity;
  final Decimal silverPrice;
  final double personalSilverJewelleryWeight;
  final double personalSilverJewelleryPurity;

  ZakatInput({
    required this.cash,
    required this.bankBalance,
    required this.investments,
    required this.businessInventory,
    required this.goodReceivables,
    required this.doubtfulReceivables,
    required this.debt,
    required this.goldWeight,
    required this.goldPurity,
    required this.goldPrice,
    required this.personalGoldJewelleryWeight,
    required this.personalGoldJewelleryPurity,
    required this.silverWeight,
    required this.silverPurity,
    required this.silverPrice,
    required this.personalSilverJewelleryWeight,
    required this.personalSilverJewelleryPurity,
  });
}
