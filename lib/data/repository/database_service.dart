import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pp_32/business/helpers/enums/week_day_enum.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/data/entity/day_menu_entity.dart';
import 'package:pp_32/data/entity/image_adapter.dart';
import 'package:pp_32/data/entity/recipe_category_entity.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';
import 'package:pp_32/data/entity/week_menu_entity.dart';

class DatabaseService {
  late final Box<dynamic> _common;
  late final Box<RecipeCategory> _recipeCategories;
  late final Box<WeekMenu> _weekMenus;
  late final Box<DayMenu> _dayMenu;

  Future<DatabaseService> init() async {
    await Hive.initFlutter();
    final appDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDirectory.path);

    Hive.registerAdapter(WeekDayAdapter());
    Hive.registerAdapter(DayMenuAdapter());
    Hive.registerAdapter(WeekMenuAdapter());
    Hive.registerAdapter(RecipeAdapter());
    Hive.registerAdapter(RecipeCategoryAdapter());
    Hive.registerAdapter(ImageAdapter());

    _recipeCategories = await Hive.openBox('_recipeCategories');
    _weekMenus = await Hive.openBox('_weekMenus');
    _dayMenu = await Hive.openBox('_dayMenu');
    _common = await Hive.openBox('_common');

    _setupWeekMenus();
    _setupDayMenu();
    setupRecipes();

    return this;
  }

  void _setupDayMenu() {
    if (_dayMenu.isEmpty) {
      _dayMenu.add(DayMenu(recipes: {
        WeekDay.monday: [],
        WeekDay.tuesday: [],
        WeekDay.wednesday: [],
        WeekDay.thursday: [],
        WeekDay.friday: [],
        WeekDay.saturday: [],
        WeekDay.sunday: [],
      }));
    }
  }

  void _setupWeekMenus() {
    if (_weekMenus.isEmpty) {
      for (var year = 2023; year < 2025; year++) {
        for (var month = 1; month <= 12; month++) {
          for (var week = 1; week <= 4; week++) {
            _weekMenus.add(WeekMenu(year: year, month: month, week: week, recipes: {
              WeekDay.monday: [],
              WeekDay.tuesday: [],
              WeekDay.wednesday: [],
              WeekDay.thursday: [],
              WeekDay.friday: [],
              WeekDay.saturday: [],
              WeekDay.sunday: [],
            }));
          }
        }
      }
    }
  }

  Future<void> setupRecipes() async {
    var data = await rootBundle.load('assets/images/${ImageNames.ramen}.png');
    var bytes = data.buffer.asUint8List();
    var imageBytes = Uint8List.fromList(bytes);
    final ramen = base64Encode(imageBytes);

    data = await rootBundle.load('assets/images/${ImageNames.tomYum}.png');
    bytes = data.buffer.asUint8List();
    imageBytes = Uint8List.fromList(bytes);
    final tomYum = base64Encode(imageBytes);

    data = await rootBundle.load('assets/images/${ImageNames.pho}.png');
    bytes = data.buffer.asUint8List();
    imageBytes = Uint8List.fromList(bytes);
    final pho = base64Encode(imageBytes);

    data = await rootBundle.load('assets/images/${ImageNames.misoSoup}.png');
    bytes = data.buffer.asUint8List();
    imageBytes = Uint8List.fromList(bytes);
    final misoSoup = base64Encode(imageBytes);

    data = await rootBundle.load('assets/images/${ImageNames.kharcho}.png');
    bytes = data.buffer.asUint8List();
    imageBytes = Uint8List.fromList(bytes);
    final kharcho = base64Encode(imageBytes);


    if (_recipeCategories.isEmpty) {

      List<Recipe> firstRecipes = [
        Recipe(
          name: 'Ramen',
          description: '',
          ingredients:
              'Ramen is a Japanese dish based on a broth made from pork or chicken bones, with the addition of soy sauce and mirin. The broth is filled with wheat flour noodles, pieces of meat (usually pork or chicken), egg, nori seaweed, shrimp and vegetables.',
          fat: 10,
          pro: 15,
          carb: 40,
          base64Image: ramen,
        ),
        Recipe(
          name: 'Tom Yum',
          description: '',
          ingredients:
              'Tom Yum is a Thai spicy soup dish made from coconut milk, with the addition of lemongrass, mushrooms, lime, shrimp or chicken. This dish has a spicy taste with sour notes',
          fat: 15,
          pro: 10,
          carb: 30,
          base64Image: tomYum,
        ),
        Recipe(
          name: 'Pho',
          description: '',
          ingredients:
              'Pho is a Vietnamese soup made from beef or chicken broth with the addition of rice noodles, meat (beef or chicken), green onions, coriander and lime. It has a delicate taste and aroma',
          fat: 5,
          pro: 20,
          carb: 40,
          base64Image: pho,
        ),
        Recipe(
          name: 'Miso soup',
          description: '',
          ingredients:
              'Miso soup is a Japanese dish made from dasha (algae cultivated for food) and fermented soybean paste - miso. In addition, tofu, wakame seaweed and green onions are added to the soup.',
          fat: 5,
          pro: 20,
          carb: 40,
          base64Image: misoSoup,
        ),
      ];

      ByteData data = await rootBundle.load('assets/images/${ImageNames.first}.png');
      List<int> bytes = data.buffer.asUint8List();
      var imageBytes = Uint8List.fromList(bytes);
      var base64Image = base64Encode(imageBytes);

      RecipeCategory firstCategory = RecipeCategory(
        name: 'First meals',
        base64Image: base64Image,
        recipes: firstRecipes,
      );

      putRecipeCategory('First', firstCategory);

      data = await rootBundle.load('assets/images/${ImageNames.pekingDuck}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final pekingDuck = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.tandoori}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final tandoori = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.kimchi}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final kimchi = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.padThai}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final padThai = base64Encode(imageBytes);

      List<Recipe> secondRecipes = [
        Recipe(
          name: 'Peking Duck',
          description: '',
          ingredients:
              'Peking duck is a traditional Chinese dish made from duck that is baked in a special oven until crispy. Served with crispy vegetables and seasoned with hoisin sauce.',
          fat: 20,
          pro: 15,
          carb: 5,
          base64Image: pekingDuck,
        ),
        Recipe(
          name: 'Tandoori',
          description: '',
          ingredients:
              'Tandoori is an Indian dish consisting of marinated meat (usually chicken or lamb) baked in a tandoor - a special clay oven. The meat is usually marinated in yogurt with various spices such as turmeric,cumin and cardamom',
          fat: 10,
          pro: 25,
          carb: 5,
          base64Image: tandoori,
        ),
        Recipe(
          name: 'Kimchi jjigae',
          description: '',
          ingredients:
          'Kimchi jjigae is a Korean dish consisting of marinated pork meat stewed with kimchi (sauerkraut with chili peppers) and other vegetables such as onions, garlic and carrots. It has a spicy and rich taste.',
          fat: 15,
          pro: 20,
          carb: 10,
          base64Image: kimchi,
        ),
        Recipe(
          name: 'Pad Thai',
          description: '',
          ingredients:
          'Pad Thai is a Thai dish consisting of fried rice noodles with seafood or meat (usually chicken), beans, tamarind sauce, fried eggs, peanuts and vegetables. This dish has a sweet, spicy and sour taste',
          fat: 10,
          pro: 15,
          carb: 30,
          base64Image: padThai,
        ),
      ];

      data = await rootBundle.load('assets/images/${ImageNames.second}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      base64Image = base64Encode(imageBytes);

      RecipeCategory secondCategory = RecipeCategory(
        name: 'Second',
        base64Image: base64Image,
        recipes: secondRecipes,
      );

      putRecipeCategory('Second meals', secondCategory);

      data = await rootBundle.load('assets/images/${ImageNames.seafoodSalad}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final seafoodSalad = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.greenMangoSalad}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final greenMangoSalad = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.chickenBreastSalad}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final chickenBreastSalad = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.seaweedSalad}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final seaweedSalad = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.ricePetalSalad}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final ricePetalSalad = base64Encode(imageBytes);

      List<Recipe> dishes1Recipes = [
        Recipe(
          name: 'Seafood Salad',
          description: '',
          ingredients:
              'Seafood salad is a Japanese salad consisting of pieces of fresh seafood such as squid, shrimp, and mussels mixed with crispy vegetables and seasoned with rice vinegar and soy sauce.',
          fat: 10,
          pro: 20,
          carb: 15,
          base64Image: seafoodSalad,
        ),
        Recipe(
          name: 'Green Mango Salad',
          description: '',
          ingredients:
              'Green Mango Salad - This Thai salad is made from thin chopped unripe mango mixed with nuts, shrimp, tomatoes, cucumber and herbs. Dressed with a sauce based on lemon juice, fish sauce and chili',
          fat: 10,
          pro: 15,
          carb: 20,
          base64Image: greenMangoSalad,
        ),
        Recipe(
          name: 'Chicken breast salad',
          description: '',
          ingredients:
          'Chicken breast salad is a Chinese salad consisting of boiled chicken breast, cut into thin slices, mixed with vegetables (paprika, carrots, fresh onions) and seasoned with a sauce based on ginger, garlic and soy sauce',
          fat: 10,
          pro: 25,
          carb: 10,
          base64Image: chickenBreastSalad,
        ),
        Recipe(
          name: 'Seaweed Salad',
          description: '',
          ingredients:
          'Seaweed Salad - This Japanese salad is made with seaweed (wakame) mixed with cucumber, radish and sesame seeds, dressed in a rice vinegar and soy sauce based dressing',
          fat: 3,
          pro: 5,
          carb: 15,
          base64Image: seaweedSalad,
        ),
        Recipe(
          name: 'Rice petal salad',
          description: '',
          ingredients:
          'Rice petal salad is a Korean salad consisting of boiled rice mixed with chopped vegetables (cucumbers, carrots, onions) and dressed with a sauce based on sesame oil, vinegar and sugar',
          fat: 5,
          pro: 10,
          carb: 30,
          base64Image: ricePetalSalad,
        ),
      ];

      data = await rootBundle.load('assets/images/${ImageNames.salads}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      base64Image = base64Encode(imageBytes);

      RecipeCategory dishes1Category = RecipeCategory(
        name: 'Salads',
        base64Image: base64Image,
        recipes: dishes1Recipes,
      );

      putRecipeCategory('Salads', dishes1Category);

      data = await rootBundle.load('assets/images/${ImageNames.mochi}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final mochi = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.mangoStickyRice}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final mangoStickyRice = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.fruitSaladWithIceCream}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final fruitSaladWithIceCream = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.lokum}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final lokum = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.greenTeaIceCream}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final greenTeaIceCream = base64Encode(imageBytes);

      List<Recipe> dishes2Recipes = [
        Recipe(
          name: 'Fruit Salad with Thai Ice Cream',
          description: '',
          ingredients:
              'Fruit salad with Thai ice cream is a dessert consisting of fresh fruits (pineapple, mango, melon) with the addition of Thai ice cream, which is prepared from condensed milk, coconut milk and coconut water. This dessert is refreshing and popular in Thailand.',
          fat: 7,
          pro: 2,
          carb: 25,
          base64Image: fruitSaladWithIceCream,
        ),
        Recipe(
          name: 'Mochi',
          description: '',
          ingredients:
              'Mochi is a traditional Japanese dessert consisting of sweet glutinous rice that is formed into various shapes, such as balls or pieces, and sprinkled with starch or coconut. Historically, mochi were prepared for tea ceremonies.',
          fat: 1,
          pro: 3,
          carb: 30,
          base64Image: mochi,
        ),
        Recipe(
          name: 'Thai Mango Sticky Rice',
          description: '',
          ingredients:
          'Thai Mango Sticky Rice is a dessert consisting of sweet sticky rice served with chopped ripe mango and doused with coconut milk. This dessert is popular in Thailand and other Southeast Asian countries.',
          fat: 5,
          pro: 2,
          carb: 40,
          base64Image: mangoStickyRice,
        ),
        Recipe(
          name: 'Lokum',
          description: '',
          ingredients:
          'Lokum is a traditional Turkish dessert consisting of a gelled mass of sugar, starch and fruit juice (such as rose water or lemon), sprinkled with coconut or nuts. Turkish delight has a rich history and is often served during the holidays.',
          fat: 2,
          pro: 1,
          carb: 20,
          base64Image: lokum,
        ),
        Recipe(
          name: 'Green tea ice cream',
          description: '',
          ingredients:
          'Green tea ice cream is a Japanese dessert made from green tea (matcha), milk and sugar. It has a rich green tea flavor and is often served as ice cream or soft serve ice cream.',
          fat: 10,
          pro: 3,
          carb: 25,
          base64Image: greenTeaIceCream,
        ),
      ];

      data = await rootBundle.load('assets/images/${ImageNames.deserts}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      base64Image = base64Encode(imageBytes);

      RecipeCategory dishes2Category = RecipeCategory(
        name: 'Deserts',
        base64Image: base64Image,
        recipes: dishes2Recipes,
      );

      putRecipeCategory('Dishes 2', dishes2Category);

      data = await rootBundle.load('assets/images/${ImageNames.matchaTea}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final matchaTea = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.beanTea}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final beanTea = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.bananaMilk}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final bananaMilk = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.elderberryTea}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final elderberryTea = base64Encode(imageBytes);

      data = await rootBundle.load('assets/images/${ImageNames.masala}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      final masala = base64Encode(imageBytes);

      List<Recipe> beveragesRecipes = [
        Recipe(
          name: 'Matcha Tea',
          description: '',
          ingredients:
              'Matcha tea is Japanese green tea that has been ground into a powder. It has a rich taste and rich aroma. Matcha tea is used in the traditional Japanese tea ceremony.',
          fat: 1,
          pro: 3,
          carb: 25,
          base64Image: matchaTea,
        ),
        Recipe(
          name: 'Bean tea',
          description: '',
          ingredients:
          'Bean tea is a traditional Chinese drink made from roasted soybeans or mung beans. It has a delicate nutty taste and aroma. Bean tea is popular in China and other East Asian countries.',
          fat: 1,
          pro: 3,
          carb: 25,
          base64Image: beanTea,
        ),
        Recipe(
          name: 'Banana milk',
          description: '',
          ingredients:
          'Banana milk is a drink made from fresh bananas, milk and sugar. It has a sweet taste and creamy texture. Banana milk is popular in many Asian countries.',
          fat: 1,
          pro: 3,
          carb: 25,
          base64Image: bananaMilk,
        ),
        Recipe(
          name: 'Elderberry tea',
          description: '',
          ingredients:
          'Elderberry tea is a traditional Korean drink made from elderberry flowers, sugar and water. It has a refreshing taste and aroma of blooming flowers. Elderberry tea is often served during holidays and ceremonies.',
          fat: 1,
          pro: 3,
          carb: 25,
          base64Image: elderberryTea,
        ),
        Recipe(
          name: 'Masala chai',
          description: '',
          ingredients:
          'Masala chai is a traditional Indian tea made from black tea, spices (such as cinnamon, ginger, cardamom) and milk. It has a rich taste and aroma of spices. Masala tea is often served with sweets or snacks.',
          fat: 1,
          pro: 3,
          carb: 25,
          base64Image: masala,
        ),
      ];

      data = await rootBundle.load('assets/images/${ImageNames.drinks}.png');
      bytes = data.buffer.asUint8List();
      imageBytes = Uint8List.fromList(bytes);
      base64Image = base64Encode(imageBytes);

      RecipeCategory beveragesCategory = RecipeCategory(
        name: 'Drinks',
        base64Image: base64Image,
        recipes: beveragesRecipes,
      );

      putRecipeCategory('Beverages', beveragesCategory);
    }
  }

  WeekMenu getWeekMenu({required year, required month, required week}) {
    return _weekMenus.values.firstWhere(
        (element) => element.year == year && element.month == month && element.week == week);
  }

  void saveWeekMenu({required WeekMenu oldMenu, required WeekMenu newMenu}) {
    var selectedMenu = _weekMenus.values.firstWhere((element) => element == oldMenu);
    selectedMenu.recipes = newMenu.recipes;
    selectedMenu.save();
  }

  DayMenu get dayMenu => _dayMenu.values.elementAt(0);

  void saveDayMenu({required DayMenu newMenu}) {
    _dayMenu.deleteAt(0);
    _dayMenu.add(newMenu);
  }

  List<RecipeCategory> get recipeCategories => _recipeCategories.values.toList();

  void putRecipeCategory(String name, RecipeCategory category) =>
      _recipeCategories.put(name, category);

  RecipeCategory? getRecipeCategory(String name) => _recipeCategories.get(name);

  void deleteRecipeCategory(String name) => _recipeCategories.delete(name);

  void addRecipe(String recipeCategoryName, Recipe recipe) {
    var recipeCategory = getRecipeCategory(recipeCategoryName);
    recipeCategory!.recipes.add(recipe);
    recipeCategory.save();
  }

  void deleteRecipe(String recipeCategoryName, Recipe recipe) {
    var recipeCategory = getRecipeCategory(recipeCategoryName);
    recipeCategory!.recipes.remove(recipe);
    recipeCategory.save();
  }

  void put(String key, dynamic value) => _common.put(key, value);

  dynamic get(String key) => _common.get(key);
}
