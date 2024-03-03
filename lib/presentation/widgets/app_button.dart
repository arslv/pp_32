import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.name,
    this.callback,
    this.backgroundColor,
    required this.textColor,
    this.textStyle,
    this.width,
    this.borderRadius,
    this.margin,
    this.padding,
    this.height,
  });

  final String name;
  final VoidCallback? callback;
  final Color? backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 43,
      margin: margin,
      child: CupertinoButton(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        disabledColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        onPressed: callback,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: Text(
          name,
          style: textStyle ?? Theme.of(context).textTheme.labelMedium!.copyWith(color: textColor),
        ),
      ),
    );
  }
}
