import 'dart:convert';
import 'dart:typed_data';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/controllers/meal_plan_controller.dart';
import 'package:pp_32/business/helpers/enums/week_day_enum.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';
import 'package:pp_32/data/entity/day_menu_entity.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';
import 'package:pp_32/data/entity/week_menu_entity.dart';
import 'package:pp_32/presentation/pages/meal_plan_view.dart';
import 'package:pp_32/presentation/pages/recipes_view.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget(
      {super.key,
      required this.weekMenu,
      required this.mealPlanController,
      required this.selectedSegment,
      required this.dayMenu});

  final WeekMenu weekMenu;
  final DayMenu dayMenu;
  final MealPlanController mealPlanController;
  final TabSegment selectedSegment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: weekMenu.recipes.length,
        itemBuilder: (context, index) {
          return WeekDayMenu(
            weekDay: weekMenu.recipes.keys.elementAt(index),
            recipes: selectedSegment == TabSegment.week
                ? weekMenu.recipes.values.elementAt(index)
                : dayMenu.recipes.values.elementAt(index),
            weekMenu: weekMenu,
            mealPlanController: mealPlanController,
            dayMenu: dayMenu,
            selectedSegment: selectedSegment,
          );
        },
      ),
    );
  }
}

class WeekDayMenu extends StatelessWidget {
  WeekDayMenu({
    super.key,
    required this.weekDay,
    required this.recipes,
    required this.weekMenu,
    required this.dayMenu,
    required this.selectedSegment,
    required this.mealPlanController,
  });

  final WeekMenu weekMenu;
  final DayMenu dayMenu;
  final TabSegment selectedSegment;
  final WeekDay weekDay;
  final List<Recipe> recipes;
  final ExpandableController controller = ExpandableController();
  final MealPlanController mealPlanController;

  void removeAction({required Recipe recipe, required WeekDay weekDay}) {
    if (selectedSegment == TabSegment.week) {
      mealPlanController.removeRecipeFromWeekMenu(recipe: recipe, weekDay: weekDay);
    } else {
      mealPlanController.removeRecipeFromDayMenu(recipe: recipe, weekDay: weekDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    var totalCalories = 0.0;
    for (var recipe in recipes) {
      totalCalories += recipe.calculateCalories();
    }

    return ExpandableTheme(
      data: const ExpandableThemeData(
          iconColor: Colors.black, animationDuration: Duration(milliseconds: 200)),
      child: ExpandableNotifier(
        controller: controller,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(iconColor: Colors.blue),
          collapsed: Container(
            padding: const EdgeInsets.only(top: 7, bottom: 7),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
            )),
            width: double.infinity,
            child: Row(
              children: [
                Text(weekDay.name, style: Theme.of(context).textTheme.displaySmall),
                const Spacer(),
                CupertinoButton(
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.recipes,
                      arguments: RecipesViewArguments(
                          weekDay: weekDay,
                          weekMenu: weekMenu,
                          mealPlanController: mealPlanController)),
                  padding: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(39),
                        border: Border.all(color: Theme.of(context).colorScheme.primary)),
                    child: Text(
                      'Add',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                )
              ],
            ),
          ),
          expanded: Container(
            padding: const EdgeInsets.only(top: 7, bottom: 7),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(weekDay.name, style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(width: 8),
                    Text(
                      '${totalCalories.round().toString()} calories',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pushNamed(RouteNames.recipes,
                          arguments: RecipesViewArguments(
                              weekDay: weekDay,
                              weekMenu: weekMenu,
                              mealPlanController: mealPlanController)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(39),
                            border: Border.all(color: Theme.of(context).colorScheme.primary)),
                        child: Text(
                          'Add',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    )
                  ],
                ),
                recipes.isNotEmpty
                    ? SizedBox(
                        height: 141,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            ...recipes.map((e) => Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: RecipeContainer(
                                    recipe: e,
                                    removeAction: () => removeAction(recipe: e, weekDay: weekDay),
                                  ),
                                ))
                          ],
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Text(
                          'There are no added dishes',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                        ),
                      )
              ],
            ),
          ),
          builder: (_, collapsed, expanded) {
            return GestureDetector(
              onTap: () => controller.toggle(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RecipeContainer extends StatelessWidget {
  const RecipeContainer({super.key, required this.recipe, required this.removeAction});

  final Recipe recipe;
  final VoidCallback removeAction;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(recipe.base64Image);
    var photo = Image.memory(bytes);
    return CupertinoButton(
      onPressed: () => Navigator.of(context).pushNamed(RouteNames.recipe, arguments: recipe),
      padding: EdgeInsets.zero,
      child: Container(
        width: 126,
        height: 142,
        padding: const EdgeInsets.only(bottom: 11, left: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: photo.image, fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: removeAction,
                child: ImageHelper.svgImage(SvgNames.exit),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4.4,
                  child: Text(
                    recipe.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                ImageHelper.svgImage(SvgNames.arrowRight,
                    color: Theme.of(context).colorScheme.onPrimary)
              ],
            )
          ],
        ),
      ),
    );
  }
}
