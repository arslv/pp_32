import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/presentation/widgets/app_button.dart';

class ActivityLevelView extends StatefulWidget {
  const ActivityLevelView({super.key});

  @override
  State<ActivityLevelView> createState() => _ActivityLevelViewState();
}

class _ActivityLevelViewState extends State<ActivityLevelView> {
  var activityLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
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
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text('Activity level', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 30),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Row(
                      children: [
                        activityLevel == 0
                            ? ImageHelper.svgImage(SvgNames.selected)
                            : ImageHelper.svgImage(SvgNames.unselected),
                        const SizedBox(width: 10),
                        Text(
                          'Low',
                          style: Theme.of(context).textTheme.displaySmall,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        '''Little or no daily activity. \nThe option is suitable for bank employees or other office workers, as well as those who read, play video games or watch TV in their free time.''',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    activityLevel = 0;
                  });
                },
              ),
              const SizedBox(height: 18),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Row(
                      children: [
                        activityLevel == 1
                            ? ImageHelper.svgImage(SvgNames.selected)
                            : ImageHelper.svgImage(SvgNames.unselected),
                        const SizedBox(width: 10),
                        Text(
                          'Medium',
                          style: Theme.of(context).textTheme.displaySmall,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        '''Minor daily activity.\nThis option is suitable for teachers or sales staff, as well as those who walk or cycle to work and do something physically demanding in their spare time.''',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    activityLevel = 1;
                  });
                },
              ),
              const SizedBox(height: 18),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Row(
                      children: [
                        activityLevel == 2
                            ? ImageHelper.svgImage(SvgNames.selected)
                            : ImageHelper.svgImage(SvgNames.unselected),
                        const SizedBox(width: 10),
                        Text(
                          'High',
                          style: Theme.of(context).textTheme.displaySmall,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        '''Moderate daily activity. \nSuitable for service or postal staff and those who are active in their spare time.''',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    activityLevel = 2;
                  });
                },
              ),
              const Spacer(),
              AppButton(
                name: 'Save',
                width: double.infinity,
                textColor: Theme.of(context).colorScheme.onPrimary,
                callback: () => Navigator.of(context).pop(activityLevel),
              ),
              const SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
