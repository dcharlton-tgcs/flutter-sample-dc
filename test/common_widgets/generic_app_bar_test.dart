import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/common_widgets/generic_app_bar.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}

void main() {
  testWidgets('Localisation Test: All supported languages', (tester) async {
    var language = <String>['en', 'es', 'de'];
    var textFind = <String>['Counter', 'Contador', 'Buchhalter'];

    for (var i = 0; i < 3; i++) {
      Widget widgetToTest = Localizations(
        locale: Locale(language[i]),
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: Scaffold(body: GenericAppBar(title: Text(textFind[i]))),
      );
      await tester.pumpApp(widgetToTest);
      await tester.pumpAndSettle();
      expect(find.text(textFind[i]), findsOneWidget);
    }
  });
}
