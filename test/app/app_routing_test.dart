import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/app/app_routing.dart';

void main() {
  group('Testing routing', () {
    test('Check if routing map is not empty', () {
      final routes = AppRouting.define();
      expect(routes.isNotEmpty, true);
    });

    test('Verify if routing map contains specific keys', () {
      final routes = AppRouting.define();
      expect(routes.containsKey(AppRouting.login), true);
      expect(routes.containsKey(AppRouting.welcome), true);
      expect(routes.containsKey(AppRouting.basket), true);
      expect(routes.containsKey(AppRouting.transactionCompleted), true);
    });
  });
}
