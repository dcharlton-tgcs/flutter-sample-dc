import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_common/helpers/app_locale.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('General Number Tests', () {
    test('currency code', () {
      UiuxNumber.setLocale();
      expect(UiuxNumber.currencyCode,
          ECPDeviceLocale.currencyFormat().currencyName);
    });
    test('Currency format test', () {
      UiuxNumber.setLocale();
      num a = 0;
      expect(
          UiuxNumber.currency(0),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(0));

      expect(
          UiuxNumber.currency(a),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(a));
      num b = 1.99;
      expect(
          UiuxNumber.currency(1.99),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(1.99));
      expect(
          UiuxNumber.currency(b),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(b));

      num c = 199;
      expect(
          UiuxNumber.currency(199),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(199));
      expect(
          UiuxNumber.currency(c),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(c));

      num d = 1999.500;
      expect(
          UiuxNumber.currency(1999.5),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(1999.5));
      expect(
          UiuxNumber.currency(d),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(d));

      var e = num.parse('1.99');
      expect(
          UiuxNumber.currency(1.99),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(1.99));
      expect(
          UiuxNumber.currency(e),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(e));

      double f = 1323.526;
      expect(
          UiuxNumber.currency(f),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(f));

      double g = 1323.524;
      expect(
          UiuxNumber.currency(g),
          NumberFormat.currency(
            locale: ECPDeviceLocale.currencyFormat().locale,
            symbol: ECPDeviceLocale.currencyFormat().currencySymbol,
            customPattern: '' " " '\u00a4 0',
          ).format(g));
    });
    test('set locale default', () {
      expect(ECPDeviceLocale.currencyFormat().locale, 'en_US');
      expect(ECPDeviceLocale.currencyFormat().currencySymbol, '\$');
      expect(ECPDeviceLocale.currencyFormat().currencyName, 'USD');
      UiuxNumber.setLocale();
      expect(UiuxNumber.currency(1.99), ' \$ 1.99');
      expect(UiuxNumber.locale, 'en_US');
      expect(UiuxNumber.symbol, '\$');
      expect(UiuxNumber.currencyCode, 'USD');
    });
    test('set locale eu', () {
      expect(ECPDeviceLocale.currencyFormat('eu').locale, 'eu');
      expect(ECPDeviceLocale.currencyFormat('eu').currencySymbol, '€');
      expect(ECPDeviceLocale.currencyFormat('eu').currencyName, 'EUR');
      UiuxNumber.setLocale(
        'eu',
      );
      expect(UiuxNumber.currency(1.99), ' € 1,99');
      expect(UiuxNumber.locale, 'eu');
      expect(UiuxNumber.symbol, '€');
      expect(UiuxNumber.currencyCode, 'EUR');
    });
    test('set locale en_GB', () {
      expect(ECPDeviceLocale.currencyFormat('en_GB').locale, 'en_GB');
      expect(ECPDeviceLocale.currencyFormat('en_GB').currencySymbol, '£');
      expect(ECPDeviceLocale.currencyFormat('en_GB').currencyName, 'GBP');
      UiuxNumber.setLocale(
        'en_GB',
      );
      expect(UiuxNumber.currency(1.99), ' £ 1.99');
      expect(UiuxNumber.locale, 'en_GB');
      expect(UiuxNumber.symbol, '£');
      expect(UiuxNumber.currencyCode, 'GBP');
    });
  });
}
