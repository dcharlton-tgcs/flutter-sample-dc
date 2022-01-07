import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';

import '../helpers/pump_app.dart';

Scaffold getKeypadGenericMaterialWidget() {
  return Scaffold(
    body: Keypad(
      keypadInputField: GenericField(),
      confirmButtonText: 'Add',
      clearButtonText: 'Clear',
    ),
  );
}

Scaffold getKeypadInputMaterialWidget() {
  return Scaffold(
    body: Keypad(
      keypadInputField: KeypadInputField(
        fieldText: 'Enter barcode',
      ),
      confirmButtonText: 'Add',
      clearButtonText: 'Clear',
    ),
  );
}

Scaffold getKeypadLabelMaterialWidget() {
  return Scaffold(
    body: Keypad(
      keypadInputField: KeypadLabelField(
        fieldText: '1',
        descText: 'Milk',
        fieldLabel: 'Number of items',
        maximumQuantity: 10000,
      ),
      confirmButtonText: 'OK',
      clearButtonText: 'Clear',
    ),
  );
}

void main() {
  group('Testing the input keypad', () {
    const keypadZeroButtonKey = Key('keypad_zero_button');
    const keypadOneButtonKey = Key('keypad_one_button');
    const keypadTwoButtonKey = Key('keypad_two_button');
    const keypadThreeButtonKey = Key('keypad_three_button');
    const keypadFourButtonKey = Key('keypad_four_button');
    const keypadFiveButtonKey = Key('keypad_five_button');
    const keypadSixButtonKey = Key('keypad_six_button');
    const keypadSevenButtonKey = Key('keypad_seven_button');
    const keypadEightButtonKey = Key('keypad_eight_button');
    const keypadNineButtonKey = Key('keypad_nine_button');
    const keypadDeleteButtonKey = Key('keypad_delete_button');
    const keypadClearButtonKey = Key('keypad_clear_button');
    const keypadAddButtonKey = Key('keypad_add_button');

    testWidgets('Verify if keypad with generic field has all the buttons',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadGenericMaterialWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GenericField), findsOneWidget);
      expect(find.byKey(keypadZeroButtonKey), findsOneWidget);
      expect(find.byKey(keypadOneButtonKey), findsOneWidget);
      expect(find.byKey(keypadTwoButtonKey), findsOneWidget);
      expect(find.byKey(keypadThreeButtonKey), findsOneWidget);
      expect(find.byKey(keypadFourButtonKey), findsOneWidget);
      expect(find.byKey(keypadFiveButtonKey), findsOneWidget);
      expect(find.byKey(keypadSixButtonKey), findsOneWidget);
      expect(find.byKey(keypadSevenButtonKey), findsOneWidget);
      expect(find.byKey(keypadEightButtonKey), findsOneWidget);
      expect(find.byKey(keypadNineButtonKey), findsOneWidget);
      expect(find.byKey(keypadDeleteButtonKey), findsOneWidget);
      expect(find.byKey(keypadClearButtonKey), findsOneWidget);
      expect(find.byKey(keypadAddButtonKey), findsOneWidget);
    });

    testWidgets(
        'Verify if tapping 0 button multiple times will only display 0 (Quantity keypad)',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));

      expect(find.text('0'), findsNWidgets(2));
    });

    testWidgets(
        'Verify if tapping 0 button multiple times and then tap other numerical buttons will display a valid number (Quantity keypad)',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));

      expect(find.text('0'), findsNWidgets(2));

      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.tap(find.byKey(keypadThreeButtonKey));

      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('Verify if keypad with barcode field has all the buttons',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadInputMaterialWidget());
      await tester.pumpAndSettle();

      expect(find.byType(KeypadInputField), findsOneWidget);
      expect(find.byKey(keypadZeroButtonKey), findsOneWidget);
      expect(find.byKey(keypadOneButtonKey), findsOneWidget);
      expect(find.byKey(keypadTwoButtonKey), findsOneWidget);
      expect(find.byKey(keypadThreeButtonKey), findsOneWidget);
      expect(find.byKey(keypadFourButtonKey), findsOneWidget);
      expect(find.byKey(keypadFiveButtonKey), findsOneWidget);
      expect(find.byKey(keypadSixButtonKey), findsOneWidget);
      expect(find.byKey(keypadSevenButtonKey), findsOneWidget);
      expect(find.byKey(keypadEightButtonKey), findsOneWidget);
      expect(find.byKey(keypadNineButtonKey), findsOneWidget);
      expect(find.byKey(keypadDeleteButtonKey), findsOneWidget);
      expect(find.byKey(keypadClearButtonKey), findsOneWidget);
      expect(find.byKey(keypadAddButtonKey), findsOneWidget);
    });

    testWidgets('Verify if keypad with quantity field has all the buttons',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      expect(find.byType(KeypadLabelField), findsOneWidget);
      expect(find.byKey(keypadZeroButtonKey), findsOneWidget);
      expect(find.byKey(keypadOneButtonKey), findsOneWidget);
      expect(find.byKey(keypadTwoButtonKey), findsOneWidget);
      expect(find.byKey(keypadThreeButtonKey), findsOneWidget);
      expect(find.byKey(keypadFourButtonKey), findsOneWidget);
      expect(find.byKey(keypadFiveButtonKey), findsOneWidget);
      expect(find.byKey(keypadSixButtonKey), findsOneWidget);
      expect(find.byKey(keypadSevenButtonKey), findsOneWidget);
      expect(find.byKey(keypadEightButtonKey), findsOneWidget);
      expect(find.byKey(keypadNineButtonKey), findsOneWidget);
      expect(find.byKey(keypadDeleteButtonKey), findsOneWidget);
      expect(find.byKey(keypadClearButtonKey), findsOneWidget);
      expect(find.byKey(keypadAddButtonKey), findsOneWidget);
    });

    testWidgets('Test if the barcode input is working', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadInputMaterialWidget());
      await tester.pumpAndSettle();

      expect(find.byType(KeypadInputField), findsOneWidget);
      expect(find.text('Enter barcode'), findsOneWidget);
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadOneButtonKey));
      expect(find.text('1101'), findsOneWidget);
    });

    testWidgets('Test if the quantity field is working', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      expect(find.byType(KeypadLabelField), findsOneWidget);
      expect(find.text('1'), findsNWidgets(2));
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text('Number of items'), findsOneWidget);
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.tap(find.byKey(keypadOneButtonKey));
      expect(find.text('1101'), findsOneWidget);
    });

    testWidgets('Testing the taps for all numeric buttons for barcode',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadInputMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadThreeButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFourButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFiveButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSixButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSevenButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      expect(find.text('0123456789'), findsOneWidget);
    });

    testWidgets('Testing the taps for all numeric buttons for quantity',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadThreeButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFourButtonKey));
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);
      await tester.tap(find.byKey(keypadClearButtonKey));
      expect(find.text(''), findsWidgets);
      await tester.tap(find.byKey(keypadFiveButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSixButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSevenButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      expect(find.text('5678'), findsOneWidget);
      await tester.tap(find.byKey(keypadClearButtonKey));
      expect(find.text(''), findsWidgets);
      await tester.tap(find.byKey(keypadSevenButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      expect(find.text('789'), findsOneWidget);
    });

    testWidgets('Testing maximum length of barcode input', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;
      await tester.pumpApp(getKeypadInputMaterialWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadThreeButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFourButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFiveButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSixButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSevenButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadThreeButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFourButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFiveButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSixButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSevenButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadThreeButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFourButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadFiveButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSixButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadSevenButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadThreeButtonKey));
      await tester.pump();
      expect(find.text('01234567890123456789012345678901'), findsOneWidget);
      expect(find.text('0123456789012345678901234567890123'), findsNothing);
    });

    testWidgets('Testing maximum length of quantity input', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;
      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(keypadZeroButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadOneButtonKey));
      await tester.pump();
      expect(find.text('1'), findsNWidgets(3));
      await tester.tap(find.byKey(keypadTwoButtonKey));
      await tester.pump();
      expect(find.text('12'), findsOneWidget);
      await tester.tap(find.byKey(keypadThreeButtonKey));
      await tester.pump();
      expect(find.text('123'), findsOneWidget);
      await tester.tap(find.byKey(keypadFourButtonKey));
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);
      await tester.tap(find.byKey(keypadFiveButtonKey));
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);
      expect(find.text('12345'), findsNothing);
      await tester.tap(find.byKey(keypadSixButtonKey));
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);
      expect(find.text('123456'), findsNothing);
      await tester.tap(find.byKey(keypadSevenButtonKey));
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);
      expect(find.text('1234567'), findsNothing);
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);
      expect(find.text('12345678'), findsNothing);
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);
      expect(find.text('123456789'), findsNothing);
    });

    testWidgets('Test the barcode delete button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadInputMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      expect(find.text('8989'), findsOneWidget);
      await tester.tap(find.byKey(keypadDeleteButtonKey));
      expect(find.text('898'), findsOneWidget);
    });

    testWidgets('Test the quantity delete button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      expect(find.text('8989'), findsOneWidget);
      await tester.tap(find.byKey(keypadDeleteButtonKey));
      expect(find.text('898'), findsOneWidget);
    });

    testWidgets('Test the barcode add button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadInputMaterialWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(keypadAddButtonKey), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      await tester.tap(find.byKey(keypadAddButtonKey));
    });

    testWidgets('Test the quantity OK button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(keypadAddButtonKey), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      await tester.tap(find.byKey(keypadAddButtonKey));
    });

    testWidgets('Test the barcode clear button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadInputMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      expect(find.text('8989'), findsOneWidget);
      expect(find.byKey(keypadClearButtonKey), findsOneWidget);
      await tester.tap(find.byKey(keypadClearButtonKey));
      expect(find.text(''), findsWidgets);
    });

    testWidgets('Test the quantity clear button', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(720, 1280);
      tester.binding.window.devicePixelRatioTestValue = 0.56;

      await tester.pumpApp(getKeypadLabelMaterialWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadEightButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(keypadNineButtonKey));
      await tester.pump();
      expect(find.text('8989'), findsOneWidget);
      expect(find.byKey(keypadClearButtonKey), findsOneWidget);
      await tester.tap(find.byKey(keypadClearButtonKey));
      expect(find.text(''), findsWidgets);
    });
  });
}
