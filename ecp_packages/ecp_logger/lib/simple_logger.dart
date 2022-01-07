import 'dart:developer' as dev;

import 'package:ecp_logger/ecp_logger.dart';

class SimpleLogger extends EcpLogger {
  SimpleLogger._();

  @override
  Future<void> log(String message) async {
    dev.log(message);
  }
}
