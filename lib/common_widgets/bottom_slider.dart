import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';

class BottomSlider extends StatelessWidget {
  const BottomSlider({
    Key? key,
    this.width,
    this.height,
    required this.body,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    for (var element in ItemsListWidget.slidableControllers) {
      element.close();
    }
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          const DividerBottomSheetWidget(),
          body,
        ],
      ),
    );
  }
}
