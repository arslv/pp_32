import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_32/business/helpers/email_helper.dart';
import 'package:pp_32/business/helpers/image/image_helper.dart';
import 'package:pp_32/presentation/themes/custom_colors.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  var _isButtonEnabled = false;

  Future<void> _send() async => await EmailHelper.launchEmailSubmission(
        toEmail: 'ksuvei@finconte.site',
        subject: _subjectController.text,
        body: _messageController.text,
        errorCallback: () {},
        doneCallback: () => setState(() {
          _subjectController.clear();
          _messageController.clear();
          _isButtonEnabled = false;
        }),
      );

  void _onChanged(String value) => setState(
        () => _isButtonEnabled =
            _subjectController.text.isNotEmpty && _messageController.text.isNotEmpty,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
          color: Theme.of(context).colorScheme.onPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 13,
                    width: 9,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: ImageHelper.svgImage(SvgNames.arrowLeft, width: 7, height: 13),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text('Contact',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _isButtonEnabled ? _send : null,
                    child: Text(
                      'Send',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: _isButtonEnabled
                              ? CupertinoColors.activeBlue
                              : Theme.of(context).colorScheme.onBackground.withOpacity(0.3)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    _ContactInput(
                      onChanged: _onChanged,
                      controller: _subjectController,
                      placeholder: 'Title',
                    ),
                    const SizedBox(height: 19),
                    _ContactInput(
                      onChanged: _onChanged,
                      controller: _messageController,
                      placeholder: 'Message',
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

class _ContactInput extends StatelessWidget {
  final void Function(String) onChanged;
  final String placeholder;
  final TextEditingController controller;

  const _ContactInput({
    required this.onChanged,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 53,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onBackground),
        borderRadius: BorderRadius.circular(10)
      ),
      child: CupertinoTextField(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        controller: controller,
        onChanged: onChanged,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10)),
        placeholder: placeholder,
        placeholderStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3)),
      ),
    );
  }
}
