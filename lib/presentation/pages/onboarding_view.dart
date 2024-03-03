import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';
import 'package:pp_32/data/repository/database_keys.dart';
import 'package:pp_32/data/repository/database_service.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';
import 'package:pp_32/presentation/widgets/app_button.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _databaseService = GetIt.instance<DatabaseService>();

  int currentStep = 0;

  final images = [
    ImageHelper.getImage(ImageNames.onb1),
    ImageHelper.getImage(ImageNames.onb2),
    ImageHelper.getImage(ImageNames.onb3),
  ];

  void _increaseStep() {
    print(DateTime.now());
    if (currentStep == 2) {
      Navigator.of(context).pushReplacementNamed(RouteNames.main);
      return;
    }
    setState(() {
      currentStep += 1;
    });
  }

  void _decreaseStep() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  void _init() {
    _databaseService.put(DatabaseKeys.seenOnboarding, true);
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: images[currentStep].image,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 78),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      currentStep != 0
                          ? AppButton(
                              width: 115,
                              callback: _decreaseStep,
                              name: 'Back',
                              textColor:
                                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                              backgroundColor: Theme.of(context).extension<CustomColors>()!.grey,
                            )
                          : const SizedBox(),
                      const Spacer(),
                      AppButton(
                        width: 115,
                        callback: _increaseStep,
                        name: 'Next',
                        textColor: currentStep == 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: currentStep == 0
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
