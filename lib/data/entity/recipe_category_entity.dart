import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';

part 'recipe_category_entity.g.dart';

@HiveType(typeId: 2)
class RecipeCategory extends HiveObject {
  @HiveField(0)
  late final String name;
  @HiveField(1)
  late final String base64Image;
  @HiveField(2)
  late List<Recipe> recipes;

  RecipeCategory({required this.name, required this.base64Image, required this.recipes});
}