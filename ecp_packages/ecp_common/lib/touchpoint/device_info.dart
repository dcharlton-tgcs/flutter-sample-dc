part of '../ecp_common.dart';

class DeviceInfo {
  static String unsupportedPlatform = "Err::UnsupportedPlatform";

  static String getDeviceUUID() {
    if (Platform.isAndroid) {
      // TODO: Return UUID using package 'device_info_plus'

// Coverage ignored as Android platform not applicable for unit tests
// coverage:ignore-start
      return DateTime.now().toString();
// coverage:ignore-end
    } else {
      return unsupportedPlatform;
    }
  }
}
