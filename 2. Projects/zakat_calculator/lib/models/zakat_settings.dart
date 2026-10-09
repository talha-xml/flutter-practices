enum Madhhab { hanafi, maliki, shafii, hanbali }

enum NisabStandard { silver, gold }

class ZakatSettings {
  final Madhhab madhhab;
  final NisabStandard nisabStandard;
  final bool includeDoubtfulReceivables;

  ZakatSettings({
    this.madhhab = Madhhab.hanafi,
    this.nisabStandard = NisabStandard.silver,
    this.includeDoubtfulReceivables = false,
  });
}
