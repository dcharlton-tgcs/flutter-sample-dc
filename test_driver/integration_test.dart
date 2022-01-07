import 'package:integration_test/integration_test_driver.dart'
    as integ_test_driver;

/*
    integration_test_driver_extended also available which permits a callback
    capture of onScreenshot: event.  Here you can copy the screenshot
    to a known folder.

    However, this driver implementation does not manage timeouts and
    general screenshot capability is not working properly with the 
    bindings.  

    Waiting for Flutter team to complete this functionality before 
    using this approach.
  */

Future<void> main() {
  // Directory where all integration test reports will be saved
  // Currently a bug in Flutter integrationDriver which saves 'null' to
  // the report rather than the report data.
  integ_test_driver.testOutputsDirectory = 'integration_test/reports';

  return integ_test_driver.integrationDriver(
    // Maximum permitted time for all tests to complete
    timeout: const Duration(minutes: 90),
  );
}
