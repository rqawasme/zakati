import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/zakat_calculation_state.dart';
import '../models/jewellery_item.dart';

class ZakatNotifier extends StateNotifier<ZakatCalculationState> {
  ZakatNotifier() : super(const ZakatCalculationState());

  void setMadhab(String madhab) =>
      state = state.copyWith(madhab: madhab);

  void setHaulCompleted(bool completed) =>
      state = state.copyWith(haulCompleted: completed);

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

  void setDebtsOwed(double amount) =>
      state = state.copyWith(debtsOwed: amount);

  void setDebtsReceivable(double amount) =>
      state = state.copyWith(debtsReceivable: amount);

  void setLargeLiabilitiesMonthly(double amount) =>
      state = state.copyWith(largeLiabilitiesMonthly: amount);

  void setUnpaidPreviousZakat(double amount) =>
      state = state.copyWith(unpaidPreviousZakat: amount);

  void setResults({
    required double totalZakatableWealth,
    required double zakatDue,
    required bool metNisab,
    required Map<String, double> breakdown,
  }) {
    state = state.copyWith(
      totalZakatableWealth: totalZakatableWealth,
      zakatDue: zakatDue,
      metNisab: metNisab,
      breakdown: breakdown,
    );
  }

  void reset() => state = const ZakatCalculationState();
}

final zakatProvider =
    StateNotifierProvider<ZakatNotifier, ZakatCalculationState>(
  (ref) => ZakatNotifier(),
);
