import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextFieldWidget extends StatelessWidget {
  const AppTextFieldWidget({
    super.key,
    required this.controller,
    required this.placeholder,
    this.width,
    this.maxLength,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String placeholder;
  final double? width;
  final TextInputType? keyboardType;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        maxLength: maxLength,
        placeholderStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3)),
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onBackground),
          borderRadius: BorderRadius.circular(9),
        ),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
      ),
    );
  }
}
