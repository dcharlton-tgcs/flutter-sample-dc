import 'package:intl/number_symbols.dart';

// coverage:ignore-file
class AppConstants {
  AppConstants._();

  static const currencyCode = 'EUR';

  static const english = NumberSymbols(
      NAME: "en",
      DECIMAL_SEP: ',',
      GROUP_SEP: '.',
      PERCENT: '%',
      ZERO_DIGIT: '0',
      PLUS_SIGN: '+',
      MINUS_SIGN: '\u2212',
      EXP_SYMBOL: 'E',
      PERMILL: '\u2030',
      INFINITY: '\u221E',
      NAN: 'NaN',
      DECIMAL_PATTERN: '#,##0.###',
      SCIENTIFIC_PATTERN: '#E0',
      PERCENT_PATTERN: '%\u00A0#,##0',
      CURRENCY_PATTERN: '#,##0.00\u00A0\u00A4',
      DEF_CURRENCY_CODE: AppConstants.currencyCode);
}
