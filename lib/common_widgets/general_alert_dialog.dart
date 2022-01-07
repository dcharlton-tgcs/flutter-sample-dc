import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/theme/theme.dart';

// ignore: must_be_immutable
class GeneralAlertDialog extends StatelessWidget {
  static const primaryAlertButtonKey = Key('primary_alert_button_key');
  static const secondaryAlertButtonKey = Key('secondary_alert_button_key');

  GeneralAlertDialog({
    Key? key,
    required this.label,
    required this.content,
    required this.primaryButtonText,
    required this.primaryOnPressed,
    this.secondaryButtonText,
    this.secondaryOnPressed,
  }) : super(key: key);

  final String label;
  final String content;
  final String primaryButtonText;
  final Function() primaryOnPressed;
  String? secondaryButtonText;
  Function()? secondaryOnPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.alertLabelText,
          ),
          const SizedBox(height: 16.0),
          Text(content),
        ],
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyText2,
      contentPadding: const EdgeInsets.fromLTRB(
        16.0,
        20.0,
        16.0,
        24.0,
      ),
      actions: [
        Column(
          children: [
            Row(
              children: secondaryButtonText != null
                  ? [
                      const SizedBox(width: 8.0),
                      GeneralButton(
                        key: secondaryAlertButtonKey,
                        onPressed: secondaryOnPressed!,
                        buttonWidth: 144.0,
                        buttonHeight: 44.0,
                        style: ECPButtonStyles.secondaryButtonStyle,
                        child: Text(secondaryButtonText!,
                            style: Theme.of(context)
                                .textTheme
                                .secondaryButtonText),
                      ),
                      const SizedBox(width: 8.0),
                      GeneralButton(
                        key: primaryAlertButtonKey,
                        onPressed: primaryOnPressed,
                        buttonWidth: 144.0,
                        buttonHeight: 44.0,
                        style: ECPButtonStyles.primaryButtonStyle,
                        child: Text(primaryButtonText,
                            style:
                                Theme.of(context).textTheme.primaryButtonText),
                      ),
                      const SizedBox(width: 8.0),
                    ]
                  : [
                      const SizedBox(width: 160.0),
                      GeneralButton(
                        key: primaryAlertButtonKey,
                        onPressed: primaryOnPressed,
                        buttonWidth: 144.0,
                        buttonHeight: 44.0,
                        style: ECPButtonStyles.primaryButtonStyle,
                        child: Text(primaryButtonText,
                            style:
                                Theme.of(context).textTheme.primaryButtonText),
                      ),
                      const SizedBox(width: 8.0),
                    ],
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ],
    );
  }
}
