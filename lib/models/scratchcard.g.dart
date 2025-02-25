// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scratchcard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScratchcardModelAdapter extends TypeAdapter<ScratchcardModel> {
  @override
  final int typeId = 1;

  @override
  ScratchcardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScratchcardModel(
      id: fields[0] as String,
      name: fields[1] as String,
      rewardId: fields[2] as String,
      date: fields[3] as String,
      isWon: fields[4] as bool,
      isScratched: fields[5] as bool,
      imagePath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ScratchcardModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.rewardId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.isWon)
      ..writeByte(5)
      ..write(obj.isScratched)
      ..writeByte(6)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScratchcardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
