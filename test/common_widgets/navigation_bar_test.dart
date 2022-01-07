import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/generic_app_bar.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/l10n/l10n.dart';

import '../helpers/pump_bloc_app.dart';

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PosCubit posCubit;

  group('Navigation bar', () {
    setUp(() {
      posCubit = MockPosCubit();
    });

    testWidgets('Navigation Bar test', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
      ];
      Widget widgetToTest = Localizations(
        locale: const Locale('en'),
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: Scaffold(
          body: GenericAppBar(),
          bottomNavigationBar:
              const ecp_nav_bar.NavigationBar(key: Key('test_nav_bar_key')),
        ),
      );
      await tester.pumpBlocApp(widgetToTest, providers);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('test_nav_bar_key')), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(4));
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Basket page'), findsOneWidget);
      expect(find.text('Keypad'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
    });

    testWidgets('quick test', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
      ];
      var a = const ecp_nav_bar.NavigationBar();
      var b = const ecp_nav_bar.NavigationBar(key: Key('test1'));
      expect(a == b, false);
      await tester.pumpBlocApp(
          const ecp_nav_bar.NavigationBar(key: Key('test2')), providers);
      expect(find.byType(Icon), findsWidgets);
    });
  });
}
