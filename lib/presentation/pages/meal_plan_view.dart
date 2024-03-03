import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/controllers/meal_plan_controller.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';
import 'package:pp_32/presentation/widgets/date_switcher.dart';
import 'package:pp_32/presentation/widgets/menu_widget.dart';

enum TabSegment { day, week }

class MealPlanView extends StatefulWidget {
  const MealPlanView({super.key});

  @override
  State<MealPlanView> createState() => _MealPlanViewState();
}

class _MealPlanViewState extends State<MealPlanView> {
  TabSegment _selectedSegment = TabSegment.day;
  final mealPlanController = MealPlanController();

  @override
  void dispose() {
    mealPlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
        child: ValueListenableBuilder(
          valueListenable: mealPlanController,
          builder: (BuildContext context, MealPlanControllerState state, Widget? child) {
            return SafeArea(
              child: Column(
                children: [
                  CupertinoSlidingSegmentedControl<TabSegment>(
                    backgroundColor: Theme.of(context).extension<CustomColors>()!.sliderBg!,
                    thumbColor: Theme.of(context).colorScheme.onPrimary,
                    groupValue: _selectedSegment,
                    padding: const EdgeInsets.all(2),
                    onValueChanged: (TabSegment? value) {
                      if (value != null) {
                        setState(() {
                          _selectedSegment = value;
                        });
                        mealPlanController.toggleTab(value);
                      }
                    },
                    children: <TabSegment, Widget>{
                      TabSegment.day: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'For a day',
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: _selectedSegment == TabSegment.day
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                      TabSegment.week: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'For a week',
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: _selectedSegment == TabSegment.week
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    },
                  ),
                  const SizedBox(height: 10),
                  _selectedSegment == TabSegment.week ? DateSwitcher(
                    month: mealPlanController.activeMonth,
                    week: mealPlanController.activeWeek,
                    increaseAction: mealPlanController.increaseWeek,
                    decreaseAction: mealPlanController.decreaseWeek,
                  ) : const SizedBox(),
                  const SizedBox(height: 10),
                  MenuWidget(
                    weekMenu: state.weekMenu,
                    mealPlanController: mealPlanController,
                    selectedSegment: _selectedSegment,
                    dayMenu: state.dayMenu,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
