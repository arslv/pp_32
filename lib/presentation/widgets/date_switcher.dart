import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/business/helpers/month_enum.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';

class DateSwitcher extends StatefulWidget {
  const DateSwitcher({
    super.key,
    required this.month,
    required this.week,
    required this.increaseAction,
    required this.decreaseAction,
  });

  final int month;
  final int week;
  final VoidCallback increaseAction;
  final VoidCallback decreaseAction;

  @override
  State<DateSwitcher> createState() => _DateSwitcherState();
}

class _DateSwitcherState extends State<DateSwitcher> {
  String getWeekGap(int month, int week) {
    if (month < 0 || month > 12 || week < 1 || week > 4) {
      return "Incorrect data";
    }

    int startDay = (week - 1) * 7 + 1;

    int endDay = startDay + 6;

    return "$startDay-$endDay";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => widget.decreaseAction.call(),
            child: ImageHelper.svgImage(SvgNames.arrowLeft),
          ),
          const Spacer(),
          Text(
            '${DateHelper.months[widget.month]} ${getWeekGap(widget.month, widget.week)}',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const Spacer(),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => widget.increaseAction.call(),
            child: ImageHelper.svgImage(SvgNames.arrowRight),
          ),
        ],
      ),
    );
  }
}
