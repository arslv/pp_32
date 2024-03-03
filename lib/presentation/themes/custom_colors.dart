import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    this.grey,
    this.sliderBg,
    this.background,
    this.fat,
    this.pro,
    this.carb,
  });

  final Color? grey;
  final Color? sliderBg;
  final Color? background;
  final Color? fat;
  final Color? pro;
  final Color? carb;

  @override
  CustomColors copyWith({
    Color? grey,
    Color? sliderBg,
    Color? background,
    Color? fat,
    Color? pro,
    Color? carb,
  }) {
    return CustomColors(
      grey: grey ?? this.grey,
      sliderBg: sliderBg ?? this.sliderBg,
      background: background ?? this.background,
      fat: fat ?? this.fat,
      pro: pro ?? this.pro,
      carb: carb ?? this.carb,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      grey: Color.lerp(grey, other.grey, t)!,
      sliderBg: Color.lerp(sliderBg, other.sliderBg, t)!,
      background: Color.lerp(background, other.background, t)!,
      fat: Color.lerp(fat, other.fat, t)!,
      pro: Color.lerp(pro, other.pro, t)!,
      carb: Color.lerp(carb, other.carb, t)!,
    );
  }

  static const light = CustomColors(
    grey: Color(0xFFF2F2F2),
    sliderBg: Color(0xFFEEEEEF),
    background: Color(0xFFF4F4F4),
    fat: Color(0xFFFEC635),
    pro: Color(0xFF3585FE),
    carb: Color(0xFF8A47EB),
  );
}
