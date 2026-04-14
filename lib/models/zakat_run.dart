import 'package:hive/hive.dart';
import '../core/utils/zakat_calculator.dart';
import 'zakat_calculation_state.dart';
import 'jewellery_item.dart';

part 'zakat_run.g.dart';

@HiveType(typeId: 0)
class ZakatRun extends HiveObject {
  @HiveField(0)  String id;
  @HiveField(1)  String label;
  @HiveField(2)  DateTime createdAt;
  @HiveField(3)  String madhab;
  @HiveField(4)  double goldPriceUsed;
  @HiveField(5)  double silverPriceUsed;
  @HiveField(6)  double goldNisabThreshold;
  @HiveField(7)  bool metNisab;
  @HiveField(8)  double totalZakatableWealth;
  @HiveField(9)  double zakatDue;
  @HiveField(10) Map<String, double> breakdown;
  @HiveField(11) double goldWeightGrams;
  @HiveField(12) double silverWeightGrams;
  @HiveField(13) double cashBank;
  @HiveField(14) double cashInHand;
  @HiveField(15) double debtsOwed;
  @HiveField(16) double debtsReceivable;
  @HiveField(17) double largeLiabilitiesMonthly;
  @HiveField(18) double unpaidPreviousZakat;
  @HiveField(19) List<JewelleryItem> jewelleryItems;
  @HiveField(20) String currency;
  @HiveField(21) String currencySymbol;

  ZakatRun({
    required this.id,
    required this.label,
    required this.createdAt,
    required this.madhab,
    required this.goldPriceUsed,
    required this.silverPriceUsed,
    required this.goldNisabThreshold,
    required this.metNisab,
    required this.totalZakatableWealth,
    required this.zakatDue,
    required this.breakdown,
    required this.goldWeightGrams,
    required this.silverWeightGrams,
    required this.cashBank,
    required this.cashInHand,
    required this.debtsOwed,
    required this.debtsReceivable,
    required this.largeLiabilitiesMonthly,
    required this.unpaidPreviousZakat,
    required this.jewelleryItems,
    required this.currency,
    required this.currencySymbol,
  });

  factory ZakatRun.fromState(ZakatCalculationState state, String id) {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final label =
        '${now.year}-$month-${day}_$hour-${minute}_${state.madhab ?? 'unknown'}';

    return ZakatRun(
      id: id,
      label: label,
      createdAt: now,
      madhab: state.madhab ?? 'unknown',
      goldPriceUsed: state.goldPricePerOz,
      silverPriceUsed: state.silverPricePerOz,
      goldNisabThreshold: ZakatCalculator.goldNisabThreshold(state),
      metNisab: state.metNisab,
      totalZakatableWealth: state.totalZakatableWealth,
      zakatDue: state.zakatDue,
      breakdown: state.breakdown,
      goldWeightGrams: state.goldWeightGrams,
      silverWeightGrams: state.silverWeightGrams,
      cashBank: state.cashBank,
      cashInHand: state.cashInHand,
      debtsOwed: state.debtsOwed,
      debtsReceivable: state.debtsReceivable,
      largeLiabilitiesMonthly: state.largeLiabilitiesMonthly,
      unpaidPreviousZakat: state.unpaidPreviousZakat,
      jewelleryItems: state.jewelleryItems,
      currency: state.currency,
      currencySymbol: state.currencySymbol,
    );
  }
}
