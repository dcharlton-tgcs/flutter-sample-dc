import 'dart:math';

import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_common/helpers/model_helper.dart';
import 'package:ecp_openapi/model/package.dart';
import 'package:pos_service/pos_service.dart';

class FakePosService implements PosService {
  FakePosService({required this.clientContext}) : super();

  final ClientContext clientContext;

  Random random = Random();

  @override
  Future<Checkout> addItem(
    Checkout checkout,
    String barcode,
    String symbology,
    int quantity,
    String entryMethod,
  ) async {
    var itemMetadata = Metadata(
        modelVersion: '0.0.1',
        entityVersion: 1,
        creationTimestamp: DateTime.now(),
        lastModificationTimestamp: DateTime.now(),
        lastModificationUser: 'testData');

    var newOrderMetadata = getMetadata(checkout.metadata);

    var orderItems = [];

    for (int i = 0; i < checkout.posOrder.items.length; i++) {
      orderItems.add(checkout.posOrder.items[i]);
    }

    Map<String, MultilingualText> description = {
      'default': MultilingualText(
        languageCode: 'default',
        text: 'Item_Desc_$barcode',
      )
    };

    var catalogId = _getRandomHex(4) +
        '-' +
        _getRandomHex(2) +
        '-' +
        _getRandomHex(2) +
        '-' +
        _getRandomHex(2) +
        '-' +
        _getRandomHex(6);

    CatalogItem newItem = CatalogItem(
      catalogId: catalogId,
      catalogItemId: barcode,
      description: description,
      aliases: List.empty(),
      quantityRequired: false,
      quantityAllowed: false,
      minimumQuantity: 0,
      maximumQuantity: 0,
      quantityChangeAllowed: false,
      salesUnitOfMeasure: '',
      priceEntryRequired: false,
      priceChangeAllowed: false,
      priceChangeMinimumAmount: 0,
      priceChangeMaximumAmount: 0,
      blockedForSale: false,
      customerMinimumAge: 0,
      operatorMinimumAge: 0,
      linkedItems: List.empty(),
      depositItem: false,
      negativePrice: false,
      unitPrice: 0,
      metadata: itemMetadata,
      attributes: {},
    );

    var unitPrice = random.nextDouble() * 12.0;
    OrderItem orderItem = OrderItem(
      orderItemId: _getRandomHex(12),
      item: newItem,
      quantity: quantity,
      unitPrice: unitPrice,
      amount: (quantity * unitPrice),
      amountWithoutTax: 0,
      taxes: List.empty(),
      voided: false,
      entryData: '123456',
      entryMethod: EntryMethod.SCANNED,
      attributes: {},
      parentOrderItemId: '',
      currencyCode: UiuxNumber.currencyCode,
      measuredUnits: 1.0,
    );

    orderItems.add(orderItem);

    num _totalAmount = 0.0;
    num _itemCount = 0;
    for (int i = 0; i < orderItems.length; i++) {
      if (!orderItems[i].voided) {
        if (orderItems[i].amount != null) {
          _totalAmount += orderItems[i].amount;
        }
        if (orderItems[i].quantity != null) {
          _itemCount += orderItems[i].quantity;
        }
      }
    }

    var newTotal = OrderTotal(
      amount: _totalAmount,
      totalItemQuantity: _itemCount.toInt(),
      discountAmount: 0,
      amountWithoutTax: 0,
      taxes: List.empty(),
      changeDue: 0,
      paidAmount: 0,
      currencyCode: UiuxNumber.currencyCode,
    );

    var newOrder = PosOrder(
      orderId: checkout.posOrder.orderId,
      metadata: newOrderMetadata,
      items: orderItems.cast<OrderItem>(),
      totals: newTotal,
      payments: checkout.posOrder.payments,
      state: checkout.posOrder.state,
      attributes: {},
      currencyCode: UiuxNumber.currencyCode,
    );

    var newCheckout = Checkout(
        checkoutId: checkout.checkoutId,
        touchpointId: checkout.touchpointId,
        metadata: newOrderMetadata,
        state: checkout.state,
        posOrder: newOrder);

    return newCheckout;
  }

  @override
  Future<Checkout> addPayment(
    Checkout checkout,
    String tenderId,
    double amount,
  ) async {
    Tender _tender = Tender(
      tenderId: tenderId,
      description: {},
      currencyCode: clientContext.currencyCode,
      attributes: {},
    );

    CurrencyAmount authorizedAmount = CurrencyAmount(
      amount: 1.00,
      currencyCode: clientContext.currencyCode,
    );

    OrderPayment _payment = OrderPayment(
      orderPaymentId: '1',
      authorizedAmount: authorizedAmount,
      tender: _tender,
      voided: false,
      attributes: {},
    );

    var paymentList = List.from(checkout.posOrder.payments);
    paymentList.add(_payment);

    OrderTotal _totals = OrderTotal(
      discountAmount: checkout.posOrder.totals.discountAmount,
      amountWithoutTax: checkout.posOrder.totals.amountWithoutTax,
      amount: checkout.posOrder.totals.amountWithoutTax,
      paidAmount: checkout.posOrder.totals.paidAmount + authorizedAmount.amount,
      changeDue: checkout.posOrder.totals.changeDue + authorizedAmount.amount,
      totalItemQuantity: checkout.posOrder.totals.totalItemQuantity,
      taxes: checkout.posOrder.totals.taxes,
      currencyCode: checkout.posOrder.totals.currencyCode,
    );

    PosOrder _posOrder = PosOrder(
      metadata: getMetadata(checkout.posOrder.metadata),
      orderId: checkout.posOrder.orderId,
      items: checkout.posOrder.items,
      payments: paymentList,
      totals: _totals,
      state: checkout.posOrder.state,
      attributes: checkout.posOrder.attributes,
      currencyCode: checkout.posOrder.currencyCode,
    );

    Checkout _checkout = Checkout(
      checkoutId: checkout.checkoutId,
      touchpointId: checkout.touchpointId,
      metadata: getMetadata(checkout.metadata),
      state: checkout.state,
      posOrder: _posOrder,
    );
    return _checkout;
  }

  @override
  Future<Checkout> cancelCheckout(
    Checkout checkout,
  ) async {
    PosOrder _posOrder = PosOrder(
      metadata: getMetadata(checkout.posOrder.metadata),
      orderId: checkout.posOrder.orderId,
      items: checkout.posOrder.items,
      payments: checkout.posOrder.payments,
      totals: checkout.posOrder.totals,
      state: OrderState.CANCELLED,
      attributes: checkout.posOrder.attributes,
      currencyCode: checkout.posOrder.currencyCode,
    );

    Checkout _checkout = Checkout(
      checkoutId: checkout.checkoutId,
      touchpointId: checkout.touchpointId,
      metadata: getMetadata(checkout.metadata),
      state: CheckoutState.FINISHED,
      posOrder: _posOrder,
    );
    return _checkout;
  }

  @override
  Future<Checkout> changeItemQuantity(
    Checkout checkout,
    String orderItemId,
    int quantity,
  ) async {
    var checkoutItems = [];

    var newCheckoutMetadata = getMetadata(checkout.metadata);

    for (int i = 0; i < checkout.posOrder.items.length; i++) {
      if (checkout.posOrder.items[i].orderItemId == orderItemId) {
        num _unitPrice = checkout.posOrder.items[i].unitPrice;
        num _amount = _unitPrice * quantity;
        OrderItem updatedItem = OrderItem(
          orderItemId: orderItemId,
          item: checkout.posOrder.items[i].item,
          quantity: quantity,
          unitPrice: _unitPrice,
          amount: _amount,
          amountWithoutTax: 0,
          taxes: List.empty(),
          voided: false,
          entryData: checkout.posOrder.items[i].entryData,
          entryMethod: checkout.posOrder.items[i].entryMethod,
          attributes: {},
          parentOrderItemId: '',
          currencyCode: UiuxNumber.currencyCode,
          measuredUnits: 1.0,
        );
        checkoutItems.add(updatedItem);
      } else {
        checkoutItems.add(checkout.posOrder.items[i]);
      }
    }

    num _totalAmount = 0.0;
    num _itemCount = 0;
    for (int i = 0; i < checkoutItems.length; i++) {
      bool _voided = checkoutItems[i].voided;
      if (!_voided) {
        if (checkoutItems[i].amount != null) {
          _totalAmount += checkoutItems[i].amount;
        }
        if (checkoutItems[i].quantity != null) {
          _itemCount += checkoutItems[i].quantity;
        }
      }
    }

    var newTotal = OrderTotal(
      amount: _totalAmount,
      totalItemQuantity: _itemCount.toInt(),
      discountAmount: 0,
      amountWithoutTax: 0,
      taxes: List.empty(),
      changeDue: 0,
      paidAmount: 0,
      currencyCode: UiuxNumber.currencyCode,
    );

    var newPosOrder = PosOrder(
      orderId: checkout.posOrder.orderId,
      metadata: newCheckoutMetadata,
      items: checkoutItems.cast<OrderItem>(),
      totals: newTotal,
      payments: checkout.posOrder.payments,
      state: checkout.posOrder.state,
      attributes: {},
      currencyCode: UiuxNumber.currencyCode,
    );

    var newCheckout = Checkout(
        checkoutId: checkout.checkoutId,
        touchpointId: checkout.touchpointId,
        metadata: newCheckoutMetadata,
        state: checkout.state,
        posOrder: newPosOrder);

    return newCheckout;
  }

  @override
  Future<Checkout> finishCheckout(Checkout checkout) async {
    PosOrder _posOrder = PosOrder(
      metadata: getMetadata(checkout.posOrder.metadata),
      orderId: checkout.posOrder.orderId,
      items: checkout.posOrder.items,
      payments: checkout.posOrder.payments,
      totals: checkout.posOrder.totals,
      state: OrderState.COMPLETED,
      attributes: checkout.posOrder.attributes,
      currencyCode: checkout.posOrder.currencyCode,
    );

    Checkout _checkout = Checkout(
      checkoutId: checkout.checkoutId,
      touchpointId: checkout.touchpointId,
      metadata: getMetadata(checkout.metadata),
      state: CheckoutState.FINISHED,
      posOrder: _posOrder,
    );
    return _checkout;
  }

  @override
  Future<Checkout> startNewCheckout() async {
    PosOrder _posOrder = PosOrder(
      metadata: getMetadata(ModelHelper.emptyMetadata),
      orderId: _getRandomHex(12),
      items: List.empty(),
      payments: List.empty(),
      totals: OrderTotal.empty,
      state: ModelHelper.emptyOrderState,
      attributes: {},
      currencyCode: UiuxNumber.currencyCode,
    );

    Checkout _checkout = Checkout(
      checkoutId: '1',
      touchpointId: '1',
      metadata: getMetadata(Metadata.empty),
      state: CheckoutState.ACTIVE,
      posOrder: _posOrder,
    );
    return _checkout;
  }

  @override
  Future<Checkout> voidItem(Checkout checkout, String orderItemId) async {
    var checkoutItems = [];

    var newOrderMetadata = getMetadata(checkout.metadata);

    for (int i = 0; i < checkout.posOrder.items.length; i++) {
      if (checkout.posOrder.items[i].orderItemId == orderItemId) {
        OrderItem updatedItem = OrderItem(
          orderItemId: orderItemId,
          item: checkout.posOrder.items[i].item,
          quantity: checkout.posOrder.items[i].quantity,
          unitPrice: checkout.posOrder.items[i].unitPrice,
          amount: checkout.posOrder.items[i].amount,
          amountWithoutTax: 0,
          taxes: List.empty(),
          voided: true,
          entryData: checkout.posOrder.items[i].entryData,
          entryMethod: checkout.posOrder.items[i].entryMethod,
          attributes: {},
          parentOrderItemId: '',
          currencyCode: UiuxNumber.currencyCode,
          measuredUnits: 1.0,
        );
        checkoutItems.add(updatedItem);
      } else {
        checkoutItems.add(checkout.posOrder.items[i]);
      }
    }

    num _totalAmount = 0.0;
    num _itemCount = 0;
    for (int i = 0; i < checkoutItems.length; i++) {
      bool _voided = checkoutItems[i].voided;
      if (!_voided) {
        if (checkoutItems[i].amount != null) {
          _totalAmount += checkoutItems[i].amount;
        }
        if (checkoutItems[i].quantity != null) {
          _itemCount += checkoutItems[i].quantity;
        }
      }
    }

    var newTotal = OrderTotal(
      amount: _totalAmount,
      totalItemQuantity: _itemCount.toInt(),
      discountAmount: 0,
      amountWithoutTax: 0,
      taxes: List.empty(),
      changeDue: 0,
      paidAmount: 0,
      currencyCode: UiuxNumber.currencyCode,
    );

    var newPosOrder = PosOrder(
      orderId: checkout.posOrder.orderId,
      metadata: newOrderMetadata,
      items: checkoutItems.cast<OrderItem>(),
      totals: newTotal,
      payments: checkout.posOrder.payments,
      state: checkout.posOrder.state,
      attributes: {},
      currencyCode: UiuxNumber.currencyCode,
    );

    Checkout _checkout = Checkout(
      checkoutId: '1',
      touchpointId: '1',
      metadata: getMetadata(checkout.metadata),
      state: CheckoutState.ACTIVE,
      posOrder: newPosOrder,
    );
    return _checkout;
  }

  Metadata getMetadata(final Metadata o) {
    var existingEntityVersion = o.entityVersion;

    if (existingEntityVersion >= 0) {
      existingEntityVersion = existingEntityVersion + 1;
    }

    Metadata m = Metadata(
      entityVersion: existingEntityVersion,
      modelVersion: '1',
      creationTimestamp: DateTime.parse('2021-08-01 10:10:00'),
      lastModificationTimestamp: DateTime.parse('2021-08-01 10:10:30'),
      lastModificationUser: '',
    );

    return m;
  }

  String _getRandomHex(int len) {
    String chars = '0123456789ABCDEF';
    var s = '';
    while (s.length < len) {
      s += chars[(random.nextInt(16)) | 0];
    }
    return s;
  }
}
