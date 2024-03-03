// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_menu_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeekMenuAdapter extends TypeAdapter<WeekMenu> {
  @override
  final int typeId = 0;

  @override
  WeekMenu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeekMenu(
      year: fields[0] as int,
      month: fields[1] as int,
      week: fields[2] as int,
      recipes: (fields[3] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as WeekDay, (v as List).cast<Recipe>())),
    );
  }

  @override
  void write(BinaryWriter writer, WeekMenu obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.week)
      ..writeByte(3)
      ..write(obj.recipes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekMenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
