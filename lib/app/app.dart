import 'dart:developer';

import 'package:auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/app/app_config.dart';
import 'package:ui_flutter_app/app/app_routing.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/launcher/launch.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);

    var authService = appConfig.authService;
    var posService = appConfig.posService;

    initialiseAuthService(appConfig);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authService),
        ),
        BlocProvider<PosCubit>(
          create: (context) => PosCubit(posService),
        ),
        BlocProvider<PeripheralCubit>(
          create: (context) => PeripheralCubit(
            appConfig.peripheralAgent,
            appConfig.peripheralSessionId,
          ),
        ),
        BlocProvider<PrinterCubit>(
          create: (context) => PrinterCubit(
            appConfig.peripheralAgent,
            appConfig.peripheralSessionId,
            appConfig.printerIdentifier,
          ),
        ),
        BlocProvider<ScannerCubit>(
          create: (context) => ScannerCubit(
            appConfig.peripheralAgent,
            appConfig.peripheralSessionId,
            appConfig.scannerIdentifier,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LaunchPage(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        onGenerateRoute: AppRouting.onGenerateRoute,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: UiuxTheme.defaultTheme,
      ),
    );
  }

  void initialiseAuthService(AppConfig appConfig) async {
    try {
      await appConfig.authService.initialise(
        appConfig.authParams,
        appConfig.httpClient,
      );
    } on EndpointAccessException {
      log('App initialisation failed on AppAuth. Future attempts on login()');
    }
  }
}
