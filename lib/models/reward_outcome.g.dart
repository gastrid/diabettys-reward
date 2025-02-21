// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_outcome.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardOutcomeModelAdapter extends TypeAdapter<RewardOutcomeModel> {
  @override
  final int typeId = 1;

  @override
  RewardOutcomeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardOutcomeModel(
      rewardName: fields[0] as String,
      won: fields[1] as bool,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RewardOutcomeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rewardName)
      ..writeByte(1)
      ..write(obj.won)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardOutcomeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
