import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_32/business/helpers/content_embedding.dart';
import 'package:pp_32/business/helpers/dialog_helper.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';
import 'package:pp_32/data/repository/database_service.dart';

class CalculatorController extends ValueNotifier<CalculatorControllerState> {
  CalculatorController() : super(CalculatorControllerState.initial()) {
    initialize();
  }

  final dataBase = GetIt.instance.get<DatabaseService>();

  void updateTip() {
    var random = Random();
    var randomNumber = random.nextInt(50);
    var randomTip = ContentEmbedding().nutritionTips[randomNumber];

    value = value.copyWith(dayTip: randomTip);
    notifyListeners();
  }

  void initialize() {
    updateTip();
    final int? gender = dataBase.get('gender');
    final int? age = dataBase.get('age');
    final int? weight = dataBase.get('weight');
    final int? height = dataBase.get('height');
    final int? activityLevel = dataBase.get('activityLevel');

    if (gender == null ||
        age == null ||
        weight == null ||
        height == null ||
        activityLevel == null) {
      return;
    } else {
      value = value.copyWith(
          gender: gender, age: age, weight: weight, height: height, activityLevel: activityLevel);
      notifyListeners();
    }
  }

  void saveAndCalculate() {
    double BMR = 0;
    if (value.gender == 0) {
      BMR = 88.362 + (13.397 * value.height) + (4.799 * value.height) - (5.677 * value.age);
      if (value.activityLevel == 0) {
        BMR = BMR * 1.2;
      } else if (value.activityLevel == 1) {
        BMR = BMR * 1.375;
      } else {
        BMR = BMR * 1.55;
      }
    } else {
      BMR = 447.593 + (9.247 * value.height) + (3.098 * value.height) - (4.330 * value.age);
      if (value.activityLevel == 0) {
        BMR = BMR * 1.2;
      } else if (value.activityLevel == 1) {
        BMR = BMR * 1.375;
      } else {
        BMR = BMR * 1.55;
      }
    }
    value = value.copyWith(calories: BMR.round());
    notifyListeners();
  }

  Future<void> fillValues({required BuildContext context}) async {
    var gender = await DialogHelper.showGenderFillDialog(context);
    var age = await DialogHelper.showAgeFillDialog(context);
    var weight = await DialogHelper.showWeightFillDialog(context);
    var height = await DialogHelper.showHeightFillDialog(context);
    var activityLevel = await Navigator.of(context).pushNamed(RouteNames.activityLevel) as int?;

    if (activityLevel == null) {
      return;
    }

    value = value.copyWith(
        gender: gender, age: age, weight: weight, height: height, activityLevel: activityLevel);
    dataBase.put('gender', gender);
    dataBase.put('age', age);
    dataBase.put('weight', weight);
    dataBase.put('height', height);
    dataBase.put('activityLevel', activityLevel);
    notifyListeners();
    saveAndCalculate();
  }
}

class CalculatorControllerState {
  CalculatorControllerState({
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.calories,
    required this.dayTip,
  });

  final int gender;
  final int age;
  final int weight;
  final int height;
  final int activityLevel;
  final int calories;
  final String dayTip;

  factory CalculatorControllerState.initial() {
    return CalculatorControllerState(
      gender: -1,
      age: -1,
      weight: -1,
      height: -1,
      activityLevel: -1,
      calories: -1,
      dayTip: '',
    );
  }

  CalculatorControllerState copyWith({
    int? gender,
    int? age,
    int? weight,
    int? height,
    int? activityLevel,
    int? calories,
    String? dayTip,
  }) {
    return CalculatorControllerState(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      calories: calories ?? this.calories,
      dayTip: dayTip ?? this.dayTip,
    );
  }
}
