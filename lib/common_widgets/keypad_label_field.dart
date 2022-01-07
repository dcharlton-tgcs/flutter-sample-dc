import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class KeypadLabelField extends GenericField {
  KeypadLabelField({
    Key? key,
    required this.fieldText,
    required this.fieldLabel,
    required this.descText,
    required this.maximumQuantity,
  }) : super(key: key);

  final String fieldText;
  final String fieldLabel;
  final String descText;
  final num maximumQuantity;

  @override
  int get maxLength => 10;

  @override
  int get maxQuantity => maximumQuantity.toInt();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 8.0,
                left: 20.0,
                bottom: 8.0,
              ),
              child: Text(
                descText,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Text(
                fieldLabel,
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: 162,
              height: 40,
              decoration: const BoxDecoration(
                color: UiuxColours.whiteBackground,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              margin: const EdgeInsets.only(
                right: 21.0,
              ),
              child: TextField(
                controller: keypadController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    bottom: 8,
                    right: 16,
                  ),
                  border: InputBorder.none,
                  hintText: fieldText,
                  hintStyle: Theme.of(context).textTheme.keypadQuantityText,
                  counterText: '',
                ),
                enabled: false,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Row(
          children: const [
            SizedBox(height: 6.0),
          ],
        ),
      ],
    );
  }
}
