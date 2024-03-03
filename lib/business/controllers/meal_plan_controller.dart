import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_32/business/controllers/date_switcher_controller.dart';
import 'package:pp_32/business/helpers/enums/week_day_enum.dart';
import 'package:pp_32/data/entity/day_menu_entity.dart';
import 'package:pp_32/data/entity/recipe_category_entity.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';
import 'package:pp_32/data/entity/week_menu_entity.dart';
import 'package:pp_32/data/repository/database_service.dart';
import 'package:pp_32/presentation/pages/meal_plan_view.dart';

class MealPlanController extends ValueNotifier<MealPlanControllerState> {
  MealPlanController() : super(MealPlanControllerState.initial()) {
    initialize();
  }

  final dataBase = GetIt.instance.get<DatabaseService>();
  final dateSwitcherController = DateSwitchController();

  int get activeMonth => dateSwitcherController.activeMonth;

  int get activeWeek => dateSwitcherController.activeWeek;

  void initialize() {
    final weekMenu = dataBase.getWeekMenu(
      year: dateSwitcherController.activeYear,
      month: dateSwitcherController.activeMonth,
      week: dateSwitcherController.activeWeek,
    );
    final dayMenu = dataBase.dayMenu;
    final recipeCategories = dataBase.recipeCategories;
    value =
        value.copyWith(weekMenu: weekMenu, dayMenu: dayMenu, recipeCategories: recipeCategories);
    notifyListeners();
  }

  void addRecipeToWeekMenu({required Recipe recipe, required WeekDay weekDay}) {
    var menu = value.weekMenu;
    var editedMenu = menu;
    editedMenu.recipes[weekDay]!.add(recipe);
    dataBase.saveWeekMenu(oldMenu: menu, newMenu: editedMenu);
    initialize();
  }

  void removeRecipeFromWeekMenu({required Recipe recipe, required WeekDay weekDay}) {
    var menu = value.weekMenu;
    var editedMenu = menu;
    editedMenu.recipes[weekDay]!.remove(recipe);
    dataBase.saveWeekMenu(oldMenu: menu, newMenu: editedMenu);
    initialize();
  }

  void addRecipeToDayMenu({required Recipe recipe, required WeekDay weekDay}) {
    var menu = value.dayMenu;
    var editedMenu = menu;
    editedMenu.recipes[weekDay]!.add(recipe);
    dataBase.saveDayMenu(newMenu: editedMenu);
    initialize();
  }

  void removeRecipeFromDayMenu({required Recipe recipe, required WeekDay weekDay}) {
    var menu = value.dayMenu;
    var editedMenu = menu;
    editedMenu.recipes[weekDay]!.remove(recipe);
    dataBase.saveDayMenu(newMenu: editedMenu);
    initialize();
  }

  void createRecipeCategory({required RecipeCategory newRecipeCategory}) {
    dataBase.putRecipeCategory(newRecipeCategory.name, newRecipeCategory);
    initialize();
  }

  void deleteRecipeCategory({required RecipeCategory recipeCategory}) {
    dataBase.deleteRecipeCategory(recipeCategory.name);
    initialize();
  }

  void deleteRecipe({required RecipeCategory recipeCategory, required Recipe recipe}) {
    dataBase.deleteRecipe(recipeCategory.name, recipe);
    initialize();
  }

  void addRecipe({required RecipeCategory recipeCategory, required Recipe recipe}) {
    dataBase.addRecipe(recipeCategory.name, recipe);
    initialize();
  }

  void updateWeekMenu() {
    final weekMenu = dataBase.getWeekMenu(
      year: dateSwitcherController.activeYear,
      month: dateSwitcherController.activeMonth,
      week: dateSwitcherController.activeWeek,
    );
    value = value.copyWith(weekMenu: weekMenu);
    notifyListeners();
  }

  void updateDayMenu() {
    final dayMenu = dataBase.dayMenu;
    value = value.copyWith(dayMenu: dayMenu);
    notifyListeners();
  }

  void increaseWeek() {
    dateSwitcherController.increaseWeek();
    notifyListeners();
    updateWeekMenu();
  }

  void decreaseWeek() {
    dateSwitcherController.decreaseWeek();
    notifyListeners();
    updateWeekMenu();
  }

  void toggleTab(TabSegment tab) {
    value = value.copyWith(activeTab: tab);
    notifyListeners();
  }
}

class MealPlanControllerState {
  MealPlanControllerState({
    required this.dayMenu,
    required this.weekMenu,
    required this.recipeCategories,
    required this.activeTab,
  });

  final DayMenu dayMenu;
  final WeekMenu weekMenu;
  final List<RecipeCategory> recipeCategories;
  final TabSegment activeTab;

  factory MealPlanControllerState.initial() {
    return MealPlanControllerState(
      dayMenu: DayMenu(recipes: {}),
      weekMenu: WeekMenu(recipes: {}, month: 0, week: 0, year: 2024),
      recipeCategories: [],
      activeTab: TabSegment.day,
    );
  }

  MealPlanControllerState copyWith({
    DayMenu? dayMenu,
    WeekMenu? weekMenu,
    List<RecipeCategory>? recipeCategories,
    TabSegment? activeTab,
  }) {
    return MealPlanControllerState(
      dayMenu: dayMenu ?? this.dayMenu,
      weekMenu: weekMenu ?? this.weekMenu,
      recipeCategories: recipeCategories ?? this.recipeCategories,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}
