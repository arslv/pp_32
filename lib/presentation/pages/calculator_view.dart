import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/controllers/calculator_controller.dart';
import 'package:pp_32/business/helpers/extensions/string_extension.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';

enum Gender{
  female,
  male,
}

enum ActivityLevel {
  low,
  medium,
  high,
}

class CalculatorView extends StatelessWidget {
  CalculatorView({super.key});

  final calculatorController = CalculatorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).colorScheme.onPrimary,
        child: ValueListenableBuilder(
          valueListenable: calculatorController,
          builder: (BuildContext context, CalculatorControllerState state, Widget? child) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        'Nutrition Calculator',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => calculatorController.fillValues(context: context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        border:
                            Border.all(color: Theme.of(context).colorScheme.onBackground, width: 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Gender', style: Theme.of(context).textTheme.displaySmall),
                              const Spacer(),
                              Text(state.gender == -1 ? '-' : Gender.values.elementAt(state.gender).name.capitalize,
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.4)))
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Age', style: Theme.of(context).textTheme.displaySmall),
                              const Spacer(),
                              Text(state.age == -1 ? '-' : '${state.age}',
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.4)))
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Weight', style: Theme.of(context).textTheme.displaySmall),
                              const Spacer(),
                              Text(state.weight == -1 ? '-' : '${state.weight} kg',
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.4)))
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Height', style: Theme.of(context).textTheme.displaySmall),
                              const Spacer(),
                              Text(state.height == -1 ? '-' : '${state.height} cm',
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.4)))
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Activity level',
                                  style: Theme.of(context).textTheme.displaySmall),
                              const Spacer(),
                              Text(state.activityLevel == -1 ? '-' : ActivityLevel.values.elementAt(state.activityLevel).name.capitalize,
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.4)))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 23),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border:
                          Border.all(color: Theme.of(context).colorScheme.onBackground, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calculation results', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Calories',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.6)),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    ImageHelper.svgImage(SvgNames.fair),
                                    const SizedBox(width: 6),
                                    Text(
                                      state.calories == -1 ? '0' : state.calories.toString(),
                                      style: Theme.of(context).textTheme.displaySmall,
                                    )
                                  ],
                                )
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 73,
                                  width: 73,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 6,
                                    color: Theme.of(context).extension<CustomColors>()!.fat,
                                    backgroundColor:
                                        Theme.of(context).extension<CustomColors>()!.grey,
                                    value: 0.29,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '29%',
                                      style: Theme.of(context).textTheme.displaySmall,
                                    ),
                                    Text(
                                      'Fat',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.6)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 73,
                                  width: 73,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 6,
                                    color: Theme.of(context).extension<CustomColors>()!.pro,
                                    backgroundColor:
                                        Theme.of(context).extension<CustomColors>()!.grey,
                                    value: 0.30,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '30%',
                                      style: Theme.of(context).textTheme.displaySmall,
                                    ),
                                    Text(
                                      'Pro',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.6)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 73,
                                  width: 73,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 6,
                                    color: Theme.of(context).extension<CustomColors>()!.carb,
                                    backgroundColor:
                                        Theme.of(context).extension<CustomColors>()!.grey,
                                    value: 0.41,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '41%',
                                      style: Theme.of(context).textTheme.displaySmall,
                                    ),
                                    Text(
                                      'Carb',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                              .withOpacity(0.6)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 23),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border:
                          Border.all(color: Theme.of(context).colorScheme.onBackground, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tip of the Day', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text(
                          state.dayTip,
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
