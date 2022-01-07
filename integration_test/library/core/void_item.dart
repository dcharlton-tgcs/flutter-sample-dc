import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> voidItem(dynamic tester, itemId) async {
  // Find the slidable for this item
  var slidable = find.byKey(Key('slidableKey$itemId'));

  // Slide left to reveal the Delete button
  await tester.drag(slidable, const Offset(-100.0, 0.0));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Find the now visible Delete action button and press it
  var slidableAction = find.byType(SlidableAction);
  await tester.tap(slidableAction);
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}
