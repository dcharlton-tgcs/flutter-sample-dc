import 'package:ecp_common/ecp_common.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Device Information Tests:', () {
    test('Obtaining Device Info', () {
      var deviceInfo = DeviceInfo.getDeviceUUID();
      // Unit tests won't return valid Android identifier
      expect(deviceInfo, DeviceInfo.unsupportedPlatform);
    });
  });
}
