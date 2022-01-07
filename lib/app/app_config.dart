import 'package:auth_service/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pos_service/pos_service.dart';
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

// coverage:ignore-file
class AppConfig extends InheritedWidget {
  const AppConfig({
    Key? key,
    required this.appName,
    required this.initialRoute,
    required this.authParams,
    required this.flavorName,
    required this.httpClient,
    required this.authService,
    required this.posService,
    required this.peripheralAgent,
    required this.peripheralSessionId,
    required this.printerIdentifier,
    required this.scannerIdentifier,
    required Widget child,
  }) : super(key: key, child: child);

  final String appName;
  final Map<String, dynamic> authParams;
  final String flavorName;
  final http.Client httpClient;
  final String initialRoute;
  final AuthService authService;
  final PosService posService;
  final UiPeripheralAgent peripheralAgent;
  final String peripheralSessionId;
  final String printerIdentifier;
  final String scannerIdentifier;

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>() as AppConfig;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
