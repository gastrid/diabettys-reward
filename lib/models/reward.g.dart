// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardModelAdapter extends TypeAdapter<RewardModel> {
  @override
  final int typeId = 0;

  @override
  RewardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardModel(
      id: fields[0] as String,
      name: fields[1] as String,
      winProbability: fields[2] as double,
      exclusions: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RewardModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.winProbability)
      ..writeByte(3)
      ..write(obj.exclusions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
