import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:ecp_openapi/model/ecp_error.dart';
import 'package:ecp_openapi/model/ecp_message.dart';
import 'package:ecp_openapi/model/ecp_message_key.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'helpers/app_locale.dart';

part 'ecp_exception.dart';

part 'helpers/ecp_error_handler.dart';

part 'model/number_model.dart';

part 'touchpoint/device_info.dart';

class EcpCommon {
  static const MethodChannel _channel = MethodChannel('ecp_common');

  static Future<String?> get platformVersion async {
    var version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
