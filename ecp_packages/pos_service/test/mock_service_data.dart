import 'dart:convert';

import 'package:ecp_openapi/model/checkout.dart';

var mockNewCheckout = Checkout.fromJson(jsonDecode(mockNewCheckoutJSON));
var mockOneItemCheckout =
    Checkout.fromJson(jsonDecode(mockOneItemPosCheckoutJSON));
var mockEmptyPosOrderCheckout =
    Checkout.fromJson(jsonDecode(mockEmptyPosOrderCheckoutJSON));
var mockOneItemWithLinkedItem =
    Checkout.fromJson(jsonDecode(mockOneItemWithLinkedItemCheckoutJSON));
var mockCancelledCheckout =
    Checkout.fromJson(jsonDecode(mockCancelledCheckoutJSON));
var mockCheckoutOneItem =
    Checkout.fromJson(jsonDecode(mockCheckoutOneItemJSON));
var mockCheckoutCancelledOneItem =
    Checkout.fromJson(jsonDecode(mockCheckoutCancelledOneItemJSON));
var mockOneItemQuantityChangedPosCheckout =
    Checkout.fromJson(jsonDecode(mockOneItemQuantityChangedPosCheckoutJSON));
var mockCheckoutOneItemPaid =
    Checkout.fromJson(jsonDecode(mockCheckoutOneItemPaidJSON));
var mockCheckoutFinished =
    Checkout.fromJson(jsonDecode(mockCheckoutFinishedJSON));
var mockCheckoutTwoItem =
    Checkout.fromJson(jsonDecode(mockCheckoutTwoItemsJSON));
var mockCheckoutSevenItem =
    Checkout.fromJson(jsonDecode(mockCheckoutSevenItemsJSON));
var mockCheckoutOneItemVoided =
    Checkout.fromJson(jsonDecode(mockCheckoutOneItemVoidedJSON));
var mockCheckoutOneLinkedItemVoided =
    Checkout.fromJson(jsonDecode(mockCheckoutOneLinkedItemVoidedJSON));
var mockCheckoutSevenLinkedItems =
    Checkout.fromJson(jsonDecode(mockCheckoutSevenLinkedItemsJSON));
var mockCheckoutOneNegativeItem =
    Checkout.fromJson(jsonDecode(mockCheckoutOneNegativeItemJSON));
var mockCheckoutTwoNegativeItems =
    Checkout.fromJson(jsonDecode(mockCheckoutTwoNegativeItemsJSON));
var mockCheckoutOneNegativeNormalLinkedItems =
    Checkout.fromJson(jsonDecode(mockCheckoutOneNegativeNormalLinkedItemsJSON));

const String mockNewCheckoutJSON = '''
    {
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 1,
        "creationTimestamp": "2021-09-30T16:40:56.768893Z",
        "lastModificationTimestamp": "2021-09-30T16:40:56.770265Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 1,
            "creationTimestamp": "2021-09-30T16:40:56.761724Z",
            "lastModificationTimestamp": "2021-09-30T16:40:56.761729Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 0,
            "amount": 0,
            "paidAmount": 0,
            "changeDue": 0,
            "totalItemQuantity": 0,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const mockOneItemWithLinkedItemCheckoutJSON = '''
{
    "checkoutId": "615d57c5c9866f06ac32e990",
    "touchpointId": "test123",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 2,
        "creationTimestamp": "2021-10-06T08:01:09.238Z",
        "lastModificationTimestamp": "2021-10-06T08:02:36.884522Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 2,
            "creationTimestamp": "2021-10-06T08:01:09.233Z",
            "lastModificationTimestamp": "2021-10-06T08:02:36.877215Z",
            "lastModificationUser": ""
        },
        "orderId": "615d57c5f2ab7f4b405ee4f3",
        "items": [
            {
                "orderItemId": "615d581cf2ab7f4b405ee4f8",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "89852316",
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "615d581cf2ab7f4b405ee4f9",
                "parentOrderItemId": "615d581cf2ab7f4b405ee4f8",
                "item": {
                    "itemId": "00000002",
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 5.03,
            "amount": 5.03,
            "paidAmount": 0,
            "changeDue": -5.03,
            "totalItemQuantity": 2,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const mockOneItemPosCheckoutJSON = '''
{
    "checkoutId": "615c5405c9866f06ac32e989",
    "touchpointId": "test123",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 2,
        "creationTimestamp": "2021-10-05T13:32:53.023Z",
        "lastModificationTimestamp": "2021-10-05T13:33:58.172924Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 2,
            "creationTimestamp": "2021-10-05T13:32:53.016Z",
            "lastModificationTimestamp": "2021-10-05T13:33:58.164657Z",
            "lastModificationUser": ""
        },
        "orderId": "615c5405f2ab7f4b405ee4e7",
        "items": [
            {
                "orderItemId": "615c5446f2ab7f4b405ee4e8",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 2.22,
            "amount": 2.22,
            "paidAmount": 0,
            "changeDue": -2.22,
            "totalItemQuantity": 1,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const mockCheckoutOneNegativeItemJSON = ''' 
{
    "checkoutId":"618a8738da6ffe0b6f2649bc",
    "touchpointId":"2021-11-09 16:35:25.968270",
    "metadata": {
        "modelVersion":"",
        "entityVersion":2,
        "creationTimestamp":"2021-11-09T14:35:36.537Z",
        "lastModificationTimestamp":"2021-11-09T14:35:40.006677Z",
        "lastModificationUser":""
    },
    "state":"ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion":"",
            "entityVersion":2,
            "creationTimestamp":"2021-11-09T14:35:36.534Z",
            "lastModificationTimestamp":"2021-11-09T14:35:39.997737Z",
            "lastModificationUser":""
        },
        "orderId":"618a8738db9524412faaf719",
        "items": [
            {
                "orderItemId":"618a873bdb9524412faaf71a",
                "parentOrderItemId":null,
                "item": {
                    "catalogItemId":"10",
                    "catalogId":"CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode":"default",
                            "text":"Negative price item"
                         }
                    },
                    "aliases":[],
                    "quantityRequired":false,
                    "quantityAllowed":true,
                    "minimumQuantity":1,
                    "maximumQuantity":10000,
                    "quantityChangeAllowed":true,
                    "salesUnitOfMeasure":"EACH",
                    "priceEntryRequired":false,
                    "priceChangeAllowed":false,
                    "priceChangeMinimumAmount":0,
                    "priceChangeMaximumAmount":0,
                    "blockedForSale":false,
                    "customerMinimumAge":0,
                    "operatorMinimumAge":0,
                    "linkedItems":[],
                    "depositItem":false,
                    "attributes":{},
                    "negativePrice":true,
                    "unitPrice":10,
                    "metadata": {
                        "modelVersion":"0.0.1",
                        "entityVersion":2,
                        "creationTimestamp":"2021-09-30T09:17:56.733Z",
                        "lastModificationTimestamp":"2021-11-08T11:00:24.073Z",
                        "lastModificationUser":"automatedTest"
                    }
                },
                "unitPrice":-10,
                "quantity":1,
                "amountWithoutTax":-10,
                "amount":-10,
                "taxes":[],
                "voided":false,
                "attributes":{},
                "entryData":"10",
                "entryMethod":"MANUAL",
                "currencyCode":"EUR"
            }
        ],
    "payments":[],
    "totals": {
        "discountAmount":0,
        "amountWithoutTax":-10,
        "amount":-10,
        "paidAmount":0,
        "changeDue":10,
        "totalItemQuantity":1,
        "taxes":[],
        "currencyCode":"EUR"
    },
    "state":"CHECKOUT",
    "attributes":{},
    "currencyCode":"EUR"
    }
}
''';

const mockCheckoutTwoNegativeItemsJSON = ''' 
{
    "checkoutId":"618a8738da6ffe0b6f2649bc",
    "touchpointId":"2021-11-09 16:35:25.968270",
    "metadata": {
        "modelVersion":"",
        "entityVersion":3,
        "creationTimestamp":"2021-11-09T14:35:36.537Z",
        "lastModificationTimestamp":"2021-11-09T14:35:40.006677Z",
        "lastModificationUser":""
    },
    "state":"ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion":"",
            "entityVersion":3,
            "creationTimestamp":"2021-11-09T14:35:36.534Z",
            "lastModificationTimestamp":"2021-11-09T14:35:39.997737Z",
            "lastModificationUser":""
        },
        "orderId":"618a8738db9524412faaf719",
        "items": [
            {
                "orderItemId":"618a873bdb9524412faaf71a",
                "parentOrderItemId":null,
                "item": {
                    "catalogItemId":"10",
                    "catalogId":"CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode":"default",
                            "text":"Negative price item"
                         }
                    },
                    "aliases":[],
                    "quantityRequired":false,
                    "quantityAllowed":true,
                    "minimumQuantity":1,
                    "maximumQuantity":10000,
                    "quantityChangeAllowed":true,
                    "salesUnitOfMeasure":"EACH",
                    "priceEntryRequired":false,
                    "priceChangeAllowed":false,
                    "priceChangeMinimumAmount":0,
                    "priceChangeMaximumAmount":0,
                    "blockedForSale":false,
                    "customerMinimumAge":0,
                    "operatorMinimumAge":0,
                    "linkedItems":[],
                    "depositItem":false,
                    "attributes":{},
                    "negativePrice":true,
                    "unitPrice":10,
                    "metadata": {
                        "modelVersion":"0.0.1",
                        "entityVersion":3,
                        "creationTimestamp":"2021-09-30T09:17:56.733Z",
                        "lastModificationTimestamp":"2021-11-08T11:00:24.073Z",
                        "lastModificationUser":"automatedTest"
                    }
                },
                "unitPrice":-10,
                "quantity":1,
                "amountWithoutTax":-10,
                "amount":-10,
                "taxes":[],
                "voided":false,
                "attributes":{},
                "entryData":"10",
                "entryMethod":"MANUAL",
                "currencyCode":"EUR"
            },
            {
                "orderItemId":"618a873bdb9524412faaf71a",
                "parentOrderItemId":null,
                "item": {
                    "catalogItemId":"10",
                    "catalogId":"CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode":"default",
                            "text":"Negative price item"
                         }
                    },
                    "aliases":[],
                    "quantityRequired":false,
                    "quantityAllowed":true,
                    "minimumQuantity":1,
                    "maximumQuantity":10000,
                    "quantityChangeAllowed":true,
                    "salesUnitOfMeasure":"EACH",
                    "priceEntryRequired":false,
                    "priceChangeAllowed":false,
                    "priceChangeMinimumAmount":0,
                    "priceChangeMaximumAmount":0,
                    "blockedForSale":false,
                    "customerMinimumAge":0,
                    "operatorMinimumAge":0,
                    "linkedItems":[],
                    "depositItem":false,
                    "attributes":{},
                    "negativePrice":true,
                    "unitPrice":10,
                    "metadata": {
                        "modelVersion":"0.0.1",
                        "entityVersion":3,
                        "creationTimestamp":"2021-09-30T09:17:56.733Z",
                        "lastModificationTimestamp":"2021-11-08T11:00:24.073Z",
                        "lastModificationUser":"automatedTest"
                    }
                },
                "unitPrice":-10,
                "quantity":1,
                "amountWithoutTax":-10,
                "amount":-10,
                "taxes":[],
                "voided":false,
                "attributes":{},
                "entryData":"10",
                "entryMethod":"MANUAL",
                "currencyCode":"EUR"
            }          
        ],
    "payments":[],
    "totals": {
        "discountAmount":0,
        "amountWithoutTax":-20,
        "amount":-20,
        "paidAmount":0,
        "changeDue":20,
        "totalItemQuantity":2,
        "taxes":[],
        "currencyCode":"EUR"
    },
    "state":"CHECKOUT",
    "attributes":{},
    "currencyCode":"EUR"
    }
}
''';

const mockCheckoutOneNegativeNormalLinkedItemsJSON = ''' 
{
    "checkoutId":"618a8738da6ffe0b6f2649bc",
    "touchpointId":"2021-11-09 16:35:25.968270",
    "metadata": {
        "modelVersion":"",
        "entityVersion":4,
        "creationTimestamp":"2021-11-09T14:35:36.537Z",
        "lastModificationTimestamp":"2021-11-09T14:35:40.006677Z",
        "lastModificationUser":""
    },
    "state":"ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion":"",
            "entityVersion":4,
            "creationTimestamp":"2021-11-09T14:35:36.534Z",
            "lastModificationTimestamp":"2021-11-09T14:35:39.997737Z",
            "lastModificationUser":""
        },
        "orderId":"618a8738db9524412faaf719",
        "items": [
            {
                "orderItemId":"618a873bdb9524412faaf71a",
                "parentOrderItemId":null,
                "item": {
                    "catalogItemId":"10",
                    "catalogId":"CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode":"default",
                            "text":"Negative price item"
                         }
                    },
                    "aliases":[],
                    "quantityRequired":false,
                    "quantityAllowed":true,
                    "minimumQuantity":1,
                    "maximumQuantity":10000,
                    "quantityChangeAllowed":true,
                    "salesUnitOfMeasure":"EACH",
                    "priceEntryRequired":false,
                    "priceChangeAllowed":false,
                    "priceChangeMinimumAmount":0,
                    "priceChangeMaximumAmount":0,
                    "blockedForSale":false,
                    "customerMinimumAge":0,
                    "operatorMinimumAge":0,
                    "linkedItems":[],
                    "depositItem":false,
                    "attributes":{},
                    "negativePrice":true,
                    "unitPrice":10,
                    "metadata": {
                        "modelVersion":"0.0.1",
                        "entityVersion":4,
                        "creationTimestamp":"2021-09-30T09:17:56.733Z",
                        "lastModificationTimestamp":"2021-11-08T11:00:24.073Z",
                        "lastModificationUser":"automatedTest"
                    }
                },
                "unitPrice":-10,
                "quantity":1,
                "amountWithoutTax":-10,
                "amount":-10,
                "taxes":[],
                "voided":false,
                "attributes":{},
                "entryData":"10",
                "entryMethod":"MANUAL",
                "currencyCode":"EUR"
            },
            {
                "orderItemId": "615c5446f2ab7f4b405ee4e8",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 2,
                "amountWithoutTax": 4.44,
                "amount": 4.44,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
              },
              {
                "orderItemId": "616d70c1991e3d3d78bd21d8",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 4,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c1991e3d3d78bd21d9",
                "parentOrderItemId": "616d70c1991e3d3d78bd21d8",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR" 
            }     
        ],
    "payments":[],
    "totals": {
        "discountAmount":0,
        "amountWithoutTax":-2.75,
        "amount":-2.75,
        "paidAmount":0,
        "changeDue":2.75,
        "totalItemQuantity":4,
        "taxes":[],
        "currencyCode":"EUR"
    },
    "state":"CHECKOUT",
    "attributes":{},
    "currencyCode":"EUR"
    }
}
''';

const mockOneItemQuantityChangedPosCheckoutJSON = '''
{
    "checkoutId": "615c5405c9866f06ac32e989",
    "touchpointId": "test123",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 3,
        "creationTimestamp": "2021-10-05T13:32:53.023Z",
        "lastModificationTimestamp": "2021-10-05T13:33:58.172924Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 3,
            "creationTimestamp": "2021-10-05T13:32:53.016Z",
            "lastModificationTimestamp": "2021-10-05T13:33:58.164657Z",
            "lastModificationUser": ""
        },
        "orderId": "615c5405f2ab7f4b405ee4e7",
        "items": [
            {
                "orderItemId": "615c5446f2ab7f4b405ee4e8",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 2,
                "amountWithoutTax": 4.44,
                "amount": 4.44,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 4.44,
            "amount": 4.44,
            "paidAmount": 0,
            "changeDue": -4.44,
            "totalItemQuantity": 2,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const mockEmptyPosOrderCheckoutJSON = '''
{
    "checkoutId": "615c5405c9866f06ac32e989",
    "touchpointId": "test123",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 1,
        "creationTimestamp": "2021-10-05T13:32:53.023736Z",
        "lastModificationTimestamp": "2021-10-05T13:32:53.02519Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 1,
            "creationTimestamp": "2021-10-05T13:32:53.016607Z",
            "lastModificationTimestamp": "2021-10-05T13:32:53.016612Z",
            "lastModificationUser": ""
        },
        "orderId": "615c5405f2ab7f4b405ee4e7",
        "items": [],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 0,
            "amount": 0,
            "paidAmount": 0,
            "changeDue": 0,
            "totalItemQuantity": 0,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCancelledCheckoutJSON = '''
    {
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 2,
        "creationTimestamp": "2021-09-30T16:40:56.768893Z",
        "lastModificationTimestamp": "2021-09-30T16:40:56.770265Z",
        "lastModificationUser": ""
    },
    "state": "FINISHED",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 2,
            "creationTimestamp": "2021-09-30T16:40:56.761724Z",
            "lastModificationTimestamp": "2021-09-30T16:40:56.761729Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 0,
            "amount": 0,
            "paidAmount": 0,
            "changeDue": 0,
            "totalItemQuantity": 0,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CANCELLED",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutOneItemJSON = '''
{
    "checkoutId": "615c5405c9866f06ac32e989",
    "touchpointId": "test123",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 2,
        "creationTimestamp": "2021-10-02T21:29:52.347Z",
        "lastModificationTimestamp": "2021-10-02T21:30:03.585384Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 2,
            "creationTimestamp": "2021-10-02T21:29:52.334Z",
            "lastModificationTimestamp": "2021-10-02T21:30:03.577606Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [
            {
                "orderItemId": "615c5446f2ab7f4b405ee4e8",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 2.22,
            "amount": 2.22,
            "paidAmount": 0,
            "changeDue": -2.22,
            "totalItemQuantity": 1,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutOneItemVoidedJSON = '''
{
    "checkoutId": "615c5405c9866f06ac32e989",
    "touchpointId": "test123",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 3,
        "creationTimestamp": "2021-10-02T21:29:52.347Z",
        "lastModificationTimestamp": "2021-10-02T21:30:03.585384Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 3,
            "creationTimestamp": "2021-10-02T21:29:52.334Z",
            "lastModificationTimestamp": "2021-10-02T21:30:03.577606Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [
            {
                "orderItemId": "615c5446f2ab7f4b405ee4e8",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 3,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": true,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 2.22,
            "amount": 2.22,
            "paidAmount": 0,
            "changeDue": -2.22,
            "totalItemQuantity": 1,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutCancelledOneItemJSON = '''
{
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 3,
        "creationTimestamp": "2021-10-02T21:29:52.347Z",
        "lastModificationTimestamp": "2021-10-02T21:31:25.154521Z",
        "lastModificationUser": ""
    },
    "state": "FINISHED",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 3,
            "creationTimestamp": "2021-10-02T21:29:52.334Z",
            "lastModificationTimestamp": "2021-10-02T21:31:25.147437Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [
            {
                "orderItemId": "1",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 2.22,
            "amount": 2.22,
            "paidAmount": 0,
            "changeDue": -2.22,
            "totalItemQuantity": 1,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CANCELLED",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';
const String mockCheckoutOneItemPaidJSON = '''
{
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 2,
        "creationTimestamp": "2021-10-02T21:29:52.347Z",
        "lastModificationTimestamp": "2021-10-02T21:30:03.585384Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 2,
            "creationTimestamp": "2021-10-02T21:29:52.334Z",
            "lastModificationTimestamp": "2021-10-02T21:30:03.577606Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [
            {
                "orderItemId": "1",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [
            {
                "orderPaymentId": "1",
                "authorizedAmount": {
                    "amount": 1.00,
                    "currencyCode": "EUR"
                },
                "tender": {
                    "tenderId": "1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": ""
                        }
                    },
                    "currencyCode": "EUR",
                    "attributes": {}
                },
                "voided": false,
                "attributes": {}
            }
        ],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 2.22,
            "amount": 2.22,
            "paidAmount": 1.00,
            "changeDue": -1.22,
            "totalItemQuantity": 1,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutFinishedJSON = '''
{
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 2,
        "creationTimestamp": "2021-10-07T10:15:19.292Z",
        "lastModificationTimestamp": "2021-10-07T10:15:31.271769Z",
        "lastModificationUser": ""
    },
    "state": "FINISHED",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 2,
            "creationTimestamp": "2021-10-07T10:15:19.288Z",
            "lastModificationTimestamp": "2021-10-07T10:15:31.267949Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 0,
            "amount": 0,
            "paidAmount": 0,
            "changeDue": 0,
            "totalItemQuantity": 0,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "COMPLETED",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutTwoItemsJSON = '''
{
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 3,
        "creationTimestamp": "2021-10-08T20:55:01.578Z",
        "lastModificationTimestamp": "2021-10-08T21:16:02.135881Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 3,
            "creationTimestamp": "2021-10-08T20:55:01.573Z",
            "lastModificationTimestamp": "2021-10-08T21:16:02.131339Z",
            "lastModificationUser": ""
        },
        "orderId": "1",
        "items": [
            {
                "orderItemId": "1",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "2",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "40123455",
                    "catalogItemId": "40123455",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Burger"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 10,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 10,
                "quantity": 1,
                "amountWithoutTax": 10,
                "amount": 10,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "40123455",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 12.22,
            "amount": 12.22,
            "paidAmount": 0,
            "changeDue": -12.22,
            "totalItemQuantity": 2,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutSevenLinkedItemsJSON = '''
{
    "checkoutId": "616d70813dddc23a29ce497b",
    "touchpointId": "vali123",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 8,
        "creationTimestamp": "2021-10-18T13:02:57.916Z",
        "lastModificationTimestamp": "2021-10-18T13:04:16.261833Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 8,
            "creationTimestamp": "2021-10-18T13:02:57.912Z",
            "lastModificationTimestamp": "2021-10-18T13:04:16.247752Z",
            "lastModificationUser": ""
        },
        "orderId": "616d7081991e3d3d78bd21d4",
        "items": [
            {
                "orderItemId": "616d70c1991e3d3d78bd21d8",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c1991e3d3d78bd21d9",
                "parentOrderItemId": "616d70c1991e3d3d78bd21d8",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c6991e3d3d78bd21da",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c6991e3d3d78bd21db",
                "parentOrderItemId": "616d70c6991e3d3d78bd21da",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c7991e3d3d78bd21dc",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c7991e3d3d78bd21dd",
                "parentOrderItemId": "616d70c7991e3d3d78bd21dc",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c9991e3d3d78bd21de",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70c9991e3d3d78bd21df",
                "parentOrderItemId": "616d70c9991e3d3d78bd21de",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70ca991e3d3d78bd21e0",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70ca991e3d3d78bd21e1",
                "parentOrderItemId": "616d70ca991e3d3d78bd21e0",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70cb991e3d3d78bd21e2",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70cb991e3d3d78bd21e3",
                "parentOrderItemId": "616d70cb991e3d3d78bd21e2",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70d0991e3d3d78bd21e4",
                "parentOrderItemId": null,
                "item": {
                    "catalogItemId": "89852316",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Diet Coke EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000002"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 4.88,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:49:04.676Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 4.88,
                "quantity": 1,
                "amountWithoutTax": 4.88,
                "amount": 4.88,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "89852316",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "616d70d0991e3d3d78bd21e5",
                "parentOrderItemId": "616d70d0991e3d3d78bd21e4",
                "item": {
                    "catalogItemId": "00000002",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "linked item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.15,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.15,
                "quantity": 1,
                "amountWithoutTax": 0.15,
                "amount": 0.15,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "00000002",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 35.21,
            "amount": 35.21,
            "paidAmount": 0,
            "changeDue": -35.21,
            "totalItemQuantity": 14,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutSevenItemsJSON = '''
{
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 8,
        "creationTimestamp": "2021-10-08T21:19:00.85Z",
        "lastModificationTimestamp": "2021-10-08T21:19:31.624701Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 8,
            "creationTimestamp": "2021-10-08T21:19:00.846Z",
            "lastModificationTimestamp": "2021-10-08T21:19:31.61578Z",
            "lastModificationUser": ""
        },
        "orderId": "6160b5c4f2ab7f4b405ee584",
        "items": [
            {
                "orderItemId": "1",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "2",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "3",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "4",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "5",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "6",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "7",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "232323",
                    "catalogItemId": "232323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Milk"
                        }
                    },
                    "aliases": [
                        "230"
                    ],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 2.22,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-09-29T10:23:58.917Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 2.22,
                "quantity": 1,
                "amountWithoutTax": 2.22,
                "amount": 2.22,
                "taxes": [],
                "voided": false,
                "attributes": {},
                "entryData": "232323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 15.54,
            "amount": 15.54,
            "paidAmount": 0,
            "changeDue": -15.54,
            "totalItemQuantity": 7,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';

const String mockCheckoutOneLinkedItemVoidedJSON = '''
{
    "checkoutId": "1",
    "touchpointId": "1",
    "metadata": {
        "modelVersion": "",
        "entityVersion": 3,
        "creationTimestamp": "2021-10-08T21:27:38.968Z",
        "lastModificationTimestamp": "2021-10-08T21:28:32.758973Z",
        "lastModificationUser": ""
    },
    "state": "ACTIVE",
    "posOrder": {
        "metadata": {
            "modelVersion": "",
            "entityVersion": 3,
            "creationTimestamp": "2021-10-08T21:27:38.963Z",
            "lastModificationTimestamp": "2021-10-08T21:28:32.753712Z",
            "lastModificationUser": ""
        },
        "orderId": "6160b7caf2ab7f4b405ee58e",
        "items": [
            {
                "orderItemId": "1",
                "parentOrderItemId": null,
                "item": {
                    "itemId": "89852323",
                    "catalogItemId": "89852323",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "Coke Cherry EAN 8"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [
                        "00000001"
                    ],
                    "depositItem": false,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 5,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 2,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-08-27T08:48:16.243Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 5,
                "quantity": 1,
                "amountWithoutTax": 5,
                "amount": 5,
                "taxes": [],
                "voided": true,
                "attributes": {},
                "entryData": "89852323",
                "entryMethod": "SCANNED",
                "currencyCode": "EUR"
            },
            {
                "orderItemId": "1001",
                "parentOrderItemId": "1",
                "item": {
                    "itemId": "00000001",
                    "catalogItemId": "00000001",
                    "catalogId": "CATALOG_1",
                    "description": {
                        "default": {
                            "languageCode": "default",
                            "text": "deposit item"
                        }
                    },
                    "aliases": [],
                    "quantityRequired": false,
                    "quantityAllowed": true,
                    "minimumQuantity": 1,
                    "maximumQuantity": 10000,
                    "quantityChangeAllowed": true,
                    "salesUnitOfMeasure": "EACH",
                    "priceEntryRequired": false,
                    "priceChangeAllowed": false,
                    "priceChangeMinimumAmount": 0,
                    "priceChangeMaximumAmount": 0,
                    "blockedForSale": false,
                    "customerMinimumAge": 0,
                    "operatorMinimumAge": 0,
                    "linkedItems": [],
                    "depositItem": true,
                    "attributes": {},
                    "negativePrice": false,
                    "unitPrice": 0.05,
                    "metadata": {
                        "modelVersion": "0.0.1",
                        "entityVersion": 1,
                        "creationTimestamp": "2021-06-08T09:17:56.733Z",
                        "lastModificationTimestamp": "2021-06-11T09:25:37.752Z",
                        "lastModificationUser": "testData"
                    }
                },
                "unitPrice": 0.05,
                "quantity": 1,
                "amountWithoutTax": 0.05,
                "amount": 0.05,
                "taxes": [],
                "voided": true,
                "attributes": {},
                "entryData": "00000001",
                "entryMethod": "AUTOMATIC",
                "currencyCode": "EUR"
            }
        ],
        "payments": [],
        "totals": {
            "discountAmount": 0,
            "amountWithoutTax": 0,
            "amount": 0,
            "paidAmount": 0,
            "changeDue": 0,
            "totalItemQuantity": 0,
            "taxes": [],
            "currencyCode": "EUR"
        },
        "state": "CHECKOUT",
        "attributes": {},
        "currencyCode": "EUR"
    }
}
''';
