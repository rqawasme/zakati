import 'package:hive/hive.dart';
import 'zakat_calculation_state.dart';
import 'jewellery_item.dart';

part 'zakat_run.g.dart';

@HiveType(typeId: 0)
class ZakatRun extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String label; // e.g. "2025-04-01_14-32_maliki"

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String madhab;

  @HiveField(4)
  double goldPriceUsed;

  @HiveField(5)
  double silverPriceUsed;

  @HiveField(6)
  double goldNisabThreshold;

  @HiveField(7)
  bool metNisab;

  @HiveField(8)
  double totalZakatableWealth;

  @HiveField(9)
  double zakatDue;

  @HiveField(10)
  Map<String, double> breakdown;

  // Snapshot of full state fields for RunDetailScreen
  @HiveField(11)
  double goldWeightGrams;

  @HiveField(12)
  double silverWeightGrams;

  @HiveField(13)
  double cashBank;

  @HiveField(14)
  double cashInHand;

  @HiveField(15)
  double debtsOwed;

  @HiveField(16)
  double debtsReceivable;

  @HiveField(17)
  double largeLiabilitiesMonthly;

  @HiveField(18)
  double unpaidPreviousZakat;

  @HiveField(19)
  List<JewelleryItem> jewelleryItems;

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
  });

  factory ZakatRun.fromState(ZakatCalculationState state, String id) {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final label =
        '${now.year}-$month-${day}_$hour-$minute_${state.madhab ?? 'unknown'}';

    const troy = 31.1035;
    final goldPricePerGram = state.goldPricePerOz / troy;
    final goldNisab = goldPricePerGram * 85;

    return ZakatRun(
      id: id,
      label: label,
      createdAt: now,
      madhab: state.madhab ?? 'unknown',
      goldPriceUsed: state.goldPricePerOz,
      silverPriceUsed: state.silverPricePerOz,
      goldNisabThreshold: goldNisab,
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
    );
  }
}
