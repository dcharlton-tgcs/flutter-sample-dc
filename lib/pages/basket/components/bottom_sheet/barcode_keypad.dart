import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';

class BarcodeKeypadSlider extends StatelessWidget {
  const BarcodeKeypadSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BottomSlider(
      body: Keypad(
        keypadInputField: KeypadInputField(
          fieldText: l10n.keypadInputHintText,
        ),
        confirmButtonText: l10n.keypadAddButtonText,
        clearButtonText: l10n.keypadClearButtonText,
      ),
    );
  }
}
