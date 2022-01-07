import 'package:ecp_common/helpers/model_helper.dart';
import 'package:ecp_openapi/model/order_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test the model helper class', () {
    test('Test Metadata model', () {
      var metadata = ModelHelper.emptyMetadata;

      expect(metadata.modelVersion, '');
      expect(metadata.entityVersion, 0);
      expect(metadata.creationTimestamp, DateTime.parse('2021-08-01 10:10:00'));
      expect(metadata.lastModificationTimestamp,
          DateTime.parse('2021-08-01 10:10:00'));
      expect(metadata.lastModificationUser, '');
    });

    test('Test Order State model', () {
      var orderState = ModelHelper.emptyOrderState;

      expect(orderState, OrderState.CHECKOUT);
    });
  });
}
