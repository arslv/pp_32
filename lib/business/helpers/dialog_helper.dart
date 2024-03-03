import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/business/helpers/month_enum.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';

class DialogHelper {
  static Future<void> showNoInternetDialog(BuildContext context) async => await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'You have lost your internet connection. Please check your settings and try again.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.splash,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );

  static Future<void> showErrorDialog(BuildContext context, String error) async =>
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(error),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  static Future<void> showCustomDialog(
          {required BuildContext context,
          required String title,
          String? content,
          VoidCallback? submit,
          VoidCallback? cancel}) async =>
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content ?? ''),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Yes'),
              onPressed: () {
                submit?.call();
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () {
                cancel?.call();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  static Future<void> showAppVersionDialog(BuildContext context) async {
    final info = AppInfo.of(context);
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text(info.package.appName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Operating system: ${info.platform.operatingSystem}'),
            SizedBox(height: 8),
            Text('Installer store: ${info.package.installerStore ?? '-'}'),
            SizedBox(height: 8),
            Text('Version: ${info.package.versionWithoutBuild}'),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              'OK',
              style: TextStyle().copyWith(color: CupertinoColors.activeBlue),
            ),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }

  static Future<int> showGenderFillDialog(BuildContext context) async {
    var selectedGender = 0;
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return CupertinoAlertDialog(
            title: Text(
              'Gender',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => setState(() => selectedGender = 0),
                  child: Row(
                    children: [
                      Text(
                        'Female',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
                      ),
                      const Spacer(),
                      selectedGender == 0
                          ? ImageHelper.svgImage(SvgNames.selected)
                          : const SizedBox()
                    ],
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.15),
                  height: 1,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => setState(() => selectedGender = 1),
                  child: Row(
                    children: [
                      Text(
                        'Male',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)),
                      ),
                      const Spacer(),
                      selectedGender == 1
                          ? ImageHelper.svgImage(SvgNames.selected)
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  'Save',
                  style: TextStyle().copyWith(color: CupertinoColors.activeBlue),
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          );
        },
      ),
    );
    return selectedGender;
  }

  static Future<int> showAgeFillDialog(BuildContext context) async {
    void showDateTimeDialog(Widget child) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ),
      );
    }

    var dateTimeDouble = DateTime.now();
    var selectedAge = 0;
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return CupertinoAlertDialog(
            title: Text(
              'Age',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => showDateTimeDialog(
                    CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      showDayOfWeek: false,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          dateTimeDouble = newDate;
                        });
                      },
                    ),
                  ),
                  child: Container(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(9)),
                          border: Border.all(color: Theme.of(context).colorScheme.onBackground)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${dateTimeDouble.day}',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text('${DateHelper.months[dateTimeDouble.month]}',
                              style: Theme.of(context).textTheme.displaySmall),
                          Text('${dateTimeDouble.year}',
                              style: Theme.of(context).textTheme.displaySmall),
                        ],
                      )),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  'Save',
                  style: TextStyle().copyWith(color: CupertinoColors.activeBlue),
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          );
        },
      ),
    );
    return DateTime.now().year - dateTimeDouble.year;
  }

  static Future<int> showWeightFillDialog(BuildContext context) async {
    var selectedWeight = 0;
    final controller = TextEditingController(text: '0');
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return CupertinoAlertDialog(
            title: Text(
              'Weight',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(() => controller.text != '0'
                          ? controller.text = (int.parse(controller.text) - 1).toString()
                          : 0),
                      child: ImageHelper.svgImage(SvgNames.remove, width: 30, height: 30),
                    ),
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: CupertinoTextField(
                          controller: controller,
                          maxLength: 3,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          placeholder: '0',
                          placeholderStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(
                          () => controller.text = (int.parse(controller.text) + 1).toString()),
                      child: ImageHelper.svgImage(SvgNames.add, width: 30, height: 30),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  if (controller.text == '0') {
                    DialogHelper.showErrorDialog(context, 'Cannot set 0 value!');
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle().copyWith(color: CupertinoColors.activeBlue),
                ),
              ),
            ],
          );
        },
      ),
    );
    return (int.parse(controller.text));
  }

  static Future<int> showHeightFillDialog(BuildContext context) async {
    final controller = TextEditingController(text: '0');
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return CupertinoAlertDialog(
            title: Text(
              'Height',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(() => controller.text != '0'
                          ? controller.text = (int.parse(controller.text) - 1).toString()
                          : 0),
                      child: ImageHelper.svgImage(SvgNames.remove, width: 30, height: 30),
                    ),
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: CupertinoTextField(
                          controller: controller,
                          maxLength: 3,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          placeholder: '0',
                          placeholderStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(
                          () => controller.text = (int.parse(controller.text) + 1).toString()),
                      child: ImageHelper.svgImage(SvgNames.add, width: 30, height: 30),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  if (controller.text == '0') {
                    DialogHelper.showErrorDialog(context, 'Cannot set 0 value!');
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle().copyWith(color: CupertinoColors.activeBlue),
                ),
              ),
            ],
          );
        },
      ),
    );
    return (int.parse(controller.text));
  }
}
