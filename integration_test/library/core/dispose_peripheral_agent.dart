import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

Future<void> disposePeripheralAgent(UiPeripheralAgent peripheralAgent) async {
  var printerIdentifier = 'FAKE_PRINTER';
  var scannerIdentifier = 'FAKE_SCANNER';

  await peripheralAgent.disablePeripheral(printerIdentifier);
  await peripheralAgent.disablePeripheral(scannerIdentifier);
  await peripheralAgent.releasePeripheral(printerIdentifier);
  await peripheralAgent.releasePeripheral(scannerIdentifier);
  await peripheralAgent.closePeripheral(printerIdentifier);
  await peripheralAgent.closePeripheral(scannerIdentifier);
}
