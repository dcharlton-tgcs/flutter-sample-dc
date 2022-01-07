import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/common_widgets/generic_app_bar.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/processing/processing.dart';
import 'package:ui_flutter_app/pages/processing/processing_view.dart';

import '../../helpers/helpers.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('ProcessingPage', () {
    testWidgets(
        'Loading page has text, progress indicator '
        ' and generic app bar', (tester) async {
      await tester.pumpApp(const ProcessingPage());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('processing view has text and progress indicator',
        (tester) async {
      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const ProcessingView(),
      );

      await tester.pumpApp(widgetToTest);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.text('Processing transaction...'), findsOneWidget);
    });
  });
}
