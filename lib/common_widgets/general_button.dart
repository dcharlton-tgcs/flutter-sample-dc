import 'package:flutter/material.dart';

/// Generic button which will be used in the whole application
/// In the future we will add new fields for button customisation
class GeneralButton extends StatelessWidget {
  const GeneralButton({
    Key? key,
    required this.style,
    required this.onPressed,
    required this.buttonWidth,
    required this.buttonHeight,
    this.buttonDisabled,
    this.child,
  }) : super(key: key);

  final ButtonStyle style;
  final Function() onPressed;
  final double buttonWidth;
  final double buttonHeight;
  final bool? buttonDisabled;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    var _disabled = false;
    if (buttonDisabled != null) {
      _disabled = buttonDisabled!;
    }

    if (_disabled) {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: null,
          style: style,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}
