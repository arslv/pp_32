import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pp_32/business/controllers/meal_plan_controller.dart';
import 'package:pp_32/business/helpers/dialog_helper.dart';
import 'package:pp_32/business/helpers/enums/week_day_enum.dart';
import 'package:pp_32/business/helpers/extensions/string_extension.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/data/entity/recipe_category_entity.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';
import 'package:pp_32/data/entity/week_menu_entity.dart';
import 'package:pp_32/presentation/pages/meal_plan_view.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';
import 'package:pp_32/presentation/widgets/app_button.dart';
import 'package:pp_32/presentation/widgets/app_text_field.dart';

class RecipesViewArguments {
  RecipesViewArguments({required this.weekDay, required this.weekMenu, required this.mealPlanController});

  final WeekDay weekDay;
  final WeekMenu weekMenu;
  final MealPlanController mealPlanController;
}

class RecipesView extends StatefulWidget {
  const RecipesView({super.key, required this.weekDay, required this.weekMenu, required this.mealPlanController});

  final WeekDay weekDay;
  final WeekMenu weekMenu;
  final MealPlanController mealPlanController;

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  bool deleteMode = false;

  void toggleDeleteMode() => setState(() {
        deleteMode = !deleteMode;
      });

  void delete(RecipeCategory recipeCategory) {
    DialogHelper.showCustomDialog(
      context: context,
      title: 'Confirmation',
      content: 'Are you sure to delete ${recipeCategory.name} category?',
      submit: () {
        widget.mealPlanController.deleteRecipeCategory(recipeCategory: recipeCategory);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: widget.mealPlanController,
        builder: (BuildContext context, MealPlanControllerState state, Widget? child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).colorScheme.onPrimary,
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 13,
                        width: 9,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: ImageHelper.svgImage(SvgNames.arrowLeft, width: 7, height: 13),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text('Recipes', style: Theme.of(context).textTheme.bodyMedium),
                      const Spacer(),
                      CupertinoButton(
                          onPressed: toggleDeleteMode, child: ImageHelper.svgImage(SvgNames.delete))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.2,
                          children: [
                        ...state.recipeCategories.map((e) => RecipeCategoryWidget(
                              recipeCategory: e,
                              isDeleteMode: deleteMode,
                              deleteAction: () => delete(e),
                              weekDay: widget.weekDay,
                              mealPlanController: widget.mealPlanController,
                            )),
                        EmptyRecipeCategoryWidget(
                            popCallback: () => widget.mealPlanController.initialize()),
                      ]))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmptyRecipeCategoryWidget extends StatelessWidget {
  const EmptyRecipeCategoryWidget({super.key, required this.popCallback});

  final VoidCallback popCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.09),
              blurRadius: 45.9,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add a new topic',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
          ),
          const SizedBox(height: 18),
          AppButton(
            name: 'Add',
            callback: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddRecipeCategoryView(popCallback: popCallback)),
            ),
            textColor: Theme.of(context).colorScheme.onPrimary,
            width: 91,
            height: 31,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          )
        ],
      ),
    );
  }
}

class RecipeCategoryWidget extends StatelessWidget {
  const RecipeCategoryWidget({
    super.key,
    required this.recipeCategory,
    required this.isDeleteMode,
    required this.deleteAction,
    required this.weekDay,
    required this.mealPlanController,
  });

  final RecipeCategory recipeCategory;
  final bool isDeleteMode;
  final VoidCallback deleteAction;
  final WeekDay weekDay;
  final MealPlanController mealPlanController;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(recipeCategory.base64Image);
    Image image = Image.memory(bytes);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeCategoryView(
                  recipeCategory: recipeCategory,
                  weekDay: weekDay,
                  mealPlanController: mealPlanController,
                )),
      ),
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: image.image,
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              recipeCategory.name.capitalize,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
        isDeleteMode
            ? Align(
                alignment: Alignment.topRight,
                child: Transform.translate(
                  offset: const Offset(20, -20),
                  child: CupertinoButton(
                    onPressed: deleteAction,
                    padding: EdgeInsets.zero,
                    child: ImageHelper.svgImage(SvgNames.exit),
                  ),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}

class AddRecipeCategoryView extends StatefulWidget {
  const AddRecipeCategoryView({super.key, required this.popCallback});

  final VoidCallback popCallback;

  @override
  State<AddRecipeCategoryView> createState() => _AddRecipeCategoryViewState();
}

class _AddRecipeCategoryViewState extends State<AddRecipeCategoryView> {
  final mealPlanController = MealPlanController();

  final nameController = TextEditingController();

  final descController = TextEditingController();

  bool saveButtonState = false;

  final ImagePicker _picker = ImagePicker();

  Image? selectedPhoto;
  String? base64Image;

  @override
  void initState() {
    super.initState();
    nameController.addListener(updateSaveButtonState);
    descController.addListener(updateSaveButtonState);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  void updateSaveButtonState() {
    setState(() {
      saveButtonState =
          nameController.text.isNotEmpty && descController.text.isNotEmpty && base64Image != null;
    });
  }

  void save() {
    mealPlanController.createRecipeCategory(
        newRecipeCategory:
            RecipeCategory(name: nameController.text, base64Image: base64Image ?? '', recipes: []));
    Navigator.of(context).pop();
  }

  Future<void> takeAndSavePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      DialogHelper.showErrorDialog(context, 'Something going wrong, please try again.');
      return;
    }

    Uint8List imageBytes = await pickedFile.readAsBytes();
    base64Image = base64Encode(imageBytes);

    setState(() {
      Uint8List bytes = base64Decode(base64Image!);
      selectedPhoto = Image.memory(bytes);
    });
    updateSaveButtonState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        widget.popCallback.call();
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 13,
                      width: 9,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: ImageHelper.svgImage(SvgNames.arrowLeft, width: 7, height: 13),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                        onPressed: saveButtonState ? () => save() : null,
                        child: Text(
                          'Save',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: saveButtonState
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onBackground),
                        ))
                  ],
                ),
                const SizedBox(height: 15),
                Text('Name of recipe', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 7),
                AppTextFieldWidget(
                  controller: nameController,
                  placeholder: 'Write the name of the recipe',
                  maxLength: 32,
                ),
                const SizedBox(height: 20),
                Text('Description', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 7),
                AppTextFieldWidget(
                  controller: descController,
                  placeholder: 'Write description',
                  maxLength: 128,
                ),
                const SizedBox(height: 30),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: takeAndSavePhoto,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 17, bottom: 34),
                    decoration: selectedPhoto == null
                        ? BoxDecoration(
                            color: Theme.of(context).extension<CustomColors>()!.grey,
                            borderRadius: BorderRadius.circular(9))
                        : BoxDecoration(
                            image: DecorationImage(image: selectedPhoto!.image, fit: BoxFit.cover),
                          ),
                    child: Column(
                      children: [
                        ImageHelper.svgImage(SvgNames.camera),
                        const SizedBox(height: 13),
                        Text(
                          'Upload photo',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecipeCategoryView extends StatefulWidget {
  const RecipeCategoryView({
    super.key,
    required this.recipeCategory,
    required this.weekDay,
    required this.mealPlanController,
  });

  final RecipeCategory recipeCategory;
  final WeekDay weekDay;
  final MealPlanController mealPlanController;

  @override
  State<RecipeCategoryView> createState() => _RecipeCategoryViewState();
}

class _RecipeCategoryViewState extends State<RecipeCategoryView> {
  bool deleteMode = false;

  void toggleDeleteMode() => setState(() {
        deleteMode = !deleteMode;
      });

  void delete({required Recipe recipe}) {
    widget.mealPlanController.deleteRecipe(recipeCategory: widget.recipeCategory, recipe: recipe);
    setState(() {
      widget.recipeCategory.recipes.remove(recipe);
    });
  }

  void select(Recipe recipe) {
    if (widget.mealPlanController.value.activeTab == TabSegment.week) {
      widget.mealPlanController.addRecipeToWeekMenu(recipe: recipe, weekDay: widget.weekDay);
    } else {
      widget.mealPlanController.addRecipeToDayMenu(recipe: recipe, weekDay: widget.weekDay);
    }
    Navigator.of(context).popUntil((route) => route.settings.name == '/main');
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        color: Theme.of(context).colorScheme.onPrimary,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 13,
                    width: 9,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: ImageHelper.svgImage(SvgNames.arrowLeft, width: 7, height: 13),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(widget.recipeCategory.name.capitalize,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  CupertinoButton(
                      onPressed: toggleDeleteMode, child: ImageHelper.svgImage(SvgNames.delete))
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.2,
                      children: [
                    ...widget.recipeCategory.recipes.map((e) => RecipeWidget(
                          recipe: e,
                          isDeleteMode: deleteMode,
                          deleteAction: () => delete(recipe: e),
                          selectAction: () => select(e),
                        )),
                    EmptyRecipeWidget(
                      popCallback: () {
                        setState(() {});
                      },
                      recipeCategory: widget.recipeCategory,
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeWidget extends StatelessWidget {
  const RecipeWidget({
    super.key,
    required this.recipe,
    required this.isDeleteMode,
    required this.deleteAction,
    required this.selectAction,
  });

  final Recipe recipe;
  final bool isDeleteMode;
  final VoidCallback deleteAction;
  final VoidCallback selectAction;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(recipe.base64Image);
    Image image = Image.memory(bytes);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: selectAction.call,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: image.image,
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              recipe.name.capitalize,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
        isDeleteMode
            ? Align(
                alignment: Alignment.topRight,
                child: Transform.translate(
                  offset: const Offset(20, -20),
                  child: CupertinoButton(
                    onPressed: deleteAction,
                    padding: EdgeInsets.zero,
                    child: ImageHelper.svgImage(SvgNames.exit),
                  ),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}

class EmptyRecipeWidget extends StatelessWidget {
  const EmptyRecipeWidget({super.key, required this.popCallback, required this.recipeCategory});

  final VoidCallback popCallback;
  final RecipeCategory recipeCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onPrimary,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.09),
              blurRadius: 45.9,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add new dishes',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
          ),
          const SizedBox(height: 18),
          AppButton(
            name: 'Add',
            callback: () async {
              var args = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddRecipeView(recipeCategory: recipeCategory)),
              );
              args != null ? popCallback.call() : null;
            },
            textColor: Theme.of(context).colorScheme.onPrimary,
            width: 91,
            height: 31,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          )
        ],
      ),
    );
  }
}

class AddRecipeView extends StatefulWidget {
  const AddRecipeView({super.key, required this.recipeCategory});

  final RecipeCategory recipeCategory;

  @override
  State<AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<AddRecipeView> {
  final mealPlanController = MealPlanController();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final ingController = TextEditingController();
  final fatController = TextEditingController();
  final proController = TextEditingController();
  final carbController = TextEditingController();

  bool saveButtonState = false;

  final ImagePicker _picker = ImagePicker();

  Image? selectedPhoto;
  String? base64Image;

  @override
  void initState() {
    super.initState();
    nameController.addListener(updateSaveButtonState);
    descController.addListener(updateSaveButtonState);
    ingController.addListener(updateSaveButtonState);
    fatController.addListener(updateSaveButtonState);
    proController.addListener(updateSaveButtonState);
    carbController.addListener(updateSaveButtonState);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    ingController.dispose();
    fatController.dispose();
    proController.dispose();
    carbController.dispose();
    super.dispose();
  }

  void updateSaveButtonState() {
    setState(() {
      saveButtonState = nameController.text.isNotEmpty &&
          descController.text.isNotEmpty &&
          ingController.text.isNotEmpty &&
          fatController.text.isNotEmpty &&
          proController.text.isNotEmpty &&
          carbController.text.isNotEmpty &&
          base64Image != null;
    });
  }

  void save() {
    final newRecipe = Recipe(
      name: nameController.text,
      description: descController.text,
      ingredients: ingController.text,
      fat: int.parse(fatController.text),
      pro: int.parse(proController.text),
      carb: int.parse(carbController.text),
      base64Image: base64Image ?? '',
    );

    mealPlanController.addRecipe(
      recipeCategory: widget.recipeCategory,
      recipe: newRecipe,
    );
    Navigator.of(context).pop(newRecipe);
  }

  Future<void> takeAndSavePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      DialogHelper.showErrorDialog(context, 'Something going wrong, please try again.');
      return;
    }

    Uint8List imageBytes = await pickedFile.readAsBytes();
    base64Image = base64Encode(imageBytes);

    setState(() {
      Uint8List bytes = base64Decode(base64Image!);
      selectedPhoto = Image.memory(bytes);
    });
    updateSaveButtonState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 13,
                    width: 9,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: ImageHelper.svgImage(SvgNames.arrowLeft, width: 7, height: 13),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                      onPressed: saveButtonState ? () => save() : null,
                      child: Text(
                        'Save',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: saveButtonState
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground),
                      ))
                ],
              ),
              const SizedBox(height: 15),
              Text('Name of recipe', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 7),
              AppTextFieldWidget(
                controller: nameController,
                placeholder: 'Write the name of the recipe',
                maxLength: 32,
              ),
              const SizedBox(height: 20),
              Text('Description', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 7),
              AppTextFieldWidget(
                controller: descController,
                placeholder: 'Write description',
                maxLength: 64,
              ),
              const SizedBox(height: 20),
              Text('Ingredients', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 7),
              AppTextFieldWidget(
                controller: ingController,
                placeholder: 'Write the name of the recipe',
              ),
              const SizedBox(height: 20),
              Text('Calorie count', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextFieldWidget(
                    controller: fatController,
                    placeholder: 'Fat',
                    keyboardType: TextInputType.number,
                    width: MediaQuery.of(context).size.width / 4,
                    maxLength: 6,
                  ),
                  AppTextFieldWidget(
                      controller: proController,
                      placeholder: 'Pro',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      width: MediaQuery.of(context).size.width / 4),
                  AppTextFieldWidget(
                      controller: carbController,
                      placeholder: 'Carb',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      width: MediaQuery.of(context).size.width / 4),
                ],
              ),
              const SizedBox(height: 30),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: takeAndSavePhoto,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 17, bottom: 34),
                  decoration: selectedPhoto == null
                      ? BoxDecoration(
                          color: Theme.of(context).extension<CustomColors>()!.grey,
                          borderRadius: BorderRadius.circular(9))
                      : BoxDecoration(
                          image: DecorationImage(image: selectedPhoto!.image, fit: BoxFit.cover),
                        ),
                  child: Column(
                    children: [
                      ImageHelper.svgImage(SvgNames.camera),
                      const SizedBox(height: 13),
                      Text(
                        'Upload photo',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
