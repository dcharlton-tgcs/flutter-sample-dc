import 'package:flutter/material.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class DividerBottomSheetWidget extends StatelessWidget {
  const DividerBottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
        bottom: 10.0,
      ),
      width: 60,
      child: Container(
        height: 4, // Thickness
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: UiuxColours.dividerColor,
        ),
      ),
    );
  }
}
