import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';

Future<Map<String, dynamic>?> getItemListData(dynamic tester, int id) async {
  Map<String, dynamic> data = {};

  // Find all item containers first
  final Finder allContainers = find.byKey(ItemsListWidget.itemContainerKey);

  // Focus on the item container we want to test
  final itemContainerOnTest = allContainers.at(id);

  // Find description
  final itemDescriptionFinder = find.descendant(
      of: itemContainerOnTest,
      matching: find.byKey(ItemsListWidget.descTextKey));

  // Find quantity
  final itemQuantityFinder = find.descendant(
      of: itemContainerOnTest, matching: find.byKey(Key('quantityPadKey$id')));

  // Find the text from the quantity inkwell
  final quantityTextFinder = find.descendant(
      of: itemQuantityFinder,
      matching: find.byKey(ItemsListWidget.quantityTextKey));

  // Finally, extract the text elements for each
  try {
    final Text descriptionText =
        itemDescriptionFinder.evaluate().single.widget as Text;

    final Text quantityText =
        quantityTextFinder.evaluate().single.widget as Text;

    data['description'] = descriptionText.data!;
    data['quantity'] = quantityText.data!;
  } catch (e) {
    return null;
  }

  return data;
}
