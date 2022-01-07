import 'package:auth_service/fake_auth_service.dart';
import 'package:ecp_openapi/model/client_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:pos_service/fake_pos_service.dart';
import 'package:ui_flutter_app/app/app_config.dart';
import 'package:ui_flutter_app/app/app_routing.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

class FakeClient extends Fake implements http.Client {}

extension PumpApp on WidgetTester {
  static const _clientContext =
      ClientContext(touchpointId: 'UnitTest1234', currencyCode: 'EUR');

  Future<void> pumpApp(Widget widget) {
    var peripheralAgent = UiPeripheralAgent();
    peripheralAgent.initialise();
    return pumpWidget(
      AppConfig(
        appName: 'ECP Front End',
        authParams: const {},
        authService: FakeAuthService(),
        flavorName: 'UnitTesting',
        httpClient: FakeClient(),
        initialRoute: 'initialRoute',
        peripheralAgent: peripheralAgent,
        peripheralSessionId: 'mobile-pos-test',
        posService: FakePosService(clientContext: _clientContext),
        printerIdentifier: 'FAKE_PRINTER',
        scannerIdentifier: 'FAKE_SCANNER',
        child: MaterialApp(
          home: widget,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          onGenerateRoute: AppRouting.onGenerateRoute,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: UiuxTheme.defaultTheme,
        ),
      ),
    );
  }
}
