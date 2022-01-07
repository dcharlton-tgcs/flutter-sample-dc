import 'dart:convert';

import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/ecp_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_service/pos_service.dart';

import '../mock_service_data.dart';

void main() {
  test('test pos error state', () {
    var a = PosCheckoutError(EcpError.empty, Checkout.empty);
    var b = PosCheckoutError(EcpError.empty, Checkout.empty);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos item not found error state', () {
    var testJson = ''' 
    {
      "attributes": {},
      "type": "FAILURE",
      "message": {
            "key": {
              "group": "orders",
              "code": "item-not-found"
            },
            "defaultMessage": "CatalogItem with id \${itemId} could not be found.",
            "placeholderValues": {
              "touchpointId": "test123"
            }
      }
    }
    ''';
    var ecpError = EcpErrorHandler.handleError(400, testJson);
    Map<String, dynamic> data = jsonDecode(mockNewCheckoutJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutError(
      ecpError,
      checkout,
      PosCheckoutErrorView.basket,
      PosCheckoutErrorCode.itemNotFound,
    );
    var b = PosCheckoutError(
      ecpError,
      checkout,
      PosCheckoutErrorView.basket,
      PosCheckoutErrorCode.itemNotFound,
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos item blocked error state', () {
    var testJson = ''' 
    {
        "attributes": {},
        "type": "FAILURE",
        "message": {
            "key": {
                "group": "orders",
                "code": "order-add-item-blocked-for-sale"
            },
            "defaultMessage": "Impossible to add item \${itemDescription}, item is blocked for sale.",
            "placeholderValues": {
                 "itemDescription": {
                     "default": {
                         "languageCode": "default",
                        "text": "Pepsi Zero Sugar"
                    }	
                }
            }
        }
    }
    ''';
    var ecpError = EcpErrorHandler.handleError(400, testJson);
    Map<String, dynamic> data = jsonDecode(mockNewCheckoutJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutError(
      ecpError,
      checkout,
      PosCheckoutErrorView.basket,
      PosCheckoutErrorCode.orderAddItemBlockedForSale,
    );
    var b = PosCheckoutError(
      ecpError,
      checkout,
      PosCheckoutErrorView.basket,
      PosCheckoutErrorCode.orderAddItemBlockedForSale,
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test checkout already exists error state', () {
    var testJson = ''' 
    {
        "attributes":{},
        "type":"FAILURE",
        "message":
        {
          "key":
          {
            "group":
            "pos",
            "code":
            "checkout-already-exists"
          },
          "defaultMessage":"Impossible to create a checkout for Touchpoint \${touchpointId}. There is already one ACTIVE.",
          "placeholderValues":
          {
            "touchpointId":"Test1"
          }
        }
      }
    ''';
    var ecpError = EcpErrorHandler.handleError(400, testJson);
    var a = PosCheckoutError(
      ecpError,
      Checkout.empty,
      PosCheckoutErrorView.none,
      PosCheckoutErrorCode.checkoutAlreadyExists,
    );
    var b = PosCheckoutError(
      ecpError,
      Checkout.empty,
      PosCheckoutErrorView.none,
      PosCheckoutErrorCode.checkoutAlreadyExists,
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos change quantity cannot be zero error state', () {
    var testJson = ''' 
      {
          "attributes": {},
          "type": "FAILURE",
          "message": {
              "key": {
                  "group": "orders",
                  "code": "order-change-item-quantity-less-than-zero"
              },
              "defaultMessage": "Cannot change the quantity for item \${itemDescription}. Quantity is less than 0.",
              "placeholderValues": {
                  "itemDescription": {
                      "default": {
                          "languageCode": "default",
                          "text": "Milk"
                      }
                  }
              }
          }
      }
    ''';
    var ecpError = EcpErrorHandler.handleError(400, testJson);
    Map<String, dynamic> data = jsonDecode(mockOneItemPosCheckoutJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutError(
      ecpError,
      checkout,
      PosCheckoutErrorView.basket,
      PosCheckoutErrorCode.orderChangeItemQuantityLessThanZero,
    );
    var b = PosCheckoutError(
      ecpError,
      checkout,
      PosCheckoutErrorView.basket,
      PosCheckoutErrorCode.orderChangeItemQuantityLessThanZero,
    );
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos checkout cancelled state', () {
    Map<String, dynamic> data = jsonDecode(mockCheckoutCancelledOneItemJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutCancelled(checkout);
    var b = PosCheckoutCancelled(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos new checkout started state', () {
    Map<String, dynamic> data = jsonDecode(mockNewCheckoutJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutStarted(checkout);
    var b = PosCheckoutStarted(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos checkout ready state', () {
    Map<String, dynamic> data = jsonDecode(mockNewCheckoutJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutReady(checkout);
    var b = PosCheckoutReady(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('Test PosOrderAdd item state', () {
    Map<String, dynamic> data = jsonDecode(mockOneItemPosCheckoutJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutOrderItemAdded(checkout);
    var b = PosCheckoutOrderItemAdded(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos payment added', () {
    Map<String, dynamic> data = jsonDecode(mockCheckoutOneItemPaidJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutPaymentAdded(checkout);
    var b = PosCheckoutPaymentAdded(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test order payment error state', () {
    Map<String, dynamic> data = jsonDecode(mockCheckoutOneItemPaidJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutAddPaymentError(EcpError.empty, checkout);
    var b = PosCheckoutAddPaymentError(EcpError.empty, checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos order completed state', () {
    Map<String, dynamic> data = jsonDecode(mockCheckoutOneItemPaidJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutOrderCompleted(checkout);
    var b = PosCheckoutOrderCompleted(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('Test PosCheckoutItemQuantityChanged state', () {
    Map<String, dynamic> data =
        jsonDecode(mockOneItemQuantityChangedPosCheckoutJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutItemQuantityChanged(checkout);
    var b = PosCheckoutItemQuantityChanged(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('test pos checkout finished state', () {
    Map<String, dynamic> data = jsonDecode(mockCheckoutFinishedJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutFinished(checkout);
    var b = PosCheckoutFinished(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('Test PosCheckoutItemVoided state', () {
    Map<String, dynamic> data = jsonDecode(mockCheckoutOneItemVoidedJSON);
    var checkout = Checkout.fromJson(data);
    var a = PosCheckoutItemVoided(checkout);
    var b = PosCheckoutItemVoided(checkout);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
