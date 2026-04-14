import 'jewellery_item.dart';

class ZakatCalculationState {
  // Meta
  final String? madhab;
  final bool? haulCompleted;

  // Assets — Gold & Silver
  final double goldWeightGrams;
  final double silverWeightGrams;

  // Assets — Cash
  final double cashBank;
  final double cashInHand;

  // Assets — Jewellery
  final List<JewelleryItem> jewelleryItems;

  // Liabilities
  final double debtsOwed;
  final double debtsReceivable;
  final double largeLiabilitiesMonthly;
  final double unpaidPreviousZakat;

  // Nisab prices (hardcoded v1)
  // TODO: Replace with live gold/silver price API
  final double goldPricePerOz;
  final double silverPricePerOz;

  // Results (computed on NisabScreen)
  final double totalZakatableWealth;
  final double zakatDue;
  final bool metNisab;
  final Map<String, double> breakdown;

  const ZakatCalculationState({
    this.madhab,
    this.haulCompleted,
    this.goldWeightGrams = 0,
    this.silverWeightGrams = 0,
    this.cashBank = 0,
    this.cashInHand = 0,
    this.jewelleryItems = const [],
    this.debtsOwed = 0,
    this.debtsReceivable = 0,
    this.largeLiabilitiesMonthly = 0,
    this.unpaidPreviousZakat = 0,
    // TODO: Replace with live gold/silver price API
    this.goldPricePerOz = 6000.0,
    this.silverPricePerOz = 40.0,
    this.totalZakatableWealth = 0,
    this.zakatDue = 0,
    this.metNisab = false,
    this.breakdown = const {},
  });

  ZakatCalculationState copyWith({
    String? madhab,
    bool? haulCompleted,
    double? goldWeightGrams,
    double? silverWeightGrams,
    double? cashBank,
    double? cashInHand,
    List<JewelleryItem>? jewelleryItems,
    double? debtsOwed,
    double? debtsReceivable,
    double? largeLiabilitiesMonthly,
    double? unpaidPreviousZakat,
    double? goldPricePerOz,
    double? silverPricePerOz,
    double? totalZakatableWealth,
    double? zakatDue,
    bool? metNisab,
    Map<String, double>? breakdown,
  }) {
    return ZakatCalculationState(
      madhab: madhab ?? this.madhab,
      haulCompleted: haulCompleted ?? this.haulCompleted,
      goldWeightGrams: goldWeightGrams ?? this.goldWeightGrams,
      silverWeightGrams: silverWeightGrams ?? this.silverWeightGrams,
      cashBank: cashBank ?? this.cashBank,
      cashInHand: cashInHand ?? this.cashInHand,
      jewelleryItems: jewelleryItems ?? this.jewelleryItems,
      debtsOwed: debtsOwed ?? this.debtsOwed,
      debtsReceivable: debtsReceivable ?? this.debtsReceivable,
      largeLiabilitiesMonthly:
          largeLiabilitiesMonthly ?? this.largeLiabilitiesMonthly,
      unpaidPreviousZakat: unpaidPreviousZakat ?? this.unpaidPreviousZakat,
      goldPricePerOz: goldPricePerOz ?? this.goldPricePerOz,
      silverPricePerOz: silverPricePerOz ?? this.silverPricePerOz,
      totalZakatableWealth: totalZakatableWealth ?? this.totalZakatableWealth,
      zakatDue: zakatDue ?? this.zakatDue,
      metNisab: metNisab ?? this.metNisab,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  ZakatCalculationState reset() => const ZakatCalculationState(
        // TODO: Replace with live gold/silver price API
        goldPricePerOz: 6000.0,
        silverPricePerOz: 40.0,
      );
}
