import 'package:flutter/cupertino.dart';
import 'package:pp_32/business/helpers/content_embedding.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';
import 'package:pp_32/data/entity/recipe_entity.dart';
import 'package:pp_32/presentation/pages/activity_level_view.dart';
import 'package:pp_32/presentation/pages/agreement_view.dart';
import 'package:pp_32/presentation/pages/articles_view.dart';
import 'package:pp_32/presentation/pages/calculator_view.dart';
import 'package:pp_32/presentation/pages/main_screen_view.dart';
import 'package:pp_32/presentation/pages/onboarding_view.dart';
import 'package:pp_32/presentation/pages/privacy_view.dart';
import 'package:pp_32/presentation/pages/recipe_view.dart';
import 'package:pp_32/presentation/pages/recipes_view.dart';
import 'package:pp_32/presentation/pages/splash_view.dart';
import 'package:pp_32/presentation/pages/support_view.dart';

typedef ScreenBuilding = Widget Function(BuildContext context);

class Routes {
  static Map<String, ScreenBuilding> get(BuildContext context) {
    return {
      RouteNames.splash: (context) => const SplashView(),
      RouteNames.main: (context) => const MainScreenView(),
      RouteNames.onboarding: (context) => const OnboardingView(),
      RouteNames.recipes: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as RecipesViewArguments;
        return RecipesView(
          weekDay: args.weekDay,
          weekMenu: args.weekMenu,
          mealPlanController: args.mealPlanController,
        );
      },
      RouteNames.recipe: (context) {
        final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
        return RecipeView(recipe: recipe);
      },
      RouteNames.calculator: (context) => CalculatorView(),
      RouteNames.activityLevel: (context) => const ActivityLevelView(),
      RouteNames.article: (context) {
        final article = ModalRoute.of(context)!.settings.arguments as Article;
        return ArticleView(article: article);
      },
      RouteNames.agreement: (context) {
        final arg = ModalRoute.of(context)!.settings.arguments as AgreementType;
        return AgreementView(agreementType: arg);
      },
      RouteNames.support: (context) => const SupportView(),
      RouteNames.privacy: (context) => const PrivacyView(),
    };
  }
}
