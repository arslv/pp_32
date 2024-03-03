import 'package:hive/hive.dart';
import 'package:pp_32/business/helpers/enums/week_day_enum.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';

part 'day_menu_entity.g.dart';

@HiveType(typeId: 3)
class DayMenu extends HiveObject {
  @HiveField(0)
  late Map<WeekDay, List<Recipe>> recipes;

  DayMenu({required this.recipes});
}