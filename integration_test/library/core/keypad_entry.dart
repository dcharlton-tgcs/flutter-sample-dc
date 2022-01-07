import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';

/// Enter values using keypad present on screen
Future<void> keypadEntry(dynamic tester, String keypadCode) async {
  const keyLookup = [
    Keypad.keypadZeroButtonKey,
    Keypad.keypadOneButtonKey,
    Keypad.keypadTwoButtonKey,
    Keypad.keypadThreeButtonKey,
    Keypad.keypadFourButtonKey,
    Keypad.keypadFiveButtonKey,
    Keypad.keypadSixButtonKey,
    Keypad.keypadSevenButtonKey,
    Keypad.keypadEightButtonKey,
    Keypad.keypadNineButtonKey,
  ];
  // Ensure keypad visible
  expect(find.byKey(Keypad.keypadOneButtonKey), findsOneWidget);

  // Work through the keypadCode, pressing relevant keys
  for (int rune in keypadCode.runes) {
    await tester.tap(find.byKey(keyLookup[rune - 48]));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
  }
}

/// Press keypad ADD button
Future<void> keypadAdd(dynamic tester) async {
  // Ensure keypad visible
  expect(find.byKey(Keypad.keypadAddButtonKey), findsOneWidget);

  // Press add
  await tester.tap(find.byKey(Keypad.keypadAddButtonKey));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

/// Press keypad CLEAR button
Future<void> keypadClear(dynamic tester) async {
  // Ensure keypad visible
  expect(find.byKey(Keypad.keypadClearButtonKey), findsOneWidget);

  // Press clear
  await tester.tap(find.byKey(Keypad.keypadClearButtonKey));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

/// Press keypad DELETE button
Future<void> keypadDelete(dynamic tester) async {
  // Ensure keypad visible
  expect(find.byKey(Keypad.keypadDeleteButtonKey), findsOneWidget);

  // Press delete
  await tester.tap(find.byKey(Keypad.keypadDeleteButtonKey));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}
