import 'dart:async';

import 'package:flutter/services.dart';

// TODO: Setup proper implementations
abstract class EcpLogger {
  static const MethodChannel _channel = MethodChannel('ecp_logger');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> log(String message);
}
