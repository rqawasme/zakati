import '../../models/zakat_calculation_state.dart';

/// Pure Maliki Zakat calculation logic.
/// All monetary outputs are in the user's selected local currency.
/// Gold/silver prices are stored in USD per troy oz and converted via
/// [ZakatCalculationState.exchangeRateFromUSD].
///
/// TODO: Replace hardcoded prices with live gold/silver price API.
abstract final class ZakatCalculator {
  static const double troyOzToGrams = 31.1035;
  static const double goldNisabGrams = 85.0;
  static const double silverNisabGrams = 595.0;
  static const double zakatRate = 0.025;

  /// Gold price per gram in local currency.
  static double goldPricePerGramLocal(ZakatCalculationState s) =>
      (s.goldPricePerOz * s.exchangeRateFromUSD) / troyOzToGrams;

  /// Silver price per gram in local currency.
  static double silverPricePerGramLocal(ZakatCalculationState s) =>
      (s.silverPricePerOz * s.exchangeRateFromUSD) / troyOzToGrams;

  /// Gold nisab threshold in local currency.
  static double goldNisabThreshold(ZakatCalculationState s) =>
      goldPricePerGramLocal(s) * goldNisabGrams;

  /// Silver nisab threshold in local currency.
  static double silverNisabThreshold(ZakatCalculationState s) =>
      silverPricePerGramLocal(s) * silverNisabGrams;

  /// Maliki rule: use silver nisab ONLY when silver is the sole zakatable asset.
  /// In all other cases — gold owned, cash held, jewellery for investment,
  /// or recoverable debts — the gold nisab applies.
  static String determineNisab(ZakatCalculationState s, double jewelleryInvestmentValue) {
    final hasSilverOnly = s.silverWeightGrams > 0 &&
        s.goldWeightGrams == 0 &&
        s.cashBank == 0 &&
        s.cashInHand == 0 &&
        jewelleryInvestmentValue == 0 &&
        s.debtsReceivable == 0;
    return hasSilverOnly ? 'silver' : 'gold';
  }

  /// Compute all derived values and return an updated state.
  static ZakatCalculationState compute(ZakatCalculationState s) {
    final goldPpg = goldPricePerGramLocal(s);
    final silverPpg = silverPricePerGramLocal(s);

    final goldValue = s.goldWeightGrams * goldPpg;
    final silverValue = s.silverWeightGrams * silverPpg;
    final cashTotal = s.cashBank + s.cashInHand;

    // Jewellery — Maliki: beautification exempt, investment zakatable
    double jewelleryInvestmentValue = 0;
    for (final item in s.jewelleryItems) {
      if (item.purpose == 'investment') {
        final ppg = item.material == 'gold' ? goldPpg : silverPpg;
        final pureGrams = item.weightGrams * (item.purityPercent / 100);
        jewelleryInvestmentValue += pureGrams * ppg;
      }
    }

    final largeAnnualDeduction = s.largeLiabilitiesMonthly * 12;

    final zakatableWealth = goldValue +
        silverValue +
        cashTotal +
        jewelleryInvestmentValue +
        s.debtsReceivable -
        s.debtsOwed -
        largeAnnualDeduction -
        s.unpaidPreviousZakat;

    // Maliki nisab selection
    final nisabUsed = determineNisab(s, jewelleryInvestmentValue);
    final nisab = nisabUsed == 'silver'
        ? silverNisabThreshold(s)
        : goldNisabThreshold(s);

    final metNisab = zakatableWealth >= nisab;
    final zakatDue = metNisab ? zakatableWealth * zakatRate : 0.0;

    final breakdown = <String, double>{
      'Gold & Silver': goldValue + silverValue,
      'Cash': cashTotal,
      'Jewellery — Investment': jewelleryInvestmentValue,
      'Debts Receivable': s.debtsReceivable,
      'Debts Owed': -s.debtsOwed,
      'Large Liabilities (12 mo.)': -largeAnnualDeduction,
      'Unpaid Previous Zakat': -s.unpaidPreviousZakat,
    };

    return s.copyWith(
      totalZakatableWealth: zakatableWealth,
      zakatDue: zakatDue,
      metNisab: metNisab,
      nisabUsed: nisabUsed,
      breakdown: breakdown,
    );
  }
}
