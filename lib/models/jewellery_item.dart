import 'package:hive/hive.dart';

part 'jewellery_item.g.dart';

@HiveType(typeId: 1)
class JewelleryItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String label;

  @HiveField(2)
  String material; // 'gold' or 'silver'

  @HiveField(3)
  double weightGrams;

  @HiveField(4)
  double purityPercent; // e.g. 75.0 for 18k gold

  @HiveField(5)
  String purpose; // 'beautification' or 'investment'

  JewelleryItem({
    required this.id,
    required this.label,
    required this.material,
    required this.weightGrams,
    required this.purityPercent,
    required this.purpose,
  });

  JewelleryItem copyWith({
    String? id,
    String? label,
    String? material,
    double? weightGrams,
    double? purityPercent,
    String? purpose,
  }) {
    return JewelleryItem(
      id: id ?? this.id,
      label: label ?? this.label,
      material: material ?? this.material,
      weightGrams: weightGrams ?? this.weightGrams,
      purityPercent: purityPercent ?? this.purityPercent,
      purpose: purpose ?? this.purpose,
    );
  }
}
