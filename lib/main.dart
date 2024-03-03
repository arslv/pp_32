import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pp_32/business/services/navigation/navigation_observer.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';
import 'package:pp_32/business/services/navigation/routes.dart';
import 'package:pp_32/business/services/service_locator.dart';
import 'package:pp_32/firebase_options.dart';
import 'package:pp_32/presentation/themes/app_theme.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await _initApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(AppInfo(
    data: await AppInfoData.get(),
    child: const MealPlaner(),
  ));
}

Future<void> _initApp() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } on Exception catch (e) {
    log("Failed to initialize Firebase: $e");
  }

  await ServiceLocator.setup();
}

class MealPlaner extends StatelessWidget {
  const MealPlaner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriPlanner Pro',
      routes: Routes.get(context),
      initialRoute: RouteNames.splash,
      navigatorObservers: [
        CustomNavigatorObserver(),
      ],
      debugShowCheckedModeBanner: false,
      theme: DefaultThemeGetter.get(),
    );
  }
}
