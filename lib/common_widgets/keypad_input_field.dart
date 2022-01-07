import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/keypad.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class KeypadInputField extends GenericField {
  KeypadInputField({
    Key? key,
    required this.fieldText,
  }) : super(key: key);

  final String fieldText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.13,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 7.0,
          ),
        ],
        color: Colors.grey[100],
      ),
      margin: const EdgeInsets.fromLTRB(
        8.0,
        15.0,
        8.0,
        6.0,
      ),
      child: TextField(
        controller: keypadController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
          filled: true,
          fillColor: UiuxColours.whiteBackground,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 8.0,
          ),
          hintText: fieldText,
          hintStyle: ECPTextStyles.barcodeHintTextStyle,
        ),
        enabled: false,
      ),
    );
  }
}
