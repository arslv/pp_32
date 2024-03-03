import 'package:flutter/cupertino.dart';

class DateSwitchController extends ValueNotifier<DateSwitchControllerState> {
  DateSwitchController() : super(DateSwitchControllerState.initial());

  int get activeMonth => value.activeMonth;
  int get activeWeek => value.activeWeek;
  int get activeYear => value.activeYear;

  void increaseWeek() {
    if (value.activeWeek + 1 > 4) {
      if (value.activeMonth + 1 <= 12) {
        value = value.copyWith(activeMonth: value.activeMonth + 1, activeWeek: 1);
      } else {
        value = value.copyWith(activeMonth: 1, activeWeek: 1, activeYear: value.activeYear + 1);
      }
    } else {
      value = value.copyWith(activeWeek: value.activeWeek + 1);
    }
    notifyListeners();
  }

  void decreaseWeek() {
    if (value.activeWeek - 1 < 1) {
      if (value.activeMonth - 1 > 1) {
        value = value.copyWith(activeMonth: value.activeMonth - 1, activeWeek: 4);
      } else {
        value = value.copyWith(activeMonth: 12, activeWeek: 4, activeYear: value.activeYear - 1);
      }
    } else {
      value = value.copyWith(activeWeek: value.activeWeek - 1);
    }
    notifyListeners();
  }
}

class DateSwitchControllerState {
  final int activeMonth;
  final int activeWeek;
  final int activeYear;

  DateSwitchControllerState({
    required this.activeMonth,
    required this.activeWeek,
    required this.activeYear,
  });

  factory DateSwitchControllerState.initial() {
    return DateSwitchControllerState(
      activeMonth: DateTime.now().month,
      activeWeek: ((DateTime.now().day / 7).round() > 0) ? (DateTime.now().day / 7).round() : 1,
      activeYear: 2024,
    );
  }

  DateSwitchControllerState copyWith({
    int? activeMonth,
    int? activeWeek,
    int? activeYear,
  }) {
    return DateSwitchControllerState(
      activeMonth: activeMonth ?? this.activeMonth,
      activeWeek: activeWeek ?? this.activeWeek,
      activeYear: activeYear ?? this.activeYear,
    );
  }
}
