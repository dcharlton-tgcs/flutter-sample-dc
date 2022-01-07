import 'package:ecp_openapi/model/pos_order.dart';
import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';

class QuantityKeypadSlider extends StatelessWidget {
  const QuantityKeypadSlider({
    Key? key,
    required this.order,
    required this.index,
    this.maximumQuantity,
    this.onClickAction,
  }) : super(key: key);

  final PosOrder order;
  final int index;
  final int? maximumQuantity;
  final Function? onClickAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    var nonLinkedItems =
        order.items.where((item) => item.parentOrderItemId == 'null').toList();

    return BottomSlider(
      width: 300.00,
      height: 345.00,
      body: Keypad(
        keypadInputField: KeypadLabelField(
          fieldText: nonLinkedItems[index].quantity.toString(),
          fieldLabel: l10n.keypadQuantityLabelText,
          descText: nonLinkedItems[index].item.description['default']['text'],
          maximumQuantity:
              maximumQuantity ?? order.items[index].item.maximumQuantity,
        ),
        confirmButtonText: l10n.okButtonText,
        clearButtonText: l10n.keypadClearButtonText,
        onClickAction: onClickAction,
      ),
    );
  }
}
