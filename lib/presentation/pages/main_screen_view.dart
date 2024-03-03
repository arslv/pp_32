import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/presentation/pages/articles_view.dart';
import 'package:pp_32/presentation/pages/calculator_view.dart';
import 'package:pp_32/presentation/pages/meal_plan_view.dart';
import 'package:pp_32/presentation/pages/settings_view.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  _MainScreenViewState createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const MealPlanView(),
    CalculatorView(),
    const ArticlesView(),
    const SettingsView(),
  ];

  void _navigate(int index) => setState(() {
        _currentIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 110,
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavItem(
                label: 'Meal plan',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _currentIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                    ),
                icon: ImageHelper.svgImage(
                  SvgNames.mealPlan,
                  width: 33,
                  height: 33,
                  color: _currentIndex == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                ),
                background: _currentIndex == 0 ? Theme.of(context).colorScheme.primary : null,
                callback: () => _navigate(0),
              ),
              NavItem(
                label: 'Calculator',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _currentIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                    ),
                icon: ImageHelper.svgImage(
                  SvgNames.calculator,
                  width: 33,
                  height: 33,
                  color: _currentIndex == 1
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                ),
                background: _currentIndex == 1 ? Theme.of(context).colorScheme.primary : null,
                callback: () => _navigate(1),
              ),
              NavItem(
                label: 'Articles',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _currentIndex == 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                    ),
                icon: ImageHelper.svgImage(
                  SvgNames.articles,
                  width: 33,
                  height: 33,
                  color: _currentIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                ),
                background: _currentIndex == 2 ? Theme.of(context).colorScheme.primary : null,
                callback: () => _navigate(2),
              ),
              NavItem(
                label: 'Settings',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _currentIndex == 3
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                    ),
                icon: ImageHelper.svgImage(
                  SvgNames.settings,
                  width: 33,
                  height: 33,
                  color: _currentIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                ),
                background: _currentIndex == 3 ? Theme.of(context).colorScheme.primary : null,
                callback: () => _navigate(3),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.callback,
    required this.textStyle,
    this.background,
  });

  final VoidCallback callback;
  final String label;
  final Widget icon;
  final TextStyle textStyle;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => callback.call(),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 6),
          Text(
            label,
            style: textStyle,
          )
        ],
      ),
    );
  }
}
