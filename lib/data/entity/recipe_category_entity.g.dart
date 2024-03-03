// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_category_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeCategoryAdapter extends TypeAdapter<RecipeCategory> {
  @override
  final int typeId = 2;

  @override
  RecipeCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeCategory(
      name: fields[0] as String,
      base64Image: fields[1] as String,
      recipes: (fields[2] as List).cast<Recipe>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecipeCategory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.base64Image)
      ..writeByte(2)
      ..write(obj.recipes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
