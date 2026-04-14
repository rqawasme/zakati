// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zakat_run.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZakatRunAdapter extends TypeAdapter<ZakatRun> {
  @override
  final int typeId = 0;

  @override
  ZakatRun read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZakatRun(
      id: fields[0] as String,
      label: fields[1] as String,
      createdAt: fields[2] as DateTime,
      madhab: fields[3] as String,
      goldPriceUsed: fields[4] as double,
      silverPriceUsed: fields[5] as double,
      goldNisabThreshold: fields[6] as double,
      metNisab: fields[7] as bool,
      totalZakatableWealth: fields[8] as double,
      zakatDue: fields[9] as double,
      breakdown: (fields[10] as Map).cast<String, double>(),
      goldWeightGrams: fields[11] as double,
      silverWeightGrams: fields[12] as double,
      cashBank: fields[13] as double,
      cashInHand: fields[14] as double,
      debtsOwed: fields[15] as double,
      debtsReceivable: fields[16] as double,
      largeLiabilitiesMonthly: fields[17] as double,
      unpaidPreviousZakat: fields[18] as double,
      jewelleryItems: (fields[19] as List).cast<JewelleryItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ZakatRun obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.madhab)
      ..writeByte(4)
      ..write(obj.goldPriceUsed)
      ..writeByte(5)
      ..write(obj.silverPriceUsed)
      ..writeByte(6)
      ..write(obj.goldNisabThreshold)
      ..writeByte(7)
      ..write(obj.metNisab)
      ..writeByte(8)
      ..write(obj.totalZakatableWealth)
      ..writeByte(9)
      ..write(obj.zakatDue)
      ..writeByte(10)
      ..write(obj.breakdown)
      ..writeByte(11)
      ..write(obj.goldWeightGrams)
      ..writeByte(12)
      ..write(obj.silverWeightGrams)
      ..writeByte(13)
      ..write(obj.cashBank)
      ..writeByte(14)
      ..write(obj.cashInHand)
      ..writeByte(15)
      ..write(obj.debtsOwed)
      ..writeByte(16)
      ..write(obj.debtsReceivable)
      ..writeByte(17)
      ..write(obj.largeLiabilitiesMonthly)
      ..writeByte(18)
      ..write(obj.unpaidPreviousZakat)
      ..writeByte(19)
      ..write(obj.jewelleryItems);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZakatRunAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
