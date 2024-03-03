import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pp_32/business/helpers/dialog_helper.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/business/services/navigation/route_names.dart';
import 'package:pp_32/presentation/pages/agreement_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _rate() async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    }
  }

  void _showAppVersionDialog(BuildContext context) => DialogHelper.showAppVersionDialog(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: CupertinoListSection(
                  topMargin: 0,
                  margin: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]),
                  children: <SettingsSection>[
                    SettingsSection(
                      icon: ImageHelper.svgImage(SvgNames.share),
                      label: 'Share app',
                      callback: () {},
                    ),
                    SettingsSection(
                      icon: ImageHelper.svgImage(SvgNames.rate),
                      label: 'Rate us',
                      callback: _rate,
                    ),
                    SettingsSection(
                      icon: ImageHelper.svgImage(SvgNames.contact),
                      label: 'Contact',
                      callback: () => Navigator.of(context).pushNamed(RouteNames.support),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: CupertinoListSection(
                  topMargin: 0,
                  margin: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: <SettingsSection>[
                    SettingsSection(
                      icon: ImageHelper.svgImage(SvgNames.privacy),
                      label: 'Privacy Policy',
                      callback: () => Navigator.of(context)
                          .pushNamed(RouteNames.agreement, arguments: AgreementType.privacy),
                    ),
                    SettingsSection(
                      icon: ImageHelper.svgImage(SvgNames.terms),
                      label: 'Terms of Use',
                      callback: () => Navigator.of(context)
                          .pushNamed(RouteNames.agreement, arguments: AgreementType.terms),
                    ),
                    SettingsSection(
                      icon: ImageHelper.svgImage(SvgNames.appVer),
                      label: 'Application version',
                      callback: () => _showAppVersionDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.callback,
    this.boxShadow,
  });

  final Widget icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? callback;
  final BoxShadow? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.onPrimary,
        // boxShadow: boxShadow != null ? [boxShadow!] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CupertinoListTile(
          title: Text(label, style: Theme.of(context).textTheme.displaySmall),
          leading: icon,
          trailing: trailing ?? const CupertinoListTileChevron(),
          onTap: callback,
        ),
      ),
    );
  }
}
