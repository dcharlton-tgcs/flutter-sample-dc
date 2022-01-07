import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/theme/theme.dart';

//Should be extended to have custom widget
//ensures keypad has access to input fields
class GenericField extends StatelessWidget {
  GenericField({
    Key? key,
  }) : super(key: key);

  final _keypadController = TextEditingController();

  TextEditingController get keypadController => _keypadController;

  int get maxLength => 32;

  int get maxQuantity => -1;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Keypad extends StatefulWidget {
  const Keypad({
    Key? key,
    required this.confirmButtonText,
    required this.clearButtonText,
    required this.keypadInputField,
    this.onClickAction,
  }) : super(key: key);

  static const keypadOneButtonKey = Key('keypad_one_button');
  static const keypadTwoButtonKey = Key('keypad_two_button');
  static const keypadThreeButtonKey = Key('keypad_three_button');
  static const keypadFourButtonKey = Key('keypad_four_button');
  static const keypadFiveButtonKey = Key('keypad_five_button');
  static const keypadSixButtonKey = Key('keypad_six_button');
  static const keypadSevenButtonKey = Key('keypad_seven_button');
  static const keypadEightButtonKey = Key('keypad_eight_button');
  static const keypadNineButtonKey = Key('keypad_nine_button');
  static const keypadZeroButtonKey = Key('keypad_zero_button');
  static const keypadDeleteButtonKey = Key('keypad_delete_button');
  static const keypadClearButtonKey = Key('keypad_clear_button');
  static const keypadAddButtonKey = Key('keypad_add_button');

  final String confirmButtonText;
  final String clearButtonText;
  final GenericField keypadInputField;
  final Function? onClickAction;

  @override
  _KeypadState createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  _KeypadState();

  late TextEditingController _keypadController;

  @override
  void dispose() {
    _keypadController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void onClick(String btnValue, TextEditingController _keypadController,
      int maxLength, int maxValue) {
    setState(() {
      if (_keypadController.text.length < maxLength) {
        if (maxValue < 0) {
          _keypadController.text += btnValue;
        } else {
          var value = _keypadController.text + btnValue;
          var intValue = int.parse(value);
          if (intValue <= maxValue) {
            _keypadController.text = intValue.toString();
          }
        }
      }
    });
  }

  String removeLastDigit(String barcode) {
    if (barcode.isNotEmpty) {
      setState(() {
        barcode = barcode.substring(0, barcode.length - 1);
      });
    } else {
      return '';
    }
    return barcode;
  }

  @override
  Widget build(BuildContext context) {
    _keypadController = widget.keypadInputField.keypadController;
    int _maxLength = widget.keypadInputField.maxLength;
    int _maxQuantity = widget.keypadInputField.maxQuantity;
    return Column(
      children: [
        widget.keypadInputField,
        _keypadBody(_keypadController, _maxLength, _maxQuantity),
      ],
    );
  }

  Padding _keypadBody(
    TextEditingController _keypadController,
    int _maxLength,
    int _maxQuantity,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(8.0, 6.0, 6.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadOneButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '1',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('1'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(8.0, 6.0, 6.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadFourButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '4',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('4'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(8.0, 6.0, 6.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadSevenButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '7',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('7'),
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadTwoButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '2',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('2'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadFiveButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '5',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('5'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadEightButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '8',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('8'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(2.0, 6.0, 2.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadZeroButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '0',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('0'),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(6.0, 6.0, 2.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadThreeButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '3',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('3'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(6.0, 6.0, 2.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadSixButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '6',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('6'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(6.0, 6.0, 2.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadNineButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    onClick(
                      '9',
                      _keypadController,
                      _maxLength,
                      _maxQuantity,
                    );
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Text('9'),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 6.0, 8.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadDeleteButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    _keypadController.text =
                        removeLastDigit(_keypadController.text);
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: const Image(
                    image: AssetImage('assets/images/delete.png'),
                    height: 15,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 6.0, 8.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadClearButtonKey,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPrimary: Colors.black,
                    primary: Colors.white,
                    textStyle: ECPTextStyles.keypadButtonsTextStyle,
                  ),
                  onPressed: () {
                    setState(_keypadController.clear);
                  },
                  buttonWidth: 70,
                  buttonHeight: 45,
                  child: Text(widget.clearButtonText),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 6.0, 8.0, 6.0),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 7.0,
                  ),
                ]),
                child: GeneralButton(
                  key: Keypad.keypadAddButtonKey,
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0.0),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.white;
                        }
                        return Colors.white;
                      },
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return UiuxColours.disabledButtonColour;
                        }
                        return UiuxColours.primaryColour;
                      },
                    ),
                    textStyle: MaterialStateProperty.all(
                        ECPTextStyles.keypadButtonsTextStyle),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_keypadController.text.isNotEmpty) {
                      if (widget.onClickAction == null) {
                        Navigator.pop(context, _keypadController.text);
                      } else {
                        await widget.onClickAction!(_keypadController.text);
                        setState(() {
                          _keypadController.text = '';
                        });
                      }
                    }
                  },
                  buttonWidth: 70,
                  buttonHeight: 103,
                  buttonDisabled: _keypadController.text.isEmpty,
                  child: Text(widget.confirmButtonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
