import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/zakat_calculation_state.dart';
import '../models/jewellery_item.dart';

class ZakatNotifier extends Notifier<ZakatCalculationState> {
  @override
  ZakatCalculationState build() => const ZakatCalculationState();

  // ── Preferences ───────────────────────────────────────────────────────────

  void setCurrency(String code, String symbol, double rateFromUSD) =>
      state = state.copyWith(
        currency: code,
        currencySymbol: symbol,
        exchangeRateFromUSD: rateFromUSD,
      );

  void setWeightUnit(String unit) =>
      state = state.copyWith(weightUnit: unit);

  // ── Meta ──────────────────────────────────────────────────────────────────

  void setMadhab(String madhab) =>
      state = state.copyWith(madhab: madhab);

  // ── Assets ────────────────────────────────────────────────────────────────

  void setGoldWeight(double grams) =>
      state = state.copyWith(goldWeightGrams: grams);

  void setSilverWeight(double grams) =>
      state = state.copyWith(silverWeightGrams: grams);

  void setCashBank(double amount) =>
      state = state.copyWith(cashBank: amount);

  void setCashInHand(double amount) =>
      state = state.copyWith(cashInHand: amount);

  void addJewelleryItem(JewelleryItem item) =>
      state = state.copyWith(jewelleryItems: [...state.jewelleryItems, item]);

  void updateJewelleryItem(JewelleryItem updated) {
    final items = state.jewelleryItems
        .map((i) => i.id == updated.id ? updated : i)
        .toList();
    state = state.copyWith(jewelleryItems: items);
  }

  void removeJewelleryItem(String id) {
    final items = state.jewelleryItems.where((i) => i.id != id).toList();
    state = state.copyWith(jewelleryItems: items);
  }

  // ── Liabilities ───────────────────────────────────────────────────────────

  void setDebtsOwed(double amount) =>
      state = state.copyWith(debtsOwed: amount);

  void setDebtsReceivable(double amount) =>
      state = state.copyWith(debtsReceivable: amount);

  void setLargeLiabilitiesMonthly(double amount) =>
      state = state.copyWith(largeLiabilitiesMonthly: amount);

  void setUnpaidPreviousZakat(double amount) =>
      state = state.copyWith(unpaidPreviousZakat: amount);

  // ── Results ───────────────────────────────────────────────────────────────

  void setResults({
    required double totalZakatableWealth,
    required double zakatDue,
    required bool metNisab,
    required String nisabUsed,
    required Map<String, double> breakdown,
  }) {
    state = state.copyWith(
      totalZakatableWealth: totalZakatableWealth,
      zakatDue: zakatDue,
      metNisab: metNisab,
      nisabUsed: nisabUsed,
      breakdown: breakdown,
    );
  }

  /// Resets calculation inputs while keeping currency & weight unit prefs.
  void reset() => state = state.resetCalculation();
}

final zakatProvider =
    NotifierProvider<ZakatNotifier, ZakatCalculationState>(ZakatNotifier.new);
