part of '../ecp_common.dart';

class UiuxNumber {
  static String currencyCode =
      ECPDeviceLocale.currencyFormat().currencyName.toString();

  static String locale = ECPDeviceLocale.currencyFormat().locale;
  static String symbol = ECPDeviceLocale.currencyFormat().currencySymbol;

  static void setLocale([String? localeName]) {
    locale = ECPDeviceLocale.currencyFormat(localeName).locale;
    symbol = ECPDeviceLocale.currencyFormat(localeName).currencySymbol;
    currencyCode =
        ECPDeviceLocale.currencyFormat(localeName).currencyName.toString();
  }

  static String currency(dynamic number) {
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      customPattern: '' " " '\u00a4 0',
    ).format(number);
  }
}
