import '../../models/zakat_calculation_state.dart';
import '../../models/jewellery_item.dart';

/// Pure Maliki Zakat calculation logic.
/// All monetary values are in the user's local currency (v1: CAD, symbol $).
///
/// TODO: Replace with live gold/silver price API
abstract final class ZakatCalculator {
  static const double _troyOzToGrams = 31.1035;
  static const double _goldNisabGrams = 85.0;
  static const double _zakatRate = 0.025;

  /// Price per gram from price per troy oz
  static double pricePerGram(double pricePerOz) => pricePerOz / _troyOzToGrams;

  static double goldNisabThreshold(double goldPricePerOz) =>
      pricePerGram(goldPricePerOz) * _goldNisabGrams;

  static double silverNisabThreshold(double silverPricePerOz) =>
      pricePerGram(silverPricePerOz) * 595;

  /// Compute all derived values and return an updated state.
  static ZakatCalculationState compute(ZakatCalculationState s) {
    final goldPricePerGram = pricePerGram(s.goldPricePerOz);
    final silverPricePerGram = pricePerGram(s.silverPricePerOz);

    // Asset values
    final goldValue = s.goldWeightGrams * goldPricePerGram;
    final silverValue = s.silverWeightGrams * silverPricePerGram;
    final cashTotal = s.cashBank + s.cashInHand;

    // Jewellery — Maliki: beautification exempt, investment zakatable
    double jewelleryInvestmentValue = 0;
    for (final item in s.jewelleryItems) {
      if (item.purpose == 'investment') {
        final pricePerGram = item.material == 'gold'
            ? goldPricePerGram
            : silverPricePerGram;
        final pureWeight = item.weightGrams * (item.purityPercent / 100);
        jewelleryInvestmentValue += pureWeight * pricePerGram;
      }
    }

    // Liabilities
    final largeAnnualDeduction = s.largeLiabilitiesMonthly * 12;

    // Zakatable wealth formula (Maliki)
    final zakatableWealth = goldValue +
        silverValue +
        cashTotal +
        jewelleryInvestmentValue +
        s.debtsReceivable -
        s.debtsOwed -
        largeAnnualDeduction -
        s.unpaidPreviousZakat;

    final nisabThreshold = goldNisabThreshold(s.goldPricePerOz);
    final metNisab = zakatableWealth >= nisabThreshold;
    final zakatDue = metNisab ? zakatableWealth * _zakatRate : 0.0;

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
      breakdown: breakdown,
    );
  }
}
