import 'package:decimal/decimal.dart';

import '../models/zakat_input.dart';
import '../models/zakat_settings.dart';
import '../models/zakat_result.dart';

class ZakatCalculator {
  static Decimal calculateGoldValue(ZakatInput input, ZakatSettings settings) {
    final fineGoldWeight = input.goldWeight * (input.goldPurity / 24);

    final fineGoldWeightDecimal = Decimal.parse(fineGoldWeight.toString());

    return fineGoldWeightDecimal * input.goldPrice;
  }

  static Decimal calculatePersonalGoldJewelleryValue(
    ZakatInput input,
    ZakatSettings settings,
  ) {
    if (settings.madhhab != Madhhab.hanafi) {
      return Decimal.zero;
    }

    final fineGoldWeight =
        input.personalGoldJewelleryWeight *
        (input.personalGoldJewelleryPurity / 24);

    final fineGoldWeightDecimal = Decimal.parse(fineGoldWeight.toString());

    return fineGoldWeightDecimal * input.goldPrice;
  }

  static Decimal calculateSilverValue(
    ZakatInput input,
    ZakatSettings settings,
  ) {
    final fineSilverWeight = input.silverWeight * (input.silverPurity / 24);

    final fineSilverWeightDecimal = Decimal.parse(fineSilverWeight.toString());

    return fineSilverWeightDecimal * input.silverPrice;
  }

  static Decimal calculatePersonalSilverJewelleryValue(
    ZakatInput input,
    ZakatSettings settings,
  ) {
    if (settings.madhhab != Madhhab.hanafi) {
      return Decimal.zero;
    }

    final fineSilverWeight =
        input.personalSilverJewelleryWeight *
        (input.personalSilverJewelleryPurity / 24);

    final fineSilverWeightDecimal = Decimal.parse(fineSilverWeight.toString());

    return fineSilverWeightDecimal * input.silverPrice;
  }

  static Decimal calculateGrossWealth(
    ZakatInput input,
    ZakatSettings settings,
  ) {
    final goldValue = calculateGoldValue(input, settings);

    final personalGoldJewelleryValue = calculatePersonalGoldJewelleryValue(
      input,
      settings,
    );

    final silverValue = calculateSilverValue(input, settings);

    final personalSilverJewelleryValue = calculatePersonalSilverJewelleryValue(
      input,
      settings,
    );

    Decimal doubtfulReceivables = Decimal.zero;

    if (settings.includeDoubtfulReceivables) {
      doubtfulReceivables = input.doubtfulReceivables;
    }

    return input.cash +
        input.bankBalance +
        input.investments +
        input.businessInventory +
        input.goodReceivables +
        doubtfulReceivables +
        goldValue +
        personalGoldJewelleryValue +
        silverValue +
        personalSilverJewelleryValue;
  }

  static Decimal calculateNetWealth(ZakatInput input, ZakatSettings settings) {
    final grossWealth = calculateGrossWealth(input, settings);

    final netWealth = grossWealth - input.debt;

    if (netWealth < Decimal.zero) {
      return Decimal.zero;
    }

    return netWealth;
  }

  static Decimal calculateNisab(ZakatInput input, ZakatSettings settings) {
    if (settings.nisabStandard == NisabStandard.silver) {
      final silverNisabWeight = Decimal.parse('612.36');

      return silverNisabWeight * input.silverPrice;
    }

    final goldNisabWeight = Decimal.parse('87.48');

    return goldNisabWeight * input.goldPrice;
  }

  static Decimal calculateZakat(ZakatInput input, ZakatSettings settings) {
    final netWealth = calculateNetWealth(input, settings);

    final nisab = calculateNisab(input, settings);

    if (netWealth >= nisab) {
      return (netWealth * Decimal.parse('0.025')).round(scale: 2);
    }

    return Decimal.zero;
  }

  static ZakatResult calculateResult(ZakatInput input, ZakatSettings settings) {
    final goldValue = calculateGoldValue(input, settings);

    final personalGoldJewelleryValue = calculatePersonalGoldJewelleryValue(
      input,
      settings,
    );

    final silverValue = calculateSilverValue(input, settings);

    final personalSilverJewelleryValue = calculatePersonalSilverJewelleryValue(
      input,
      settings,
    );

    Decimal doubtfulReceivables = Decimal.zero;

    if (settings.includeDoubtfulReceivables) {
      doubtfulReceivables = input.doubtfulReceivables;
    }

    final grossWealth =
        input.cash +
        input.bankBalance +
        input.investments +
        input.businessInventory +
        input.goodReceivables +
        doubtfulReceivables +
        goldValue +
        personalGoldJewelleryValue +
        silverValue +
        personalSilverJewelleryValue;

    final netWealth = grossWealth - input.debt;

    Decimal finalNetWealth = netWealth;

    if (finalNetWealth < Decimal.zero) {
      finalNetWealth = Decimal.zero;
    }

    final nisab = calculateNisab(input, settings);

    bool zakatDue = false;
    Decimal zakatAmount = Decimal.zero;

    if (finalNetWealth > Decimal.zero &&
        nisab > Decimal.zero &&
        finalNetWealth >= nisab) {
      zakatDue = true;
      zakatAmount = (finalNetWealth * Decimal.parse('0.025')).round(scale: 2);
    }

    return ZakatResult(
      cash: input.cash,
      bankBalance: input.bankBalance,
      investments: input.investments,
      businessInventory: input.businessInventory,
      goodReceivables: input.goodReceivables,
      doubtfulReceivables: doubtfulReceivables,
      goldValue: goldValue,
      personalGoldJewelleryValue: personalGoldJewelleryValue,
      silverValue: silverValue,
      personalSilverJewelleryValue: personalSilverJewelleryValue,
      grossWealth: grossWealth,
      debt: input.debt,
      netWealth: finalNetWealth,
      nisab: nisab,
      nisabStandard: settings.nisabStandard,
      zakatDue: zakatDue,
      zakatAmount: zakatAmount,
    );
  }
}
