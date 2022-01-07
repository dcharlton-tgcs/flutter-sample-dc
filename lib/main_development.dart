import 'package:auth_service/appauth/app_auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/client_context.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/number_symbols_data.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/app/app.dart';
import 'package:ui_flutter_app/app/app_bloc_observer.dart';
import 'package:ui_flutter_app/app/app_config.dart';
import 'package:ui_flutter_app/app/app_constants.dart';
import 'package:ui_flutter_app/app/app_routing.dart';
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Temporarily define keycloak parameters until onboarding process known
  Map<String, dynamic> _authParams = {
    AppAuthService.auth0DiscoveryUrl: '.well-known/openid-configuration',
    AppAuthService.auth0Authority: 'keycloak.platform.toshibacommerce.eu',
    AppAuthService.auth0Domain:
        'keycloak.platform.toshibacommerce.eu/auth/realms/ECP',
    AppAuthService.auth0UnencodedPath:
        '/auth/realms/ECP/protocol/openid-connect/token',
    AppAuthService.auth0ClientId: const String.fromEnvironment(
      'client_id',
      defaultValue: 'mobile-app',
    ),
    AppAuthService.auth0ClientSecret: const String.fromEnvironment(
      'client_secret',
      defaultValue: '',
    ),
    AppAuthService.auth0BundleId: 'com.tgcs.ecp.pos',
    AppAuthService.auth0Scopes: [
      'openid',
      'profile',
      'offline_access',
      'email'
    ],
  };

  // Default 'en' to European configuration
  numberFormatSymbols["en"] = AppConstants.english;

  var _deviceUUID = DeviceInfo.getDeviceUUID();

  var authService = AppAuthService();

  var uiPeripheralAgent = UiPeripheralAgent();
  uiPeripheralAgent.initialise();

  var _peripheralSessionId = 'mob_pos_app';
  var _printerIdentifier = 'FAKE_PRINTER';
  var _scannerIdentifier = 'INTERNAL_IMAGER1';

  var _clientContext = ClientContext(
      touchpointId: _deviceUUID, currencyCode: AppConstants.currencyCode);

  var _mainDevAppConfig = AppConfig(
    appName: 'ECP Front End',
    authParams: _authParams,
    authService: authService,
    flavorName: 'development',
    httpClient: http.Client(),
    initialRoute: AppRouting.welcome,
    peripheralAgent: uiPeripheralAgent,
    peripheralSessionId: _peripheralSessionId,
    posService: ECPPosService(
      clientContext: _clientContext,
      httpClient: http.Client(),
      ecpPosAddress: 'staging.platform.toshibacommerce.eu',
      timeout: 5,
      authService: authService,
    ),
    printerIdentifier: _printerIdentifier,
    scannerIdentifier: _scannerIdentifier,
    child: const App(),
  );

  BlocOverrides.runZoned(
    () => runApp(_mainDevAppConfig),
    blocObserver: AppBlocObserver(),
  );
}
