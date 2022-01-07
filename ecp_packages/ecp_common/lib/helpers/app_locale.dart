import 'dart:io';
import 'package:intl/intl.dart';

class ECPDeviceLocale {
  static NumberFormat currencyFormat([String? localeName]) =>
      NumberFormat.simpleCurrency(locale: localeName ?? Platform.localeName);
}
