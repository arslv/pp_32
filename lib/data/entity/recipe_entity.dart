import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'recipe_entity.g.dart';

@HiveType(typeId: 1)
class Recipe extends HiveObject {
  @HiveField(0)
  late final String name;
  @HiveField(1)
  late final String description;
  @HiveField(2)
  late final String ingredients;
  @HiveField(3)
  late final int fat;
  @HiveField(4)
  late final int pro;
  @HiveField(5)
  late final int carb;
  @HiveField(6)
  late final String base64Image;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.fat,
    required this.pro,
    required this.carb,
    required this.base64Image,
  });

  double calculateCalories() {
    double caloriesFromFat = fat * 9;
    double caloriesFromProtein = pro * 4;
    double caloriesFromCarbs = carb * 4;

    double totalCalories = caloriesFromFat + caloriesFromProtein + caloriesFromCarbs;

    return totalCalories;
  }
}
