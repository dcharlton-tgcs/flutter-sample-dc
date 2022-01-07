import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/checkout_state.dart';
import 'package:ecp_openapi/model/client_context.dart';
import 'package:ecp_openapi/model/entry_method.dart';
import 'package:ecp_openapi/model/order_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_service/fake_pos_service.dart' show FakePosService;

void main() {
  late FakePosService _posService;

  setUp(() {
    var clientContext = ClientContext(
      touchpointId: 'Test1234',
      currencyCode: UiuxNumber.currencyCode,
    );
    _posService = FakePosService(clientContext: clientContext);
  });

  group('Fake Pos Service Tests: ', () {
    test('Add items', () async {
      Checkout? checkout0 = await _posService.startNewCheckout();
      Checkout? checkout1 = await _posService.addItem(
        checkout0,
        '123',
        '456',
        1,
        EntryMethod.SCANNED.value,
      );

      expect(checkout1.posOrder.items.length, 1);
      expect(checkout1.metadata.entityVersion, 2);

      checkout1 = await _posService.addItem(
        checkout1,
        '999',
        '888',
        1,
        EntryMethod.SCANNED.value,
      );

      expect(checkout1.posOrder.items.length, 2);
      expect(checkout1.metadata.entityVersion, 3);

      num ta = 0;
      for (int i = 0; i < checkout1.posOrder.items.length; i++) {
        ta += checkout1.posOrder.items[i].amount;
      }
      expect(ta, greaterThan(0));
    });

    test('addPayment', () async {
      Checkout? _checkout = await _posService.startNewCheckout();

      Checkout? _checkoutPaid =
          await _posService.addPayment(_checkout, '1', 1.00);

      expect(_checkoutPaid.state, CheckoutState.ACTIVE);
      expect(_checkoutPaid.posOrder.state, OrderState.CHECKOUT);
      expect(_checkoutPaid.metadata.entityVersion, 2);
      expect(_checkoutPaid.posOrder.payments[0].authorizedAmount.amount, 1.00);
      expect(_checkoutPaid.posOrder.payments[0].tender.tenderId, '1');
    });

    test('cancelCheckout', () async {
      Checkout? _checkout = await _posService.startNewCheckout();

      Checkout? _checkoutCancelled = await _posService.cancelCheckout(
        _checkout,
      );

      expect(_checkoutCancelled.state, CheckoutState.FINISHED);
      expect(_checkoutCancelled.posOrder.state, OrderState.CANCELLED);
      expect(_checkoutCancelled.metadata.entityVersion, 2);
      expect(_checkoutCancelled.posOrder.metadata.entityVersion, 2);
    });

    test('Change item quantity', () async {
      Checkout? checkout0 = await _posService.startNewCheckout();
      Checkout? checkout1 = await _posService.addItem(
        checkout0,
        '123',
        '456',
        1,
        EntryMethod.SCANNED.value,
      );
      Checkout? checkout2 = await _posService.addItem(
        checkout1,
        '321',
        '654',
        1,
        EntryMethod.SCANNED.value,
      );
      Checkout? checkout3 = await _posService.changeItemQuantity(
          checkout2, checkout2.posOrder.items.first.orderItemId, 5);

      expect(checkout3.posOrder.items.length, 2);
      expect(checkout3.metadata.entityVersion, 4);
      expect(checkout3.posOrder.totals.totalItemQuantity, 6);

      checkout3 = await _posService.changeItemQuantity(
          checkout3, checkout3.posOrder.items.first.orderItemId, 3);

      expect(checkout3.posOrder.items.length, 2);
      expect(checkout3.metadata.entityVersion, 5);
      expect(checkout3.posOrder.totals.totalItemQuantity, 4);

      num ta = 0;
      for (int i = 0; i < checkout3.posOrder.items.length; i++) {
        ta += checkout3.posOrder.items[i].amount;
      }
      expect(ta, greaterThan(0));
    });

    test('finishCheckout', () async {
      Checkout? _checkout = await _posService.startNewCheckout();

      Checkout? _checkoutFinished = await _posService.finishCheckout(
        _checkout,
      );

      expect(_checkoutFinished.state, CheckoutState.FINISHED);
      expect(_checkoutFinished.posOrder.state, OrderState.COMPLETED);
      expect(_checkoutFinished.metadata.entityVersion, 2);
      expect(_checkoutFinished.posOrder.metadata.entityVersion, 2);
    });

    test('startNewCheckout', () async {
      Checkout? _checkout = await _posService.startNewCheckout();

      expect(_checkout.state, CheckoutState.ACTIVE);
      expect(_checkout.posOrder.state, OrderState.CHECKOUT);
      expect(_checkout.metadata.entityVersion, 1);
      expect(_checkout.posOrder.metadata.entityVersion, 1);
      expect(
        _checkout.metadata.creationTimestamp,
        DateTime.parse('2021-08-01 10:10:00'),
      );
      expect(
        _checkout.metadata.lastModificationTimestamp,
        DateTime.parse('2021-08-01 10:10:30'),
      );
      expect(_checkout.metadata.lastModificationUser, '');
    });

    test('Void Item', () async {
      Checkout? c1 = await _posService.startNewCheckout();
      Checkout? c2 = await _posService.addItem(
        c1,
        '123',
        '456',
        1,
        EntryMethod.MANUAL.value,
      );
      Checkout? c3 = await _posService.addItem(
        c2,
        '321',
        '654',
        1,
        EntryMethod.MANUAL.value,
      );

      expect(c3.posOrder.items.length, 2);
      expect(c3.metadata.entityVersion, 3);
      expect(c3.posOrder.totals.totalItemQuantity, 2);

      Checkout? c4 = await _posService.voidItem(
        c3,
        c3.posOrder.items.first.orderItemId,
      );

      expect(c4.posOrder.items.length, 2);
      expect(c4.metadata.entityVersion, 4);
      expect(c4.posOrder.totals.totalItemQuantity, 1);
      expect(c4.posOrder.items.first.voided, true);

      num ta = 0;
      for (int i = 0; i < c4.posOrder.items.length; i++) {
        ta += c4.posOrder.items[i].amount;
      }
      expect(ta, greaterThan(0));
    });
  });
}
