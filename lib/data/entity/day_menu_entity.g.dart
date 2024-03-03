// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_menu_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayMenuAdapter extends TypeAdapter<DayMenu> {
  @override
  final int typeId = 3;

  @override
  DayMenu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayMenu(
      recipes: (fields[0] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as WeekDay, (v as List).cast<Recipe>())),
    );
  }

  @override
  void write(BinaryWriter writer, DayMenu obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.recipes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayMenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
