import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/ecp_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ECP Error Handler:', () {
    var testJSON = '''
    {
        "attributes": {},
        "type": "FAILURE",
        "message": {
            "key": {
                "group": "orders",
                "code": "item-not-found"
            },
            "defaultMessage": "ABCDEFG \${itemId} QRST",
            "placeholderValues": {
                "itemId": "-1"
            }
        }
    }
    ''';
    var testSpringJSON = '''
    {
        "timestamp": "2021-09-07T07:53:50.159+00:00",
        "path": "/orders",
        "status": 415,
        "error": "Unsupported Media Type",
        "requestId": "46de9efe"
    }
    ''';
    var testBlockedItemJson = ''' 
    {
        "attributes": {},
        "type": "FAILURE",
         "message": {
             "key": {
                 "group": "orders",
                 "code": "order-add-item-blocked-for-sale"
             },
             "defaultMessage": "Item \${itemDescription}, is blocked for sale.",
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
    test('Test handle EcpError', () {
      var ecpError = EcpErrorHandler.handleError(400, testJSON);

      expect(ecpError.type, EcpErrorTypeEnum.FAILURE);
      expect(ecpError.message.key.group, 'orders');
      expect(ecpError.message.key.code, 'item-not-found');
      expect(ecpError.message.defaultMessage, 'ABCDEFG \${itemId} QRST');
      expect(ecpError.message.placeholderValues['itemId'], '-1');
    });

    test('Test handle EcpError with description', () {
      var ecpError = EcpErrorHandler.handleError(400, testBlockedItemJson);

      expect(ecpError.type, EcpErrorTypeEnum.FAILURE);
      expect(ecpError.message.key.group, 'orders');
      expect(ecpError.message.key.code, 'order-add-item-blocked-for-sale');
      expect(
          ecpError.message.placeholderValues['itemDescription']['default']
              ['text'],
          'Pepsi Zero Sugar');
    });

    test('Test handle Spring Framework Error', () {
      var ecpError = EcpErrorHandler.handleError(415, testSpringJSON);

      expect(ecpError.type, EcpErrorTypeEnum.FAILURE);
      expect(ecpError.message.key.group, 'spring-framework');
      expect(ecpError.message.key.code, '415');
      expect(ecpError.message.defaultMessage,
          'path: /orders\nerror: Unsupported Media Type');
    });

    test('Test handleError can accept no data', () {
      var ecpError = EcpErrorHandler.handleError(400, '');

      expect(ecpError, EcpError.empty);
    });

    test('Test getPopulatedMessage with string value', () {
      var ecpError = EcpErrorHandler.handleError(400, testJSON);

      var message = EcpErrorHandler.getPopulatedMessage(ecpError);

      expect(message, 'ABCDEFG -1 QRST');
    });

    test('Test getPopulatedMessage with map value', () {
      var ecpError = EcpErrorHandler.handleError(400, testBlockedItemJson);

      var message = EcpErrorHandler.getPopulatedMessage(ecpError);

      expect(message, 'Item Pepsi Zero Sugar, is blocked for sale.');
    });
  });
}
