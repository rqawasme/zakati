import 'jewellery_item.dart';

class ZakatCalculationState {
  // ── Preferences (set on Welcome screen) ───────────────────────────────────
  final String currency;            // e.g. 'CAD'
  final String currencySymbol;      // e.g. '$'
  final double exchangeRateFromUSD; // approximate hardcoded rate
  final String weightUnit;          // 'g' or 'oz'

  // ── Meta ──────────────────────────────────────────────────────────────────
  final String? madhab;
  // haulCompleted removed — haul screen is now informational only

  // ── Assets — Gold & Silver (always stored internally in grams) ────────────
  final double goldWeightGrams;
  final double silverWeightGrams;

  // ── Assets — Cash ─────────────────────────────────────────────────────────
  final double cashBank;
  final double cashInHand;

  // ── Assets — Jewellery (weightGrams always stored in grams) ───────────────
  final List<JewelleryItem> jewelleryItems;

  // ── Liabilities ───────────────────────────────────────────────────────────
  final double debtsOwed;
  final double debtsReceivable;
  final double largeLiabilitiesMonthly;
  final double unpaidPreviousZakat;

  // ── Nisab prices — USD per troy oz (hardcoded v1) ─────────────────────────
  // TODO: Replace with live gold/silver price API
  final double goldPricePerOz;
  final double silverPricePerOz;

  // ── Results (computed on NisabScreen) ─────────────────────────────────────
  final double totalZakatableWealth;
  final double zakatDue;
  final bool metNisab;
  final String nisabUsed; // 'gold' or 'silver'
  final Map<String, double> breakdown;

  const ZakatCalculationState({
    this.currency = 'CAD',
    this.currencySymbol = '\$',
    this.exchangeRateFromUSD = 1.36,
    this.weightUnit = 'g',
    this.madhab,
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
    this.nisabUsed = 'gold',
    this.breakdown = const {},
  });

  ZakatCalculationState copyWith({
    String? currency,
    String? currencySymbol,
    double? exchangeRateFromUSD,
    String? weightUnit,
    String? madhab,
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
    String? nisabUsed,
    Map<String, double>? breakdown,
  }) {
    return ZakatCalculationState(
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      exchangeRateFromUSD: exchangeRateFromUSD ?? this.exchangeRateFromUSD,
      weightUnit: weightUnit ?? this.weightUnit,
      madhab: madhab ?? this.madhab,
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
      nisabUsed: nisabUsed ?? this.nisabUsed,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  /// Resets calculator inputs but preserves currency & weight unit preferences.
  ZakatCalculationState resetCalculation() => ZakatCalculationState(
        currency: currency,
        currencySymbol: currencySymbol,
        exchangeRateFromUSD: exchangeRateFromUSD,
        weightUnit: weightUnit,
        // TODO: Replace with live gold/silver price API
        goldPricePerOz: 6000.0,
        silverPricePerOz: 40.0,
      );
}
