import 'package:flutter/material.dart';

part 'button_styles.dart';
part 'colours.dart';
part 'fonts.dart';
part 'icons.dart';
part 'images.dart';
part 'text_styles.dart';

class UiuxTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      primaryColor: UiuxColours.primaryColour,
      scaffoldBackgroundColor: UiuxColours.backgroundColour,
      backgroundColor: UiuxColours.backgroundColour,
      fontFamily: UiuxFonts.avenirMediumFont,
      bottomSheetTheme: const BottomSheetThemeData(
        modalBackgroundColor: UiuxColours.backgroundColour,
        backgroundColor: UiuxColours.backgroundColour,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
      textTheme: const TextTheme(
        subtitle1: TextStyle(
          fontSize: 18.0,
          color: UiuxColours.primaryTextColor,
        ),
        subtitle2: TextStyle(
          fontSize: 16.0,
          color: UiuxColours.primaryTextColor,
        ),
        bodyText1: TextStyle(
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
          color: UiuxColours.listTextColor,
          fontFamily: UiuxFonts.avenirLightObliqueFont,
          fontWeight: FontWeight.w400,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          color: UiuxColours.primaryTextColor,
        ),
        button: TextStyle(
          fontSize: 14.0,
          color: UiuxColours.primaryButtonTextColour,
        ),
      ),
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get primaryButtonText {
    return const TextStyle(
      color: UiuxColours.primaryButtonTextColour,
    );
  }

  TextStyle get secondaryButtonText {
    return const TextStyle(
      color: UiuxColours.secondaryButtonTextColour,
    );
  }

  TextStyle get bodyText3 {
    return const TextStyle(
      fontSize: 12.0,
      color: UiuxColours.primaryTextColor,
    );
  }

  TextStyle get strikeThoughText {
    return const TextStyle(
      fontSize: 14.0,
      decoration: TextDecoration.lineThrough,
      color: UiuxColours.voidedListTextColor,
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle get linkedItemPriceTextStyle {
    return const TextStyle(
      fontSize: 12.0,
    );
  }

  TextStyle get strikeThoughTextLinkedItem {
    return const TextStyle(
      fontSize: 12.0,
      decoration: TextDecoration.lineThrough,
      color: UiuxColours.voidedListTextColor,
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle get keypadQuantityText {
    return const TextStyle(
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle get alertLabelText {
    return const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get strikeThoughItemDescriptionText {
    return const TextStyle(
      fontSize: 16.0,
      decoration: TextDecoration.lineThrough,
      color: UiuxColours.voidedListTextColor,
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle get normalItemDescriptionText {
    return const TextStyle(
      fontSize: 16.0,
      color: UiuxColours.primaryTextColor,
    );
  }

  TextStyle get strikeThoughCaptionText {
    return const TextStyle(
      fontSize: 12.0,
      decoration: TextDecoration.lineThrough,
      color: UiuxColours.voidedListTextColor,
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle get bodyText2Underlined {
    return const TextStyle(
      fontSize: 14.0,
      decoration: TextDecoration.underline,
      color: UiuxColours.primaryTextColor,
    );
  }
}
