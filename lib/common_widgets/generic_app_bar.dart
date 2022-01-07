import 'package:flutter/material.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class GenericAppBar extends AppBar {
  GenericAppBar({
    Key? key,
    Widget? title,
    bool implyLeading = false,
    List<Widget>? actions,
    bool centerTitle = true,
    TextStyle? titleTextStyle,
  }) : super(
          backgroundColor: UiuxColours.appBarColour,
          key: key,
          title: title,
          automaticallyImplyLeading: implyLeading,
          //now matching with height of wireframes
          toolbarHeight: 51,
          actions: actions,
          centerTitle: centerTitle,
          titleTextStyle: titleTextStyle,
        );
}
