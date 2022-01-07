import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

Future<void> scanBarcode(
    UiPeripheralAgent peripheralAgent, String symbology, String barcode) async {
  var peripheral = 'FAKE_SCANNER';
  Map<String, String> data = {'labelType': symbology, 'data': barcode};
  await peripheralAgent.enableSoftScan(peripheral);
  await peripheralAgent.directIO(peripheral, 'simulateScanData', data);
  await peripheralAgent.disableSoftScan(peripheral);
}
