import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'week_day_enum.g.dart';

@HiveType(typeId: 4)
enum WeekDay {
  @HiveField(0)
  monday('Monday'),
  @HiveField(1)
  tuesday('Tuesday'),
  @HiveField(2)
  wednesday('Wednesday'),
  @HiveField(3)
  thursday('Thursday'),
  @HiveField(4)
  friday('Friday'),
  @HiveField(5)
  saturday('Saturday'),
  @HiveField(6)
  sunday('Sunday');

  final String name;

  const WeekDay(this.name);
}