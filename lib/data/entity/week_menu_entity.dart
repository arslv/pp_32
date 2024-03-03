import 'package:hive/hive.dart';
import 'package:pp_32/business/helpers/enums/week_day_enum.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';

part 'week_menu_entity.g.dart';

@HiveType(typeId: 0)
class WeekMenu extends HiveObject {
  @HiveField(0)
  late final int year;
  @HiveField(1)
  late final int month;
  @HiveField(2)
  late final int week;
  @HiveField(3)
  late Map<WeekDay, List<Recipe>> recipes;

  WeekMenu({required this.year,required this.month, required this.week, required this.recipes});
}