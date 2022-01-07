import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:integration_test/integration_test.dart';

import 'basket/scenarios.dart' as basket_scenarios;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Setup suite list for randomly running test cases
  var suiteList = [];
  suiteList.addAll(basket_scenarios.scenarioList);

  // Randomise the tests if requested
  const randomiseTests =
      String.fromEnvironment('randomise_tests', defaultValue: 'false');
  if (randomiseTests == 'true') {
    suiteList.shuffle();
  }

  // Speed up animations if requested
  const fastAnim = String.fromEnvironment('fast_anim', defaultValue: 'false');
  if (fastAnim == 'true') {
    timeDilation = 0.05;
  }

  // Execute the scenarios
  for (final suite in suiteList) {
    suite();
  }
}
