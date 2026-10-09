import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';

import 'package:zakat_calculator/models/zakat_input.dart';
import 'package:zakat_calculator/models/zakat_settings.dart';
import 'package:zakat_calculator/services/zakat_calculator.dart';

void main() {
  const silverPrice = 250;
  const goldPrice = 20000;

  ZakatInput createInput({
    String cash = '0',
    String bankBalance = '0',
    String investments = '0',
    String businessInventory = '0',
    String goodReceivables = '0',
    String doubtfulReceivables = '0',
    String debt = '0',
    double goldWeight = 0,
    double goldPurity = 0,
    double personalGoldJewelleryWeight = 0,
    double personalGoldJewelleryPurity = 0,
    double silverWeight = 0,
    double silverPurity = 0,
    double personalSilverJewelleryWeight = 0,
    double personalSilverJewelleryPurity = 0,
  }) {
    return ZakatInput(
      cash: Decimal.parse(cash),
      bankBalance: Decimal.parse(bankBalance),
      investments: Decimal.parse(investments),
      businessInventory: Decimal.parse(businessInventory),
      goodReceivables: Decimal.parse(goodReceivables),
      doubtfulReceivables: Decimal.parse(doubtfulReceivables),
      debt: Decimal.parse(debt),
      goldWeight: goldWeight,
      goldPurity: goldPurity,
      goldPrice: Decimal.parse(goldPrice.toString()),
      personalGoldJewelleryWeight: personalGoldJewelleryWeight,
      personalGoldJewelleryPurity: personalGoldJewelleryPurity,
      silverWeight: silverWeight,
      silverPurity: silverPurity,
      silverPrice: Decimal.parse(silverPrice.toString()),
      personalSilverJewelleryWeight: personalSilverJewelleryWeight,
      personalSilverJewelleryPurity: personalSilverJewelleryPurity,
    );
  }

  ZakatSettings createSettings({
    Madhhab madhhab = Madhhab.hanafi,
    NisabStandard nisabStandard = NisabStandard.silver,
    bool includeDoubtfulReceivables = false,
  }) {
    return ZakatSettings(
      madhhab: madhhab,
      nisabStandard: nisabStandard,
      includeDoubtfulReceivables: includeDoubtfulReceivables,
    );
  }

  test('1. Cash below Nisab gives zero Zakat', () {
    final input = createInput(cash: '100000');
    final settings = createSettings();
    final result = ZakatCalculator.calculateResult(input, settings);
    expect(result.netWealth, Decimal.parse('100000'));
    expect(result.zakatAmount, Decimal.zero);
    expect(result.zakatDue, false);
  });

  test('2. Cash above Nisab gives 2.5 percent Zakat', () {
    final input = createInput(cash: '200000');
    final settings = createSettings();
    final result = ZakatCalculator.calculateResult(input, settings);
    expect(result.zakatAmount, Decimal.parse('5000'));
    expect(result.zakatDue, true);
  });

  test('3. Wealth exactly at Nisab is zakatable', () {
    final input = createInput(cash: '153090');
    final settings = createSettings();
    final result = ZakatCalculator.calculateResult(input, settings);
    expect(result.nisab, Decimal.parse('153090'));
    expect(result.zakatAmount, Decimal.parse('3827.25'));
    expect(result.zakatDue, true);
  });

  test('4. Wealth just below Nisab is not zakatable', () {
    final input = createInput(cash: '153089.99');
    final settings = createSettings();
    final result = ZakatCalculator.calculateResult(input, settings);
    expect(result.zakatAmount, Decimal.zero);
    expect(result.zakatDue, false);
  });

  test('5. 50g pure gold is zakatable', () {
    final input = createInput(goldWeight: 50, goldPurity: 24);
    final settings = createSettings();
    final result = ZakatCalculator.calculateResult(input, settings);
    expect(result.goldValue, Decimal.parse('1000000'));
    expect(result.zakatAmount, Decimal.parse('25000'));
    expect(result.zakatDue, true);
  });

  test('6. 50g 22K gold uses fine gold weight', () {
    final input = createInput(goldWeight: 50, goldPurity: 22);
    final settings = createSettings(nisabStandard: NisabStandard.silver);
    final result = ZakatCalculator.calculateResult(input, settings);
    expect(result.goldValue, Decimal.parse('916666.6666666666'));
    expect(result.zakatAmount, Decimal.parse('22916.67'));
    expect(result.zakatDue, true);
  });

  test('7. Debt reduces zakatable wealth', () {
    final input = createInput(cash: '200000', debt: '60000');
    final settings = createSettings();
    final result = ZakatCalculator.calculateResult(input, settings);
    expect(result.netWealth, Decimal.parse('140000'));
    expect(result.zakatAmount, Decimal.zero);
    expect(result.zakatDue, false);
  });

  test('8. Debt greater than assets floors wealth at zero', () {
    final input = createInput(cash: '50000', debt: '80000');

    final settings = createSettings();

    final result = ZakatCalculator.calculateResult(input, settings);

    expect(result.netWealth, Decimal.zero);
    expect(result.zakatAmount, Decimal.zero);
    expect(result.zakatDue, false);
  });

  test('9. Good receivables are included', () {
    final input = createInput(cash: '100000', goodReceivables: '80000');

    final settings = createSettings();

    final result = ZakatCalculator.calculateResult(input, settings);

    expect(result.grossWealth, Decimal.parse('180000'));
    expect(result.zakatAmount, Decimal.parse('4500'));
  });

  test('10. Doubtful receivables are excluded by default', () {
    final input = createInput(
      cash: '100000',
      goodReceivables: '80000',
      doubtfulReceivables: '50000',
    );

    final settings = createSettings(includeDoubtfulReceivables: false);

    final result = ZakatCalculator.calculateResult(input, settings);

    expect(result.grossWealth, Decimal.parse('180000'));
    expect(result.doubtfulReceivables, Decimal.zero);
    expect(result.zakatAmount, Decimal.parse('4500'));
  });

  test('11. Doubtful receivables can be included', () {
    final input = createInput(
      cash: '100000',
      goodReceivables: '80000',
      doubtfulReceivables: '50000',
    );

    final settings = createSettings(includeDoubtfulReceivables: true);

    final result = ZakatCalculator.calculateResult(input, settings);

    expect(result.grossWealth, Decimal.parse('230000'));
    expect(result.doubtfulReceivables, Decimal.parse('50000'));
    expect(result.zakatAmount, Decimal.parse('5750'));
  });

  test('12. Hanafi personal gold jewellery is zakatable', () {
    final input = createInput(
      personalGoldJewelleryWeight: 40,
      personalGoldJewelleryPurity: 24,
    );

    final settings = createSettings(madhhab: Madhhab.hanafi);

    final result = ZakatCalculator.calculateResult(input, settings);

    expect(
      ZakatCalculator.calculatePersonalGoldJewelleryValue(input, settings),
      Decimal.parse('800000'),
    );
    expect(result.zakatAmount, Decimal.parse('20000'));
    expect(result.zakatDue, true);
  });

  test('13. Personal jewellery is exempt for Maliki, Shafii and Hanbali', () {
    final input = createInput(
      personalGoldJewelleryWeight: 40,
      personalGoldJewelleryPurity: 24,
    );

    final malikiResult = ZakatCalculator.calculateResult(
      input,
      createSettings(
        madhhab: Madhhab.maliki,
        nisabStandard: NisabStandard.gold,
      ),
    );

    final shafiiResult = ZakatCalculator.calculateResult(
      input,
      createSettings(
        madhhab: Madhhab.shafii,
        nisabStandard: NisabStandard.gold,
      ),
    );

    final hanbaliResult = ZakatCalculator.calculateResult(
      input,
      createSettings(
        madhhab: Madhhab.hanbali,
        nisabStandard: NisabStandard.gold,
      ),
    );

    expect(
      ZakatCalculator.calculatePersonalGoldJewelleryValue(
        input,
        createSettings(madhhab: Madhhab.maliki),
      ),
      Decimal.zero,
    );
    expect(malikiResult.zakatAmount, Decimal.zero);

    expect(
      ZakatCalculator.calculatePersonalGoldJewelleryValue(
        input,
        createSettings(madhhab: Madhhab.shafii),
      ),
      Decimal.zero,
    );
    expect(shafiiResult.zakatAmount, Decimal.zero);

    expect(
      ZakatCalculator.calculatePersonalGoldJewelleryValue(
        input,
        createSettings(madhhab: Madhhab.hanbali),
      ),
      Decimal.zero,
    );
    expect(hanbaliResult.zakatAmount, Decimal.zero);
  });

  test('14. Business inventory is included', () {
    final input = createInput(cash: '20000', businessInventory: '500000');

    final settings = createSettings();

    final result = ZakatCalculator.calculateResult(input, settings);

    expect(result.grossWealth, Decimal.parse('520000'));
    expect(result.zakatAmount, Decimal.parse('13000'));
    expect(result.zakatDue, true);
  });

  test('15. Empty assets result in zero Zakat', () {
    final input = createInput();
    final settings = createSettings();

    final result = ZakatCalculator.calculateResult(input, settings);

    expect(result.grossWealth, Decimal.zero);
    expect(result.netWealth, Decimal.zero);
    expect(result.zakatAmount, Decimal.zero);
    expect(result.zakatDue, false);
  });
}
